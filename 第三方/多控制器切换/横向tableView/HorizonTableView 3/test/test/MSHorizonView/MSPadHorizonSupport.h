//
//  MSPadHorizonSupport.h
//  mushuIpad
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPIndexPath : NSObject
@property (nonatomic, assign) NSUInteger section;
@property (nonatomic, assign) NSUInteger col;
+ (id)indexPathWithSection:(NSUInteger)section andCol:(NSUInteger)col;
- (BOOL)isEqualIndexPath:(MPIndexPath*)indexPath;
@end

@interface MSPadHorizonPos : NSObject
@property (nonatomic, assign) CGFloat beginPos;
@property (nonatomic, assign) CGFloat endPos;
+ (id)posWithBegin:(CGFloat)begin andEnd:(CGFloat)end;
@end

typedef enum {
    MP_SEARCH_LOW, MP_SEARCH_EQUAL, MP_SEARCH_HIGH
}MP_SEARCH_CASE;

@interface NSMutableArray (MSPadBinarySearch)
- (NSUInteger)indexOfObjectBinarySearch:(MP_SEARCH_CASE (^) (id obj, NSUInteger index, BOOL *stop))comparator;
- (NSUInteger)mp_indexOfObjectBinarySearch:(MP_SEARCH_CASE (^) (id obj))comparator;// 一定会返回一个最接近的值
@end