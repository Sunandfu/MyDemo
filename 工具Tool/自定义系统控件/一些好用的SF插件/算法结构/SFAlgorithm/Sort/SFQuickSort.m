//
//  SFQuickSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFQuickSort.h"

@implementation SFQuickSort

- (void)sort{
    //快速排序
    [self quickSortWithLow:0 Height:self.mutableArray.count];
}
- (void)quickSortWithLow:(NSInteger)low Height:(NSInteger)height{
    if (height - low < 2) return;
    NSInteger mid = [self getPivotWithBegin:low End:height];
    [self quickSortWithLow:low Height:mid];
    [self quickSortWithLow:mid+1 Height:height];
}
- (NSInteger)getPivotWithBegin:(NSInteger)begin End:(NSInteger)end{
    //优化：对轴点元素随机，避免出现极端情况
//    [self swapWithOne:begin Two:begin+arc4random()%(end-begin)];
    
    id pivotValue = self.mutableArray[begin];
    end--;
    while (begin<end) {
        while (begin<end) {
            if ([self compare:pivotValue e2:self.mutableArray[end]] < 0) {
                end--;
            } else {
                self.mutableArray[begin++] = self.mutableArray[end];
                break;
            }
        }
        while (begin<end) {
            if ([self compare:pivotValue e2:self.mutableArray[begin]] > 0) {
                begin++;
            } else {
                self.mutableArray[end--] = self.mutableArray[begin];
                break;
            }
        }
    }
    self.mutableArray[begin] = pivotValue;
    return begin;
}

@end
