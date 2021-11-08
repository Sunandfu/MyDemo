//
//  SFShellSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFShellSort.h"

@implementation SFShellSort

- (void)sort{
    //希尔排序
    NSArray *stepArray = [self getShellStep];
//    stepArray = [self getSedgewickStepSequence];
    for (NSNumber *step in stepArray) {
        [self sortWithStep:step.integerValue];
    }
}
- (void)sortWithStep:(NSInteger)step{
    // col : 第几列，column的简称
    for (NSInteger col = 0; col < step; col++) {
        for (NSInteger i=col+step; i<self.mutableArray.count; i+=step) {
            NSInteger searchIndex = i;
            while (searchIndex>col && [self compareWithOne:searchIndex Two:searchIndex-step] < 0) {
                [self swapWithOne:searchIndex Two:searchIndex-step];
                searchIndex -= step;
            }
        }
    }
}
- (NSArray *)getShellStep{
    NSMutableArray *stepArray = [NSMutableArray array];
    NSInteger step = self.mutableArray.count;
    while ((step >>= 1) > 0) {
        [stepArray addObject:@(step)];
    }
    return stepArray;
}
//获取列数 优化
- (NSArray *)getSedgewickStepSequence{
    /**
     偶数：9 * (2^k - 2^(k/2))+1
     奇数：8 * 2^k - 6 * 2^((k+1)/2) + 1
     */
    NSMutableArray *stepArray = [NSMutableArray array];
    int k = 0, step = 0;
    while (true) {
        if (k % 2 == 0) {
            int pow0 = (int) pow(2, k >> 1);
            step = 1 + 9 * (pow0 * pow0 - pow0);
        } else {
            int pow1 = (int) pow(2, (k - 1) >> 1);
            int pow2 = (int) pow(2, (k + 1) >> 1);
            step = 1 + 8 * pow1 * pow2 - 6 * pow2;
        }
        if (step >= self.mutableArray.count) break;
        [stepArray addObject:@(step)];
        k++;
    }
    return stepArray;
}

@end
