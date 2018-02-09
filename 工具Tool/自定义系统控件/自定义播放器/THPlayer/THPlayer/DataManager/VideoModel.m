

 //@header VideoModel.m
 
 //  THPlayer
 //
 //  Created by inveno on 16/3/22.
 //  Copyright © 2016年 inveno. All rights reserved.
 //

#import "VideoModel.h"

@implementation VideoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionDe = value;
    }
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com