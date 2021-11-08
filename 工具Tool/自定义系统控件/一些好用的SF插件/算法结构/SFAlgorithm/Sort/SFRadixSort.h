//
//  SFRadixSort.h
//  algorithm
//
//  Created by lurich on 2021/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFRadixSort : NSObject

@property (nonatomic, strong) NSMutableArray<NSNumber *> *mutableArray;

//计数排序只能针对正整数进行排序
- (NSArray *)sortArray:(NSArray<NSNumber *> *)array;

@end

NS_ASSUME_NONNULL_END
