//
//  NSObject+addFunction.h
//  TestAdA
//
//  Created by lurich on 2019/5/5.
//  Copyright © 2019 YX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (addFunction)

- (void)ViewClickWithDict:(NSDictionary *)currentDict Width:(NSString *)widthStr Height:(NSString *)heightStr X:(NSString *)x Y:(NSString *)y Controller:(id)controller;

@end

NS_ASSUME_NONNULL_END
