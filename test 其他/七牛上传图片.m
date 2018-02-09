#import "QiNiuTool.h"
#import "JKRAccountTool.h"
#import "JKRAccount.h"
#import "QiniuSDK.h"
#import "QiNiuUpLoadResult.h"
#import <UIKit/UIKit.h>

@implementation QiNiuTool

+ (void)uploadImages:(NSArray *)images complete:(void (^)(NSDictionary *))complete
{
    QNUploadManager *qnm = [[QNUploadManager alloc] init];
    NSDateFormatter *mattter = [[NSDateFormatter alloc]init];
    [mattter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *Nowdate = [mattter stringFromDate:[NSDate date]];
    
    QiNiuUpLoadResult *result = [[QiNiuUpLoadResult alloc] init];
    
    __block int count = 0;
    
    for (int i = 0; i < images.count; i++) {
        
        UIImage *image = images[i];
        
        NSData *uploadData = UIImageJPEGRepresentation(image, 1);
        
        //这里对大图片做了压缩，不需要的话下面直接传uploadData就好
        NSData *cutdownData = nil;
        if (uploadData.length < 9999) {
            cutdownData = UIImageJPEGRepresentation(image, 1.0);
        } else if (uploadData.length < 99999) {
            cutdownData = UIImageJPEGRepresentation(image, 0.6);
        } else {
            cutdownData = UIImageJPEGRepresentation(image, 0.3);
        }
        
        //[JKRAccountTool getAccount].token:token
        [qnm putData:cutdownData key:[NSString stringWithFormat:@"%@%d", Nowdate, i+1] token:[JKRAccountTool getAccount].token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            count++;
            
            NSString *resultKey = [NSString stringWithFormat:@"%d",i];
            
            result.keys[resultKey] = [resp objectForKey:@"key"];
            
            if (count == images.count) {
                complete(result.keys);
            }
            
        } option:nil];
        
    }
    
}

@end