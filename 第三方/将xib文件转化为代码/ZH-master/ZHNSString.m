#import "ZHNSString.h"

@implementation ZHNSString
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isValidatePassword:(NSString *)pw {
    NSString *emailRegex = @"[A-Z0-9a-z_]{6,15}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:pw];
}
+(BOOL)isValidateNickname:(NSString *)nickName {
    NSString *emailRegex = @"[A-Z 0-9a-z\u4e00-\u9fa5]{1,15}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:nickName];
}
+(BOOL)isValidatePhoneNum:(NSString *)phone{
    NSString *phoneRegex = @"^((147)|((17|13|15|18)[0-9]))\\d{8}$";//@"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)isValidateTelephoneNum:(NSString *)phone{
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)isValidateTelephone:(NSString *)phone{
    NSString * PHS = @"(”^(\\d{3,4}-)\\d{7,8}$”)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneTest evaluateWithObject:phone];
}
+ (BOOL)isValidateBankCardNumber: (NSString *)bankCardNumber{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
+(BOOL)isValidateNumber:(NSString *)number{
    NSString * num = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    return [numberTest evaluateWithObject:number];
}
+(BOOL)isValidateChinese:(NSString *)chineseName{
    NSString *chineseStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseStr];
    return [chineseTest evaluateWithObject:chineseName];
}

+(NSString*)getAppVersion
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+(NSString*)getAppName
{
    NSDictionary* infoDictionary=[[NSBundle mainBundle]infoDictionary];
    NSString* appName=[infoDictionary objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+(NSString *)getAllSupportLanguage{
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    return [NSString stringWithFormat:@"%@" , languages];
}

+(NSString *)getCurrentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return [NSString stringWithFormat:@"%@" , currentLanguage];
}

+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan=[NSScanner scannerWithString:string];
    float val;
    BOOL isFloat = [scan scanFloat:&val]&&[scan isAtEnd];
    if ([self isPureInt:string]) {
        return NO;
    }
    return isFloat;
}

+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan=[NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val]&&[scan isAtEnd];
}

+ (UIColor *)getColorFromHex:(NSString*)hexValue{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

+ (NSString *)currentDate{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

//去除前后空格
+ (NSString *)removeSpaceBeforeAndAfterWithString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString withText:(NSString *)text getOne:(BOOL)one withIndexStart:(NSInteger)startIndex stopString:(NSString *)stopString{
    
    if (startIndex>=text.length-1) {
        return nil;
    }
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSInteger indexStart=[text rangeOfString:leftString options:NSCaseInsensitiveSearch range:NSMakeRange(startIndex, text.length-startIndex)].location;
    NSInteger indexEnd;
    NSInteger stopIndex=0;
    if (indexStart!=NSNotFound&&indexStart<text.length-1) {
        indexEnd=[text rangeOfString:rightString options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        
        if (stopString.length==0) {
            stopIndex=text.length+1;
        }else{
            stopIndex=[text rangeOfString:rightString options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        }
    }else{
        indexEnd=NSNotFound;
    }
    
    while (indexStart!=NSNotFound&&indexEnd!=NSNotFound&&indexStart<indexEnd&&indexEnd<stopIndex) {
        [arrM addObject:[text substringWithRange:NSMakeRange(indexStart+leftString.length, indexEnd-indexStart-leftString.length)]];
        
        if (one) {
            break;
        }
        
        indexStart=indexEnd+1;
        
        indexStart=[text rangeOfString:leftString options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart, text.length-indexStart)].location;
        if (indexStart!=NSNotFound&&indexStart<text.length-1) {
            indexEnd=[text rangeOfString:rightString options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        }else break;
    }
    return arrM;
}

/**从路径中获取指定字符串*/
+ (NSString *)getStringFromPathArr:(NSArray *)pathArr stopPathString:(NSString *)stopPathstring withText:(NSString *)text BetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString{
    NSInteger index=0;
    BOOL success=YES;
    if(pathArr.count>0){
        for (NSString *path in pathArr) {
            index=[text rangeOfString:path options:NSCaseInsensitiveSearch range:NSMakeRange(index, text.length-index)].location;
            if (index!=NSNotFound) {
                continue;
            }else{
                success=NO;
                break;
            }
        }
        if (success==NO) {
            return @"";
        }
        
        NSArray *myStrings=[self getMidStringBetweenLeftString:leftString RightString:rightString withText:text getOne:YES withIndexStart:index stopString:stopPathstring];
        
        if (myStrings.count>0) {
            return myStrings[0];
        }
        
    }
    return @"";
}

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountTargetString:(NSString *)targetStr inText:(NSString *)text{
    
    NSInteger count=0;
    NSInteger indexStart=[text rangeOfString:targetStr].location;
    while (indexStart!=NSNotFound) {
        count++;
        
        indexStart+=targetStr.length;
        
        if (indexStart<text.length-1) {
            indexStart=[text rangeOfString:targetStr options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart, text.length-indexStart)].location;
        }else break;
    }
    return count;
}
@end