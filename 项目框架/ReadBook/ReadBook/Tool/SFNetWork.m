//
//  SFNetWork.m
//  ReadBook
//
//  Created by lurich on 2020/5/15.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFNetWork.h"
#import "SFTool.h"
#import "ONOXMLDocument.h"

@implementation SFNetWork

//GET请求json数据
+ (void)getJsonDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail{
    if (parameters) {
        url = [self urlStrWithDict:parameters UrlStr:url];
    }
    NSString *md5 = [SFTool MD5WithUrl:url];
    NSString *cachePath = [self cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (dict && success) {
            success(dict);
        }
    }else{
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && success) {
                [data writeToFile:cachePath atomically:YES];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                success(dict);
            } else if (error && fail) {
                fail(error);
            }
        }];
        [task resume];
    }
}
//GET请求xml数据
+ (void)getXmlDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id data))success fail:(void(^)(NSError * error))fail{
    if (parameters) {
        url = [self urlStrWithDict:parameters UrlStr:url];
    }
    NSString *md5 = [SFTool MD5WithUrl:url];
    NSString *cachePath = [self cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        if (data && success) {
            success(data);
        }
    }else{
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && success) {
                [data writeToFile:cachePath atomically:YES];
                success(data);
            } else if (error && fail) {
                fail(error);
            }
        }];
        [task resume];
    }
}
//POST请求xml数据
+ (void)postXmlDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id data))success fail:(void(^)(NSError * error))fail{
    if (parameters) {
        url = [self urlStrWithDict:parameters UrlStr:url];
    }
    NSString *md5 = [SFTool MD5WithUrl:url];
    NSString *cachePath = [self cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        if (data && success) {
            success(data);
        }
    }else{
        NSURLSession *session = [NSURLSession sharedSession];
        /**
             NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
             config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
             NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:[self defaultManager] delegateQueue:[NSOperationQueue currentQueue]];
             
         */
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"POST";
        request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && success) {
                [data writeToFile:cachePath atomically:YES];
                success(data);
            } else if (error && fail) {
                fail(error);
            }
        }];
        [task resume];
    }
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
+ (void)cacheJsonBooksWithBook:(BookModel *)book success:(void(^)(id data))success fail:(void(^)(NSError * error))fail{
    NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
    NSString *cachePath = [self cachePathWithMD5:md5];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && success) {
            [data writeToFile:cachePath atomically:YES];
            success(data);
        } else if (error && fail) {
            fail(error);
        }
    }];
    [task resume];
}
+ (void)cacheJsonBooksWithModelArray:(NSArray<BookDetailModel *> *)modelArray XPatn:(NSString *)xpath{
    if ([SFTool isHaveProgress]) {
        [SVProgressHUD showErrorWithStatus:@"已有任务下载中"];
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:[SFTool defaultManager].progressView];
    dispatch_queue_t queue = dispatch_queue_create("com.xiaofu.Lurich", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<modelArray.count; i++) {
            BookDetailModel *detailModel = modelArray[i];
            // 网络任务
            NSString *md5 = [SFTool MD5WithUrl:detailModel.postUrl];
            NSString *cachePath = [self cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (!isExist) {
                // 追加任务 1
                [NSThread sleepForTimeInterval:1];
                NSURLSession *session = [NSURLSession sharedSession];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[detailModel.postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                request.HTTPMethod = @"GET";
                request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
                request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
                request.timeoutInterval = 5;
                NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        [data writeToFile:cachePath atomically:YES];
                        NSLog(@"%@缓存完成",detailModel.title);
                        [self showWithStr:detailModel.title Success:YES Index:i Count:modelArray.count];
                    } else if (error) {
                        NSLog(@"%@缓存失败，error=%@",detailModel.title,error);
                        [self showWithStr:detailModel.title Success:NO Index:i Count:modelArray.count];
                    }
                }];
                [task resume];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"书籍后台缓存完成"];
            [[SFTool defaultManager].progressView removeFromSuperview];
        });
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"书籍后台缓存中"];
    });
}
+ (void)cacheBooksWithBook:(BookModel *)book success:(void(^)(id data))success fail:(void(^)(NSError * error))fail{
    NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
    NSString *cachePath = [self cachePathWithMD5:md5];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && success) {
            [data writeToFile:cachePath atomically:YES];
            success(data);
        } else if (error && fail) {
            fail(error);
        }
    }];
    [task resume];
}
+ (void)cacheBooksWithModelArray:(NSArray<BookDetailModel *> *)modelArray XPatn:(NSString *)xpath{
    if ([SFTool isHaveProgress]) {
        [SVProgressHUD showErrorWithStatus:@"已有任务下载中"];
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:[SFTool defaultManager].progressView];
    dispatch_queue_t queue = dispatch_queue_create("com.xiaofu.Lurich", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<modelArray.count; i++) {
            BookDetailModel *detailModel = modelArray[i];
            // 网络任务
            NSString *md5 = [SFTool MD5WithUrl:detailModel.postUrl];
            NSString *cachePath = [self cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (!isExist) {
                // 追加任务 1
                [NSThread sleepForTimeInterval:1];
                NSURLSession *session = [NSURLSession sharedSession];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[detailModel.postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                request.HTTPMethod = @"GET";
                request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
                request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
                request.timeoutInterval = 5;
                NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        [data writeToFile:cachePath atomically:YES];
                        NSLog(@"%@缓存完成",detailModel.title);
                        [self showWithStr:detailModel.title Success:YES Index:i Count:modelArray.count];
                    } else {
                        NSLog(@"%@缓存失败，error=%@",detailModel.title,error);
                        [self showWithStr:detailModel.title Success:NO Index:i Count:modelArray.count];
                    }
                }];
                [task resume];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"书籍后台缓存完成"];
            [[SFTool defaultManager].progressView removeFromSuperview];
        });
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"书籍后台缓存中"];
    });
}
+ (void)showWithStr:(NSString *)showStr Success:(BOOL)isSuccess Index:(int)index Count:(NSInteger)count{
    if (isSuccess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SFTool defaultManager].progressView setProgress:index*1.0/count animated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@缓存失败",showStr] duration:3];
        });
    }
}

