

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？



#import <UIKit/UIKit.h>

@interface BAButton : UIButton
/*! 过期属性或方法名提醒 */
#define BANetManagerDeprecated(instead) __deprecated_msg(instead)

typedef NS_ENUM(NSUInteger, BABAButtonStatus) {
    BABAButtonStatusNormal, // 默认
    BABAButtonStatusLeft, // 左对齐
    BABAButtonStatusCenter, // 居中对齐
    BABAButtonStatusRight, // 右对齐
    BABAButtonStatusTop, // 图标在上，文本在下(居中)
    BABAButtonStatusBottom, // 图标在下，文本在上(居中)
};

/*! 设置样式 */
@property (nonatomic, assign) BABAButtonStatus buttonStatus;
/*! 设置圆角 */
@property (nonatomic, assign) CGFloat buttonCornerRadius;



#pragma mark - 过期方法
+ (instancetype _Nonnull)BA_ShareButton BANetManagerDeprecated("方法已过期，请使用最新方法名：BAButton *btn1 = [[BAButton alloc] init]");
- (instancetype _Nonnull)initWitButtonStatus:(BABAButtonStatus)status BANetManagerDeprecated("方法已过期，请使用最新方法名：BAButton *btn1 = [[BAButton alloc] init]");

@end

