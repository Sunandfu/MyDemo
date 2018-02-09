//
//  NSDictionary+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)
/**
 *  判断字典中是否包含关键字key的对象
 */
- (BOOL)containsObjectForKey:(id)key;
@end
