//
//  NSDate+SFAdd.h
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDate (SFAdd)
@property (nonatomic, strong, readonly) NSString *sf_yyyy_MM_dd_HH_mm_ss;
@property (nonatomic, strong, readonly) NSString *sf_yyyy_MM_dd_HH_mm;
@property (nonatomic, strong, readonly) NSString *sf_yyyy_MM_dd;
@property (nonatomic, strong, readonly) NSString *sf_HH_mm_ss;
@property (nonatomic, strong, readonly) NSString *sf_yyyy;
@property (nonatomic, strong, readonly) NSString *sf_MM;
@property (nonatomic, strong, readonly) NSString *sf_dd;
@property (nonatomic, strong, readonly) NSString *sf_HH;
@property (nonatomic, strong, readonly) NSString *sf_mm;
@property (nonatomic, strong, readonly) NSString *sf_ss;
@end
NS_ASSUME_NONNULL_END
