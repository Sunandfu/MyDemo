//
//  MSPadHorizonSupport.m
//  mushuIpad
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import "MSPadHorizonSupport.h"

@implementation MPIndexPath

+ (id)indexPathWithSection:(NSUInteger)section andCol:(NSUInteger)col{
    MPIndexPath *indexPath = [MPIndexPath new];
    indexPath.section = section;
    indexPath.col = col;
    return indexPath;
}

- (BOOL)isEqual:(id)object {
    MPIndexPath *obj = (MPIndexPath*)object;
    if (object == self || [self isEqualIndexPath:obj]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualIndexPath:(MPIndexPath *)indexPath{
    return self.section == indexPath.section && self.col == indexPath.col;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"section:%zd, col:%zd", self.section, self.col];
}

@end

@implementation MSPadHorizonPos

- (id)init{
    if (self = [super init]) {
        self.beginPos = self.endPos = 0;
    }
    return self;
}

+ (id)posWithBegin:(CGFloat)begin andEnd:(CGFloat)end{
    MSPadHorizonPos *pos = [[self class] new];
    pos.beginPos = begin;
    pos.endPos = end;
    return pos;
}
@end

#pragma mark ---------MSPadBinarySearch---------

@implementation NSMutableArray (MSPadBinarySearch)

- (NSUInteger)indexOfObjectBinarySearch:(MP_SEARCH_CASE (^)(id, NSUInteger, BOOL *))comparator{
    NSInteger start = 0;
    NSInteger end = self.count - 1;
    NSInteger middle = 0;
    BOOL stop = NO;
    MP_SEARCH_CASE mcase = MP_SEARCH_HIGH;
    while (mcase != MP_SEARCH_EQUAL) {
        middle = (start + end) / 2;
        mcase = comparator(self[middle], middle, &stop);
        if (stop) {
            return middle;
        }
        if (mcase == MP_SEARCH_LOW) {
            end = middle - 1;
        }else if (mcase == MP_SEARCH_HIGH){
            start = middle + 1;
        }else {
            break;
        }
        if (start > end) {
            return NSNotFound;
        }
    }
    return middle;
}

- (NSUInteger)mp_indexOfObjectBinarySearch:(MP_SEARCH_CASE (^)(id))comparator{
    NSInteger start = 0;
    NSInteger end = self.count - 1;
    NSInteger middle = 0;
    MP_SEARCH_CASE mcase = MP_SEARCH_HIGH;
    while (mcase != MP_SEARCH_EQUAL) {
        middle = (start + end) / 2;
        mcase = comparator(self[middle]);
        if (mcase == MP_SEARCH_LOW) {
            end = middle - 1;
        }else if (mcase == MP_SEARCH_HIGH){
            start = middle + 1;
        }else {
            break;
        }
        if (start > end) {
            return middle;// 
        }
    }
    return middle;
}
@end