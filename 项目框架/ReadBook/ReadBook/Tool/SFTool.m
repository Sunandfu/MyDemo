//
//  NetTool.m
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import "SFTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <YYWebImage/YYWebImage.h>
#import <CoreText/CoreText.h>
#import "SFSafeAreaInsets.h"
#import "SFConstant.h"

@implementation SFTool

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    static SFTool *sftool = nil;
    dispatch_once(&onceToken, ^{
        sftool = [[SFTool alloc]init];
    });
    return sftool;
}
+ (NSString *)getTimeLocal{//毫秒级
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    return timeLocal;
}
+(NSString *)getDeviceIPAdress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSString *CT_NUM = @"(\\d+\\.\\d+\\.\\d+\\.\\d+)";
    //判断返回字符串是否为所需数据
    if (ip.length>0) {
        NSArray *strArr = [self matchString:ip toRegexString:CT_NUM];
        return strArr.count>0?[strArr firstObject]:@"0.0.0.0";
    } else {
        return @"0.0.0.0";
    }
}

//OpenUDID zzz uid
+ (NSString *)getDeviceUUID
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [userDefault objectForKey:@"ApplicationUniqueIdentifier"];
    if (uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        if (uuid == nil) {uuid = @"";}
        [userDefault setObject:uuid forKey:@"ApplicationUniqueIdentifier"];
        [userDefault synchronize];
    }
    return uuid;
}

+ (NSString *)URLEncodedString:(NSString*)str{
    BOOL isHaveChinese = [self isHasChineseChar:str];
    if (isHaveChinese) {
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return str;
    } else {
        return str;
    }
//    NSString *encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!@#$^*+ "].invertedSet];
//    return encodedString;
}
+ (BOOL)isHasChineseChar:(NSString *)string{
    BOOL bool_value = NO;
    for (int i=0; i<string.length; i++) {
        NSRange range =NSMakeRange(i, 1);
        NSString * strFromSubStr=[string substringWithRange:range];
        const char * cStringFromstr=[strFromSubStr UTF8String];
        if (strlen(cStringFromstr)==3) {
            //有汉字
            bool_value = YES;
        }
    }
    return bool_value;
}
//系统版本
+ (NSString *)getOS
{
    NSString *os  = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@",os];
}
//应用包名
+ (NSString *)getPackageName
{
    NSString *packageName = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] bundleIdentifier]];
    return packageName;
}
+ (NSString *)getLanguage{
    NSArray *allLanguages = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    if ([allLanguages firstObject] && [[allLanguages firstObject] isKindOfClass:[NSString class]]) {
        NSString *preferredLang = [allLanguages firstObject];
        return preferredLang?preferredLang:@"zh-Hans-CN";
    }
    return @"zh-Hans-CN";
}
+ (NSString *)getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name?app_Name:@"";
}
+ (NSString *)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本号
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version?app_Version:@"";
}
+ (NSString *)getAppBuild{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app构建版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build?app_build:@"";
}
// User_Agent
+ (NSString *)getUserAgent{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userAgent = [userDefault objectForKey:KeyUserAgent];
    return userAgent?userAgent:@"Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148";
}
+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop
{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    NSDate * startDate = [dateFormatter dateFromString:start];
    NSDate * stopDate = [dateFormatter dateFromString:stop];
    NSTimeInterval interval = [stopDate timeIntervalSinceDate:startDate];
    return (NSInteger)interval/3600;
}
+ (NSString *)getNowDateTimeStr
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getNowDateStr
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"yyyy-MM-dd";
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getNowTimeStr
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"HH:mm:ss";
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getNowTimeWithDataFormat:(NSString *)format
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = format;
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
#pragma mark - date

+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSInteger)getDifferenceByDate1:(NSString *)date1 Date2:(NSString *)date2{
    if (date1==nil || date2==nil) {
        return 0;
    }
    //获得当前时间
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [dateFormatter dateFromString:date1];
    NSDate *newDate = [dateFormatter dateFromString:date2];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:newDate  options:0];
    return [comps day];
}

