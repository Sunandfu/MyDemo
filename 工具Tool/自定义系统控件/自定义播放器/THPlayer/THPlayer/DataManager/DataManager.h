 

#import <Foundation/Foundation.h>

typedef void(^onSuccess)(NSArray *sidArray,NSArray *videoArray);
typedef void(^onFailed)(NSError *error);

@interface DataManager : NSObject

@property(nonatomic,copy)NSArray *sidArray;
@property(nonatomic,copy)NSArray *videoArray;



+(DataManager *)shareManager;
- (void)getSIDArrayWithURLString:(NSString *)URLString success:(onSuccess)success failed:(onFailed)failed;

- (void)getVideoListWithURLString:(NSString *)URLString ListID:(NSString *)ID success:(onSuccess)success failed:(onFailed)failed;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com