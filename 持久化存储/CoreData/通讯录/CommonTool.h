//
//  CommonTool.h
//  05-通讯录
//
//  Created by Alvechen on 15/11/22.
//  Copyright © 2015年 Alvechen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

/**
 *  汉语转拼音  例如:张三--> zhang san
 */
+ (NSString *)getPinYinFromString:(NSString *)string;


@end