+ (NSString *)nextDayWithDate:(NSDate *)date Number:(NSInteger)number{
    NSDate *newDate = [date dateByAddingTimeInterval:number * (24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return [dateString substringWithRange:NSMakeRange(8, 2)];
}

+ (NSString *)nextDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [dateFormatter dateFromString:nowDateStr];
    NSDate *newDate = [date dateByAddingTimeInterval:number * (24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"dd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return dateString;
}
+ (NSString *)nextYearMonthDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [dateFormatter dateFromString:nowDateStr];
    NSDate *newDate = [date dateByAddingTimeInterval:number * (24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return dateString;
}
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    if (aDate==nil||bDate==nil) {
        return 0;
    }
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

+ (UIImage *)getLauchImage
{
    return [self imageFromLaunchImage] ?[self imageFromLaunchImage]: [self imageFromLaunchScreen];
}
+ (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage *)imageFromLaunchImage{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL)  return imageL;
    //    XHLaunchAdLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

+(UIImage *)imageFromLaunchScreen{
    NSString *UILaunchStoryboardName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    if(UILaunchStoryboardName == nil){
        //        XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
        return nil;
    }
    UIViewController *LaunchScreenSb = [[UIStoryboard storyboardWithName:UILaunchStoryboardName bundle:nil] instantiateInitialViewController];
    if(LaunchScreenSb){
        UIView * view = LaunchScreenSb.view;
        view.frame = [UIScreen mainScreen].bounds;
        UIImage *image = [self imageFromView:view];
        return image;
    }
    //    XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
    return nil;
}

+(UIImage*)imageFromView:(UIView*)view{
    CGSize size = view.bounds.size;
    //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)launchImageWithType:(NSString *)type{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]){
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize)){
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage * image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)snapshotScreenInView:(UIView *)contentView
{
    UIImage * image = nil;
    CGRect rect = contentView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    //自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates:它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame
{
    CGFloat scaleFlote = [UIScreen mainScreen].scale;
    CGRect newFrame = CGRectMake(scaleFlote*frame.origin.x, scaleFlote*frame.origin.y, scaleFlote*frame.size.width, scaleFlote*frame.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self snapshotScreenInView:contentView].CGImage, newFrame);
    UIGraphicsBeginImageContextWithOptions(newFrame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *)getImageWithURLStr:(NSString *)urlStr{
    if (!urlStr) {
        return nil;
    }
    NSString *md5 = [self MD5WithUrl:urlStr];
    NSString *cachePath = [self cacheImagePathWithMD5:md5];
    NSString *imageCache = [NSString stringWithFormat:@"%@.jpg",cachePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imageCache];
    if (isExist) {
        UIImage *image = [UIImage imageWithContentsOfFile:imageCache];
        return image;
    }else{
        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionIgnoreDiskCache progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            return image;
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (!error) {
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageCache atomically:YES];
            }
        }];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
}

+ (NSString *)MD5WithUrl:(NSString *)urlStr{
    const char *original_str = [urlStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    return hash;
}
+ (void)setImage:(UIImageView*)imageView WithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder {
    imageView.image = placeholder;
    if (!urlStr) {
        return;
    }
    NSString *md5 = [self MD5WithUrl:urlStr];
    NSString *cachePath = [self cacheImagePathWithMD5:md5];
    NSString *imageCache = [NSString stringWithFormat:@"%@.jpg",cachePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imageCache];
    if (isExist) {
        UIImage *image = [UIImage imageWithContentsOfFile:imageCache];
        imageView.image = image;
    }else{
        [imageView yy_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:urlStr]] placeholder:placeholder];
    }
}
+ (void)downloadImageWithUrl:(NSString *)urlStr Finish:(downloadFinish)finish Failure:(downloadFailure)failure{
    if (!urlStr) {
        return;
    }
    NSString *md5 = [self MD5WithUrl:urlStr];
    NSString *cachePath = [self cacheImagePathWithMD5:md5];
    NSString *imageCache = [NSString stringWithFormat:@"%@.jpg",cachePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imageCache];
    if (isExist) {
        UIImage *image = [UIImage imageWithContentsOfFile:imageCache];
        finish(image,urlStr);
    }else{
        NSURL *url = [NSURL URLWithString:[self URLEncodedString:urlStr]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                [data writeToFile:imageCache atomically:YES];
                UIImage *image = [UIImage imageWithData:data];
                finish(image,urlStr);
            }
            if (error) {
                failure(error);
            }
        }] resume];
    }
}
+ (NSString *)cacheImagePathWithMD5:(NSString *)md5{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    [self imgFileDataLocationSettingWithPath:paths];
    NSString *pathStr=[NSString stringWithFormat:@"%@/%@",paths,md5];
    //    NSLog(@"沙盒路径：%@",pathStr);
    return pathStr;
}
//处理缓存路径
+(void)imgFileDataLocationSettingWithPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
+ (NSString *)compareCurrentTime:(NSString *)dateStr
{
    NSDateFormatter * dateformatter = [NSDateFormatter new];
    dateformatter.dateFormat = [@"yyyy-MM-dd HH:mm:ss" substringToIndex:dateStr.length];
    NSDate *compareDate = [dateformatter dateFromString:dateStr];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%d秒前",(int)timeInterval];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <3){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else{
        result = [NSString stringWithFormat:@"%@",dateStr];
    }
    return  result;
}
//清理沙盒中的图片缓存
+ (void)clearNetImageChace
{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:paths]){
        [fileManager removeItemAtPath:paths error:nil];
    }
    [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
}
// 判断View是否显示在屏幕上
+ (BOOL)isInScreenView:(UIView*)view
{
    if (view == nil) {
        return FALSE;
    }
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 转换view对应window的Rect
    CGRect rect = [view convertRect:view.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    // 若view 隐藏
    if (view.hidden) {
        return FALSE;
    }
    // 若没有superview
    if (view.superview == nil) {
        return FALSE;
    }
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return FALSE;
    }
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    return TRUE;
}
// 判断Cell是否显示在屏幕上
+ (BOOL)isInScreenCell:(UITableViewCell*)cell
{
    if (cell == nil) { 
        return NO;
    }
    UITableView * tableView = (UITableView*)cell.superview;
    CGFloat cellY = cell.frame.origin.y;
    CGFloat cellH = cell.frame.size.height;
    CGFloat tableHeight = tableView.frame.size.height;
    CGFloat newY = tableView.contentOffset.y;
    newY = newY + tableHeight;
    if (newY > cellY + cellH) {
        return YES;
    }else{
        return NO;
    }
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

+ (NSMutableAttributedString *)attributedSetWithString:(NSString *)string{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    //    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:NSMakeRange(0, string.length)];
    //字体名称有以下：
//    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceHanSansSC-Regular" size:17] range:NSMakeRange(0, string.length)];
    //2000-23
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:52.0f/255.0f green:52.0f/255.0f blue:52.0f/255.0f alpha:1.0f] range:NSMakeRange(0, string.length)];
    //设置段落格式
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 2;//增加行高
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1.0;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 0;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    
    //字符间距 2pt
