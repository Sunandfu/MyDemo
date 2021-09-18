//
//  AdController.m
//  SingularPublisherSampleApp
//
//  Created by Eyal Rabinovich on 24/06/2020.
//

#import "AdController.h"


@implementation AdController

- (id)initWithProductParameters:(NSDictionary*)data {
    self = [super init];
    self->productParameters = data;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请注意，为了使用loadProductWithParameters，
    //您的ViewController必须从SKStoreProductViewController继承
    //步骤4：显示AppStore窗口以及我们从广告网络获得的产品。
    [self loadProductWithParameters:self->productParameters completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (error || !result){
            //加载广告失败，请尝试加载其他广告或重试当前广告。
        } else {
            //广告加载成功！：）
        }
    }];
}

@end
