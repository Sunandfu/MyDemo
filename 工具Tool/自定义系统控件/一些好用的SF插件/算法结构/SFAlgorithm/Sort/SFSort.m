//
//  SFSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFSort.h"

@interface SFSort ()

@property (nonatomic, copy) SFComparatorBlock comparatorBlock;
@property (nonatomic, weak) id<SFComparator> comparator;

@end

@implementation SFSort

- (NSArray *)sortArray:(NSArray<id> *)array{
    self.mutableArray = [NSMutableArray arrayWithArray:array];
    [self sort];
    return self.mutableArray;
}
- (NSArray *)sortArray:(NSArray<id> *)array  ComparatorBlock:(_Nullable SFComparatorBlock)comparatorBlock{
    self.comparatorBlock = comparatorBlock;
    return [self sortArray:array];
}
- (NSArray *)sortArray:(NSArray<id> *)array Comparator:(_Nullable id<SFComparator>)comparator{
    self.comparator = comparator;
    return [self sortArray:array];
}
- (void)sort{
    NSAssert(NO, @"请调用子类");
}
- (int)compare:(id)e1 e2:(id)e2 {
    return self.comparatorBlock ? self.comparatorBlock(e1, e2) :
    (_comparator ? [_comparator compare:e1 another:e2] : (int)[e1 compare:e2]);
}

- (int)compareWithOne:(NSInteger)one Two:(NSInteger)two{
    return [self compare:self.mutableArray[one] e2:self.mutableArray[two]];
}
- (void)swapWithOne:(NSInteger)one Two:(NSInteger)two{
    id tmpValue = self.mutableArray[one];
    self.mutableArray[one] = self.mutableArray[two];
    self.mutableArray[two] = tmpValue;
}
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

@end
