/*
 中文log打印
 */
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TestObj : NSObject
@end

@implementation TestObj
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tab appendString:@"\t"];
    }
    [mStr appendFormat:@"<%@ = {\n",NSStringFromClass(self.class)];

    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *charProperty = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:charProperty];
        if (propertyName) { 
            id propertyValue = [self valueForKey:propertyName];
            NSString *lastSymbol = (outCount == i + 1) ? @"":@";";
            if ([propertyValue respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
                [mStr appendFormat:@"\t%@%@ = %@%@\n",tab,propertyName,[propertyValue descriptionWithLocale:locale indent:level + 1],lastSymbol];
            } else {
                [mStr appendFormat:@"\t%@%@ = %@%@\n",tab,propertyName,propertyValue,lastSymbol];
            }
        }
    }
    free(properties);
    [mStr appendFormat:@"%@}>",tab];
    return mStr;
}

@end


@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"{\n"];
    NSArray *allKey = self.allKeys;
    for (int i = 0; i < allKey.count; i++) {
        id value = self[allKey[i]];
        NSString *lastSymbol = (allKey.count == i + 1) ? @"":@";";
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",tab,allKey[i],[value descriptionWithLocale:locale indent:level + 1],lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",tab,allKey[i],value,lastSymbol];
        }
    }
    [mStr appendFormat:@"%@}",tab];
    return mStr;
}
@end

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"(\n"];
    for (int i = 0; i < self.count; i++) {
        NSString *lastSymbol = (self.count == i + 1) ? @"":@",";
        id value = self[i];
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@%@\n",tab,[value descriptionWithLocale:locale indent:level + 1],lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@%@\n",tab,value,lastSymbol];
        }
    }
    [mStr appendFormat:@"%@)",tab];
    return mStr;

}
@end