+ (void)cacheCartoonWithModelArray:(NSArray<BookDetailModel *> *)modelArray XPatn:(NSString *)xpath{
    if ([SFTool isHaveProgress]) {
        [SVProgressHUD showErrorWithStatus:@"已有任务下载中"];
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:[SFTool defaultManager].progressView];
    dispatch_queue_t queue = dispatch_queue_create("com.xiaofu.Lurich", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<modelArray.count; i++) {
            BookDetailModel *detailModel = modelArray[i];
            // 网络任务
            NSString *md5 = [SFTool MD5WithUrl:detailModel.postUrl];
            NSString *cachePath = [self cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (!isExist) {
                // 追加任务 1
                [NSThread sleepForTimeInterval:1];
                NSURLSession *session = [NSURLSession sharedSession];
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[detailModel.postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                request.HTTPMethod = @"GET";
                request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
                request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
                request.timeoutInterval = 5;
                NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        [data writeToFile:cachePath atomically:YES];
                        NSLog(@"%@缓存完成",detailModel.title);
                        [self showWithStr:detailModel.title Success:YES Index:i Count:modelArray.count];
                        if ([xpath isEqualToString:@"homeCartoon"]) {
                            [self cacheHomeCartoonImageWithData:data];
                        } else {
                            [self cacheImageWithData:data];
                        }
                    } else {
                        [self showWithStr:detailModel.title Success:NO Index:i Count:modelArray.count];
                        NSLog(@"%@缓存失败，error=%@",detailModel.title,error);
                    }
                }];
                [task resume];
            } else {
                NSData *data = [NSData dataWithContentsOfFile:cachePath];
                NSLog(@"%@缓存完成",detailModel.title);
                [self showWithStr:detailModel.title Success:YES Index:i Count:modelArray.count];
                if ([xpath isEqualToString:@"homeCartoon"]) {
                    [self cacheHomeCartoonImageWithData:data];
                } else {
                    [self cacheImageWithData:data];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"漫画后台缓存完成"];
            [[SFTool defaultManager].progressView removeFromSuperview];
        });
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"漫画后台缓存中"];
    });
}
+ (void)cacheHomeCartoonImageWithData:(NSData *)data{
    NSError *xmlError;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&xmlError];
    if (!xmlError) {
        ONOXMLElement *postsParentElement = [doc firstChildWithXPath:@"//*[@class=\"comicpage\"]"];
        [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            ONOXMLElement *imgItem = [element firstChildWithXPath:@"img"];
            NSString *imgUrl = [imgItem valueForAttribute:@"src"];
            //设置真实高度
            NSString *md5 = [SFTool MD5WithUrl:imgUrl];
            NSString *cachePath = [SFTool cacheImagePathWithMD5:md5];
            NSString *imageCache = [NSString stringWithFormat:@"%@.jpg",cachePath];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imageCache];
            if (!isExist) {
                [NSThread sleepForTimeInterval:1];
                [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:imgUrl]] options:YYWebImageOptionIgnoreDiskCache progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"图片下载出错 error = %@ -> url = %@",error,url);
                    } else {
                        NSLog(@"图片下载完成，链接为%@",url);
                        [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageCache atomically:YES];
                    }
                }];
            }
        }];
        
    }
}
+ (void)cacheImageWithData:(NSData *)data{
    NSError *xmlError;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&xmlError];
    if (!xmlError) {
        NSString *docStr = [NSString stringWithFormat:@"%@",doc];
        NSString *CT_NUM = @"parseJSON(\\S*)";
        //判断返回字符串是否为所需数据
        if (docStr.length>0) {
            NSArray *strArr = [self matchString:docStr toRegexString:CT_NUM];
            NSString *reStr = [NSString stringWithFormat:@"%@",[strArr firstObject]];
            reStr = [reStr substringWithRange:NSMakeRange(2, reStr.length-5)];
            NSData *jsonData = [reStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSArray *tmpArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if(error) {
                NSLog(@"error = %@",error);
            } else {
                for (NSString *imgStr in tmpArr) {
                    NSString *urlStr = [@"https://www.nitianxieshen.com" stringByAppendingString:imgStr];
                    NSString *md5 = [SFTool MD5WithUrl:urlStr];
                    NSString *cachePath = [SFTool cacheImagePathWithMD5:md5];
                    NSString *imageCache = [NSString stringWithFormat:@"%@.jpg",cachePath];
                    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imageCache];
                    if (!isExist) {
                        [NSThread sleepForTimeInterval:1];
                        [SFTool downloadImageWithUrl:urlStr Finish:^(UIImage *image, NSString *imageUrl) {
                            NSLog(@"图片下载完成，图片大小为%@,链接为%@",NSStringFromCGSize(image.size),imageUrl);
                        } Failure:^(NSError *error) {
                            NSLog(@"图片下载出错 error= %@",error);
                        }];
//                        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:urlStr]] options:YYWebImageOptionIgnoreDiskCache progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//                            if (error) {
//                                NSLog(@"图片下载出错 error = %@ -> url = %@",error,url);
//                            } else {
//                                NSLog(@"图片下载完成，图片大小为%@,链接为%@",NSStringFromCGSize(image.size),url);
//                                [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageCache atomically:YES];
//                            }
//                        }];
                    }
                }
            }
        }
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
+ (NSData *)hexToBytes:(NSString *)dataStr {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= dataStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [dataStr substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    return data;
}
+ (NSString *)cachePathWithMD5:(NSString *)md5{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Books"];
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

@end