//    [attrString addAttribute:NSKernAttributeName value:@1 range:NSMakeRange(0, string.length)];
    return attrString;
}
/**
 获取url的所有参数
 
 @param urlStr 需要提取参数的url
 @return NSDictionary
 */
+ (NSMutableDictionary *)parseURLParametersWithURLStr:(NSString *)urlStr {
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) return nil;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [parameters valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [parameters setValue:items forKey:key];
                } else {
                    [parameters setValue:@[existValue, value] forKey:key];
                }
            } else {
                [parameters setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return nil;
        }
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        if (key == nil || value == nil) {
            return nil;
        }
        [parameters setValue:value forKey:key];
    }
    
    return parameters;
}
+ (NSString *)urlStrWithDict:(NSDictionary *)arrayDic UrlStr:(NSString *)urlStr{
    NSMutableString *URL = [NSMutableString stringWithString:urlStr];
    //获取字典的所有keys
    NSArray * keys = [arrayDic allKeys];
    //拼接字符串
    for (int j = 0; j < keys.count; j ++) {
        NSString *string;
        if (j == 0) {
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[j], arrayDic[keys[j]]];
        } else {
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[j], arrayDic[keys[j]]];
        }
        //拼接字符串
        [URL appendString:string];
    }
    return [NSString stringWithString:URL];
}
// 获取异常崩溃信息
+ (void)uncaughtExceptionHandler:(NSException *)exception{
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *errorMessage = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSLog(@"errorMessage = %@", errorMessage);
    /*
     @try {
     [self requestADSource];
     } @catch (NSException *exception) {
     [NetTool uncaughtExceptionHandler:exception];
     } @finally {
     }
     */
}

+(void)showCircleAnimationLayerWithView:(UIView *)view Color:(UIColor *)circleColor andScale:(CGFloat)scale
{
    if (!view.superview && circleColor) {
        return;
    }
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds), view.bounds.size.width, view.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:view.layer.cornerRadius];
    
    CGPoint shapePosition = [view.superview convertPoint:view.center fromView:view.superview];
    
    //内圈
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = circleColor.CGColor;//
    circleShape.lineWidth = 0.6;
    
    [view.superview.layer addSublayer:circleShape];
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    scaleAnimation.duration = 1;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape addAnimation:scaleAnimation forKey:nil];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    alphaAnimation.duration = 0.9;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:alphaAnimation forKey:nil];
    
    
    //内圈
    CAShapeLayer *circleShape2 = [CAShapeLayer layer];
    circleShape2.path = path.CGPath;
    circleShape2.position = shapePosition;
    circleShape2.fillColor = circleColor.CGColor;//
    circleShape2.opacity = 0;
    circleShape2.strokeColor = [UIColor clearColor].CGColor;
    circleShape2.lineWidth = 0;
    
    [view.superview.layer insertSublayer:circleShape2 atIndex:0];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    scaleAnimation2.duration = 1;
    scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape2 addAnimation:scaleAnimation2 forKey:nil];
    
    CABasicAnimation *alphaAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation2.fromValue = @0.8;
    alphaAnimation2.toValue = @0;
    alphaAnimation2.duration = 0.8;
    alphaAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape2 addAnimation:alphaAnimation2 forKey:nil];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [circleShape removeFromSuperlayer];
        [circleShape2 removeFromSuperlayer];
    });

}

