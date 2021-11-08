//
//  SFBubbleSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFBubbleSort.h"

@interface SFBubbleSort ()

@property (nonatomic, assign) NSInteger count;

@end

@implementation SFBubbleSort

- (void)sort{
    self.count = self.mutableArray.count;
    //冒泡排序
//    [self sortFunc1];
    //优化2
//    [self sortFunc2];
    //优化3
//    [self sortFunc3];
    //优化4
    [self sortFunc4];
}
- (void)sortFunc1{
    for (NSInteger i=self.count; i>0; i--) {
        for (NSInteger j=1; j<self.count; j++) {
            if ([self compareWithOne:j Two:j-1] < 0) {
                [self swapWithOne:j Two:j-1];
            }
        }
    }
}
- (void)sortFunc2{
    for (NSInteger i=self.count; i>0; i--) {
        for (NSInteger j=1; j<i; j++) {
            if ([self compareWithOne:j Two:j-1] < 0) {
                [self swapWithOne:j Two:j-1];
            }
        }
    }
}
- (void)sortFunc3{
    for (NSInteger i=self.count-1; i>0; i--) {
        BOOL sorted = YES;
        for (NSInteger j=1; j<=i; j++) {
            if ([self compareWithOne:j Two:j-1] < 0) {
                [self swapWithOne:j Two:j-1];
                sorted = NO;
            }
        }
        if (sorted) break;
    }
}
- (void)sortFunc4{
    for (NSInteger i=self.count-1; i>0; i--) {
        NSInteger sorted=1;
        for (NSInteger j=1; j<=i; j++) {
            if ([self compareWithOne:j Two:j-1] < 0) {
                [self swapWithOne:j Two:j-1];
                sorted = j;
            }
        }
        i = sorted;
    }
}

@end
