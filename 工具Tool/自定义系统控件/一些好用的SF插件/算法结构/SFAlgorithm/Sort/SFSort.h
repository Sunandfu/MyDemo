//
//  SFSort.h
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import <Foundation/Foundation.h>
#import "SFComparator.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSort : NSObject

@property (nonatomic, strong) NSMutableArray *mutableArray;

- (NSArray *)sortArray:(NSArray<id> *)array;
- (NSArray *)sortArray:(NSArray<id> *)array  ComparatorBlock:(_Nullable SFComparatorBlock)comparatorBlock;
- (NSArray *)sortArray:(NSArray<id> *)array Comparator:(_Nullable id<SFComparator>)comparator;

- (int)compare:(id)e1 e2:(id)e2;
- (int)compareWithOne:(NSInteger)one Two:(NSInteger)two;
- (void)swapWithOne:(NSInteger)one Two:(NSInteger)two;

@end

NS_ASSUME_NONNULL_END
