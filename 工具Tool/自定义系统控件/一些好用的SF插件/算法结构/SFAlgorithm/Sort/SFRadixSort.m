//
//  SFRadixSort.m
//  algorithm
//
//  Created by lurich on 2021/9/5.
//

#import "SFRadixSort.h"

@implementation SFRadixSort

- (NSArray *)sortArray:(NSArray<id> *)array{
    self.mutableArray = [NSMutableArray arrayWithArray:array];
    //基数排序，也叫桶排序
    [self sort];
    return self.mutableArray;
}
- (void)sort{
    NSNumber *max = self.mutableArray[0];
    for (NSInteger i=1; i<self.mutableArray.count; i++) {
        if (max.integerValue < self.mutableArray[i].integerValue) {
            max = self.mutableArray[i];
        }
    }
    // 个位数: array[i] / 1 % 10 = 3
    // 十位数：array[i] / 10 % 10 = 9
    // 百位数：array[i] / 100 % 10 = 5
    // 千位数：array[i] / 1000 % 10 = ...
    for (NSInteger divider = 1; divider <= max.integerValue; divider *= 10) {
        [self countingSort:divider];
    }
}
- (void)countingSort:(NSInteger)divider{
    NSMutableArray<NSNumber *> *tmpArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i=0; i<10; i++) {
        tmpArray[i] = @(0);
    }
    
    for (NSInteger i=0; i<self.mutableArray.count; i++) {
        NSInteger value = self.mutableArray[i].integerValue / divider % 10;
        NSInteger oldValue = tmpArray[value].integerValue;
        oldValue++;
        tmpArray[value] = @(oldValue);
    }
    
    NSMutableArray<NSMutableArray *> *oldValueArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i=0; i<10; i++) {
        oldValueArray[i] = [NSMutableArray array];
    }
    for (NSInteger i=self.mutableArray.count-1; i>=0; i--) {
        //从后往前遍历，获取对应元素的下标
        NSInteger index = self.mutableArray[i].integerValue / divider % 10;
        [oldValueArray[index] addObject:self.mutableArray[i]];
    }
    
    NSMutableArray<NSNumber *> *newArray = [NSMutableArray arrayWithCapacity:self.mutableArray.count];
    for (NSInteger i=0; i<self.mutableArray.count; i++) {
        newArray[i] = @(0);
    }
    
    NSInteger index = 0;
    for (NSInteger i=0; i<tmpArray.count; i++) {
        NSInteger tmpValue = tmpArray[i].integerValue;
        while (tmpValue>0) {
            newArray[index++] = oldValueArray[i][tmpValue-1];
            tmpValue--;
        }
    }
    NSLog(@"%@",[newArray componentsJoinedByString:@","]);
    self.mutableArray = [NSMutableArray arrayWithArray:newArray];
}

@end
