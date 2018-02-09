#import <Foundation/Foundation.h>
static NSMutableDictionary *ZHSIngleCategroy;
@interface SIngleCategroy : NSObject
+ (NSMutableDictionary *)defaultSIngleCategroy;
+ (void)setValueWithIdentity:(NSString *)Identity withValue:(NSString *)value;
+ (NSString *)getValueWithIdentity:(NSString *)Identity;
@end