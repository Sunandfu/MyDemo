//
//  SFMergeSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFMergeSort.h"

@interface SFMergeSort ()

@property (nonatomic, strong) NSMutableArray *leftArray;

@end

@implementation SFMergeSort

- (void)sort{
    //归并排序
    self.leftArray = [NSMutableArray arrayWithCapacity:self.mutableArray.count>>1];
    [self divideWithBegin:0 End:self.mutableArray.count];
}
- (void)divideWithBegin:(NSInteger)begin End:(NSInteger)end{
    if (end-begin < 2) return;
    NSInteger mid = (end+begin)>>1;
    [self divideWithBegin:begin End:mid];
    [self divideWithBegin:mid End:end];
    [self mergeWithBegin:begin Mid:mid End:end];
}
//将 [begin, mid) 和 [mid, end) 范围的序列合并成一个有序序列
- (void)mergeWithBegin:(NSInteger)begin Mid:(NSInteger)mid End:(NSInteger)end{
    NSInteger leftBegin = 0;
    NSInteger leftEnd = mid-begin;
    NSInteger rightBegin = mid;
    NSInteger rightEnd = end;
    NSInteger index = begin;
    for (NSInteger i=leftBegin; i<leftEnd; i++) {
        self.leftArray[i] = self.mutableArray[i+begin];
    }
    while (leftBegin<leftEnd) {
        if (rightBegin < rightEnd && [self compare:self.mutableArray[rightBegin] e2:self.leftArray[leftBegin]] < 0) {
            self.mutableArray[index++] = self.mutableArray[rightBegin++];
        } else {
            self.mutableArray[index++] = self.leftArray[leftBegin++];
        }
    }
}

@end
