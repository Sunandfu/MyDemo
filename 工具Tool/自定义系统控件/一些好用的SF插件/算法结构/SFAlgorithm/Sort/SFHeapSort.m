//
//  SFHeapSort.m
//  algorithm
//
//  Created by lurich on 2021/9/5.
//

#import "SFHeapSort.h"

@interface SFHeapSort ()

@property (nonatomic, assign) NSInteger heapSize;

@end

@implementation SFHeapSort

- (void)sort{
    //堆排序
    // 原地建堆
    self.heapSize = self.mutableArray.count;
    for (NSInteger i = (self.heapSize >> 1) - 1; i >= 0; i--) {
        [self siftDown:i];
    }
    
    while (self.heapSize > 1) {
        // 交换堆顶元素和尾部元素
        [self swapWithOne:0 Two:--self.heapSize];
        // 对0位置进行siftDown（恢复堆的性质）
        [self siftDown:0];
    }
}
- (void)siftDown:(NSInteger)index {
    id element = self.mutableArray[index];
    
    NSInteger half = self.heapSize >> 1;
    while (index < half) { // index必须是非叶子节点
        // 默认是左边跟父节点比
        NSInteger childIndex = (index << 1) + 1;
        id child = self.mutableArray[childIndex];

        NSInteger rightIndex = childIndex + 1;
        // 右子节点比左子节点大
        if (rightIndex < self.heapSize && [self compare:self.mutableArray[rightIndex] e2:child] > 0) {
            child = self.mutableArray[childIndex = rightIndex];
        }

        // 大于等于子节点
        if ([self compare:element e2:child] >= 0) break;

        self.mutableArray[index] = child;
        index = childIndex;
    }
    self.mutableArray[index] = element;
}

@end
