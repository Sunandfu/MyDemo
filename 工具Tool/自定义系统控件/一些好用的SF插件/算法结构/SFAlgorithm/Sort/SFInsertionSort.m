//
//  SFInsertionSort.m
//  algorithm
//
//  Created by lurich on 2021/9/4.
//

#import "SFInsertionSort.h"

@implementation SFInsertionSort

- (void)sort{
    //插入排序
//    [self sortFunc1];
    //优化2
    [self sortFunc2];
    //优化3
    [self sortFunc3];
}
- (void)sortFunc1{
    for (NSInteger i=1; i<self.mutableArray.count; i++) {
        NSInteger searchIndex = i;
        while (searchIndex>0 && [self compareWithOne:searchIndex Two:searchIndex-1] < 0) {
            [self swapWithOne:searchIndex Two:searchIndex-1];
            searchIndex--;
        }
    }
}
- (void)sortFunc2{
    for (NSInteger i=1; i<self.mutableArray.count; i++) {
        NSInteger searchIndex = i;
        id tmpValue = self.mutableArray[searchIndex];
        while (searchIndex>0 && [self compare:tmpValue e2:self.mutableArray[searchIndex-1]] < 0) {
            self.mutableArray[searchIndex] = self.mutableArray[searchIndex-1];
            searchIndex--;
        }
        self.mutableArray[searchIndex] = tmpValue;
    }
}
- (void)sortFunc3{
    for (NSInteger i=1; i<self.mutableArray.count; i++) {
        id tmpValue = self.mutableArray[i];
        NSInteger appropriateIndex = [self getAppropriateIndexWithEnd:i];
        for (NSInteger j=i; j>appropriateIndex; j--) {
            self.mutableArray[j] = self.mutableArray[j-1];
        }
        self.mutableArray[appropriateIndex] = tmpValue;
    }
}
- (NSInteger)getAppropriateIndexWithEnd:(NSInteger)current{
    NSInteger begin = 0;
    NSInteger end = current;
    //0-end
    while (begin<end) {
        NSInteger searchIndex = (end+begin)>>1;
        if ([self compareWithOne:current Two:searchIndex] < 0) {
            end = searchIndex;
        } else {
            begin = searchIndex+1;
        }
    }
    return begin;
}

@end
