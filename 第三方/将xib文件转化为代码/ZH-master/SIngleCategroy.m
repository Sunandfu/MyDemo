#import "SIngleCategroy.h"

@implementation SIngleCategroy
+ (NSMutableDictionary *)defaultSIngleCategroy{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(ZHSIngleCategroy==nil){
            ZHSIngleCategroy=[NSMutableDictionary dictionary];
        }
    });
    return ZHSIngleCategroy;
}
+ (void)setValueWithIdentity:(NSString *)Identity withValue:(NSString *)value{
    [[SIngleCategroy defaultSIngleCategroy] setValue:value forKey:Identity];
}
+ (NSString *)getValueWithIdentity:(NSString *)Identity{
    NSString *value=[[SIngleCategroy defaultSIngleCategroy][Identity] copy];
    [[SIngleCategroy defaultSIngleCategroy]removeObjectForKey:Identity];
    return value;
}
@end