//
//  NSObject+CJLKVC.h
//  CJLCustom
//
//  Created by - on 2020/10/26.
//  Copyright © 2020 CJL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CJLKVC)

//设值
- (void)cjl_setValue:(nullable id)value forKey:(NSString *)key;
//取值
- (nullable id)cjl_valueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
