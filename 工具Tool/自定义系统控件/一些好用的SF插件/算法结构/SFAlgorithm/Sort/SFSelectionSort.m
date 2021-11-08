//
//  SFSelectionSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFSelectionSort.h"

@implementation SFSelectionSort

- (void)sort{
    //选择排序
    for (NSInteger i=self.mutableArray.count-1; i>0; i--) {
        NSInteger maxIndex = 0;
        for (NSInteger j=1; j<=i; j++) {
            if ([self compareWithOne:maxIndex Two:j] <= 0) {
                maxIndex = j;
            }
        }
        [self swapWithOne:maxIndex Two:i];
    }
}

@end