+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexColor:color andOpacity:1.0f];
}
+ (UIColor *)colorWithHexColor:(NSString *)color andOpacity:(CGFloat)opacity {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //判断前缀
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    //从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R G B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:opacity];
}
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr{
    if (string.length>0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:nil];
        NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        //match: 所有匹配到的字符,根据() 包含级
        NSMutableArray *array = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:1]];
            [array addObject:component];
        }
        return array;
    } else {
        return @[@""];
    }
}
+ (NSString *)getNumberFromDataStr:(NSString *)str{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

+ (void)addImageRotationWithView:(UIView *)view{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.rotation";
    anima.values = @[@(((-5) * M_PI / 180.0)),@(((5) * M_PI / 180.0)),@(((-5) * M_PI / 180.0))];
    anima.repeatCount = MAXFLOAT;
    [view.layer addAnimation:anima forKey:@"doudong"];
}
+ (void)addImageScaleWithView:(UIView *)view{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.values = @[@(1.0),@(1.2),@(1.0),@(0.8),@(1.0)];
    anima.repeatCount = MAXFLOAT;
    anima.duration = 1;
    [view.layer addAnimation:anima forKey:@"daxiao"];
}

+ (void)addImageScaleShowAnimationWithView:(UIView *)view Time:(NSInteger)time{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.values = @[@(0.0),@(1.0)];
    anima.repeatCount = 1;
    anima.duration = time;
    [view.layer addAnimation:anima forKey:@"daxiao"];
}
+ (UIViewController *)getCurrentViewController
{
    UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    if([vc isKindOfClass:[UITabBarController class]])
    {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if([vc isKindOfClass:[UINavigationController class]])
    {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    
    return vc;
}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self topViewControllerWithVC:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewControllerWithVC:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)topViewControllerWithVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerWithVC:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerWithVC:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
+ (BOOL)isIPhoneXAbove{
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}
+ (UINavigationController *)currentNavigationController
{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

//递归
+ (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }
        else {
            return vc.navigationController;
        }
    }
    else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}
+ (NSString *)hexadecimalFromUIColor:(UIColor *)color{
    if(CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components =CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
        green:components[0]
        blue:components[0]
        alpha:components[1]];
    }
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) !=kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    NSString *r,*g,*b;
    (int)((CGColorGetComponents(color.CGColor))[0]*255.0) < 15?(r =[NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0)]):(r= [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0)]);
    (int)((CGColorGetComponents(color.CGColor))[1]*255.0) < 15?(g = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[1]*255.0)]):(g= [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[1]*255.0)]);
    (int)((CGColorGetComponents(color.CGColor))[2]*255.0) < 15?(b = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[2]*255.0)]):(b= [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[2]*255.0)]);
//    return [NSString stringWithFormat:@"#%2x%2x%2x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0),(int)((CGColorGetComponents(color.CGColor))[1]*255.0),(int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}
+ (void)sf_asynchronouslySetFontName:(NSString *)fontName{
    UIFont* aFont = [UIFont fontWithName:fontName size:12.];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
        return;
    }
    
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the activity indicator
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
//                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    NSLog(@"Download error: %@", error);
                });
            }
        }
        return (bool)YES;
    });
    
}
+ (NSString *)sf_stringRemoveSpecialCharactersOfString:(NSString *)target{
    NSString *attStr = [target stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    attStr = [attStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    attStr = [attStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    attStr = [attStr stringByReplacingOccurrencesOfString:@"    " withString:@""];
    attStr = [attStr stringByReplacingOccurrencesOfString:@"　　" withString:@""];
    return attStr;
}
+ (NSString *)sf_contentRemoveSpecialCharactersOfString:(NSString *)target{
    NSString *attStr = [target stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    attStr = [attStr stringByReplacingOccurrencesOfString:@"    " withString:@""];
    attStr = [attStr stringByReplacingOccurrencesOfString:@"　　" withString:@""];
    return attStr;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, [UIScreen mainScreen].bounds.size.width, 1)];
        _progressView.tag = 6140;
    }
    return _progressView;
}
+ (BOOL)isHaveProgress{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIProgressView *progress = [window viewWithTag:6140];
    if (progress) {
        return YES;
    } else {
        return NO;
    }
}
//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return rect.size.width;
}
+ (id)dataWithJsonPath:(NSString *)jsonPath Data:(id)jsonData{
    NSArray *array = [jsonPath componentsSeparatedByString:@"."];
    int i=0;
    id data;
    while (i<array.count) {
        NSString *key = array[i];
        if ([key isEqualToString:@"$"]) {
            data = jsonData;
        }
        else if ([key containsString:@"@"]) {
            key = [key substringFromIndex:1];
            data = data[key.intValue];
        }
        else {
            data = data[key];
        }
        i++;
    }
    return data;
}

@end
