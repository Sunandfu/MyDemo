//
//  ViewController.m
//  SingularPublisherSampleApp
//
//  Created by Eyal Rabinovich on 24/06/2020.
//

#import "ViewController.h"
#import "AdController.h"

// Don't forget to import this to have access to the SKAdnetwork consts
#import <StoreKit/SKAdNetwork.h>

@interface ViewController ()

@end

@implementation ViewController

//广告请求密钥
NSString * const REQUEST_SOURCE_APP_ID_KEY = @"source_app_id";
NSString * const REQUEST_SKADNETWORK_VERSION_KEY = @"skadnetwork_version";

//广告请求值
NSString * const REQUEST_SOURCE_APP_ID = @"<ENTER_SOURCE_APP_ID_HERE>";
NSString * const REQUEST_SKADNETWORK_V1 = @"1.0";
NSString * const REQUEST_SKADNETWORK_V2 = @"2.0";

//我们使用HTTP进行本地测试，使用HTTPS进行生产。
NSString * const REQUEST_AD_SERVER_ADDRESS = @"http://<ENTER_YOU_SERVER_IP_HERE>:8000/get-ad-impression";

//广告响应密钥-这些密钥与我们的服务器相同，但真实的广告网络可能返回不同的密钥。
NSString * const RESPONSE_AD_NETWORK_ID_KEY = @"adNetworkId";
NSString * const RESPONSE_SOURCE_APP_ID_KEY = @"sourceAppId";
NSString * const RESPONSE_SKADNETWORK_VERSION_KEY = @"adNetworkVersion";
NSString * const RESPONSE_TARGET_APP_ID_KEY = @"id";
NSString * const RESPONSE_SIGNATURE_KEY = @"signature";
NSString * const RESPONSE_CAMPAIGN_ID_KEY = @"campaignId";
NSString * const RESPONSE_TIMESTAMP_KEY = @"timestamp";
NSString * const RESPONSE_NONCE_KEY = @"nonce";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showAdClick:(id)sender {
    //步骤1：从模拟真实广告网络API的python服务器检索广告数据。
    //我们的服务器使用adnetwork密钥对ad有效负载进行签名。
    //有关更多信息，请查看repo中的skadnetwork_服务器文件夹。
    [self getProductDataFromServer];
}

- (void)getProductDataFromServer {
    //为服务器的GET请求生成URL
    NSURLComponents *components = [NSURLComponents componentsWithString:REQUEST_AD_SERVER_ADDRESS];
    NSURLQueryItem *sourceAppId = [NSURLQueryItem queryItemWithName:REQUEST_SOURCE_APP_ID_KEY value:REQUEST_SOURCE_APP_ID];
    
    //广告网络需要根据SKAdNetwork版本生成不同的签名。
    //对于14.0以下的操作系统版本，我们应该通过“1.0”，而对于14.0及以上的版本，我们需要通过“2.0”。
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSURLQueryItem *skAdNetworkVersion = [NSURLQueryItem
                                          queryItemWithName:REQUEST_SKADNETWORK_VERSION_KEY
                                          value:osVersion < 14 ? REQUEST_SKADNETWORK_V1 : REQUEST_SKADNETWORK_V2];
    
    components.queryItems = @[ skAdNetworkVersion, sourceAppId ];
    
    //向服务器发送异步GET请求以获取Ad数据。
    [[[NSURLSession sharedSession] dataTaskWithURL:components.URL
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            return;
        }
        
        //步骤2：解析我们从Ad网络获得的数据，以符合AdController中的“loadProductWithParameters”格式。
        NSDictionary* productParameters = [self parseResponseDataToProductParameters:data];
        
        if (!productParameters){
            return;
        }
        
        //步骤3：用我们从广告网络获得的产品数据显示AdController。
        [self loadProductFromResponseData:productParameters];
    }] resume];
}

- (void)loadProductFromResponseData:(NSDictionary*)productParameters {
    if (!productParameters){
        return;
    }
    
    //初始化并显示带有产品参数的AdController。
    //下一步请查看AdController中的“viewDidLoad”方法。
    dispatch_async(dispatch_get_main_queue(), ^{
        AdController* adController = [[AdController alloc] initWithProductParameters:productParameters];
        [self showViewController:adController sender:self];
    });
}

//此函数获取服务器的响应并将其转换为loadProductWithParameters格式。
- (NSDictionary*)parseResponseDataToProductParameters:(NSData*)data{
    if (!data){
        return nil;
    }
    
    NSError* error;
    NSDictionary* responseData = [[NSMutableDictionary alloc]initWithDictionary:
                                        [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error]];
    
    if (error){
        return nil;
    }
    
    NSMutableDictionary* productParameters = [[NSMutableDictionary alloc] init];
    
    
    
    //不要忘记导入<StoreKit/SKAdNetwork.h>以访问SKAdNetwork常量
    //这些产品参数应为NSString*类型。
    [productParameters setObject:[responseData objectForKey:RESPONSE_SIGNATURE_KEY] forKey:SKStoreProductParameterAdNetworkAttributionSignature];
    [productParameters setObject:[responseData objectForKey:RESPONSE_TARGET_APP_ID_KEY] forKey:SKStoreProductParameterITunesItemIdentifier];
    [productParameters setObject:[responseData objectForKey:RESPONSE_AD_NETWORK_ID_KEY] forKey:SKStoreProductParameterAdNetworkIdentifier];
    
    //这些产品参数应为NSNumber*类型。
    [productParameters setObject:@([[responseData objectForKey:RESPONSE_CAMPAIGN_ID_KEY] intValue]) forKey:SKStoreProductParameterAdNetworkCampaignIdentifier];
    [productParameters setObject:@([[responseData objectForKey:RESPONSE_TIMESTAMP_KEY] longLongValue]) forKey:SKStoreProductParameterAdNetworkTimestamp];
    
    if (@available(iOS 14, *)) {
        NSString* skAdNetworkVersion = [responseData objectForKey:RESPONSE_SKADNETWORK_VERSION_KEY];
        
        //这些产品参数仅包含在SKAdNetwork 2.0版中
        if ([skAdNetworkVersion isEqualToString:REQUEST_SKADNETWORK_V2]) {
            [productParameters setObject:skAdNetworkVersion forKey:SKStoreProductParameterAdNetworkVersion];
            [productParameters setObject:@([[responseData objectForKey:RESPONSE_SOURCE_APP_ID_KEY] intValue]) forKey:SKStoreProductParameterAdNetworkSourceAppStoreIdentifier];
        }
    }
    
    //此参数必须为NSUUID类型，如果以NSString*类型传递，则会引发异常。
    [productParameters setObject:[[NSUUID alloc] initWithUUIDString:[responseData objectForKey:RESPONSE_NONCE_KEY]] forKey:SKStoreProductParameterAdNetworkNonce];
    
    return productParameters;
}

- (IBAction)showSingularClick:(id)sender {
    NSURL* singular = [NSURL URLWithString:@"https://www.singular.net?utm_medium=sample-app&utm_source=sample-app-publisher"];
    
    if( [[UIApplication sharedApplication] canOpenURL:singular]){
        [[UIApplication sharedApplication] openURL:singular options:[[NSDictionary alloc] init] completionHandler:nil];
    }
}

@end
