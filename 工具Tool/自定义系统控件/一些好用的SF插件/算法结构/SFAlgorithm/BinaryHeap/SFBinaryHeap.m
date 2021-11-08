//
//  SFBinaryHeap.m
//  algorithm
//
//  Created by lurich on 2021/9/6.
//

#import "SFBinaryHeap.h"

@interface SFBinaryHeap ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) SFComparatorBlock comparatorBlock;
@property (nonatomic, weak) id<SFComparator> comparator;

@end

@implementation SFBinaryHeap

- (instancetype)init{
    self = [super init];
    if (self && !_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}
+ (instancetype _Nonnull )heapWithArray:(NSArray *)array ComparatorBlock:(_Nullable SFComparatorBlock)comparatorBlock{
    SFBinaryHeap *heap = [[self alloc] init];
    heap.dataArray = [NSMutableArray arrayWithArray:array];
    heap.comparatorBlock = comparatorBlock;
    [heap heapify];
    return heap;
}
+ (instancetype _Nonnull )heapWithArray:(NSArray *)array Comparator:(_Nullable id<SFComparator>)comparator{
    SFBinaryHeap *heap = [[self alloc] init];
    heap.dataArray = [NSMutableArray arrayWithArray:array];
    heap.comparator = comparator;
    [heap heapify];
    return heap;
}

- (BOOL)isEmpty{
    return self.dataArray.count == 0;
}
- (void)clear{
    [self.dataArray removeAllObjects];
}
- (id)get{
    return [self.dataArray firstObject];
}
- (void)addObject:(id)obj{
    if (obj) {
        [self.dataArray addObject:obj];
        [self siftUp:self.dataArray.count-1];
    }
}
- (int)compare:(id)e1 e2:(id)e2 {
    return self.comparatorBlock ? self.comparatorBlock(e1, e2) :
    (_comparator ? [_comparator compare:e1 another:e2] : (int)[e1 compare:e2]);
}

- (int)compareWithOne:(NSInteger)one Two:(NSInteger)two{
    return [self compare:self.dataArray[one] e2:self.dataArray[two]];
}
- (id)remove{
    if (self.dataArray.count == 0) return nil;
    id root = [self.dataArray firstObject];
    self.dataArray[0] = [self.dataArray lastObject];
    [self.dataArray removeLastObject];
    [self siftDown:0];
    return root;
}
- (id)replaceObject:(id)obj{
    if (self.dataArray.count == 0) return nil;
    id root = [self.dataArray firstObject];
    self.dataArray[0] = obj;
    [self siftDown:0];
    return root;
}
- (void)heapify{
    if (self.dataArray.count == 0) return;
    for (NSInteger i=(self.dataArray.count>>1)-1; i>=0; i--) {
        [self siftDown:i];
    }
}
//下滤
- (void)siftDown:(NSInteger)index{
    id obj = self.dataArray[index];
    NSInteger half = self.dataArray.count>>1;
    while (index<half) {
        NSInteger left = (index<<1) + 1;
        NSInteger right = left + 1;
        id maxChild = self.dataArray[left];
        NSInteger maxChildIndex = left;
        
        if (right<self.dataArray.count && [self compare:self.dataArray[right] e2:maxChild]>0) {//证明右节点存在并且大于左子节点
            maxChild = self.dataArray[right];
            maxChildIndex = right;
        }
        if ([self compare:obj e2:maxChild] >= 0) break;
        
        self.dataArray[index] = maxChild;
        index = maxChildIndex;
    }
    self.dataArray[index] = obj;
}
//上滤
- (void)siftUp:(NSInteger)index{
    id obj = self.dataArray[index];
    while (index>0) {
        NSInteger parentIndex = (index - 1)>>1;
        if ([self compare:self.dataArray[parentIndex] e2:obj] >= 0) break;
        self.dataArray[index] = self.dataArray[parentIndex];
        index = parentIndex;
    }
    self.dataArray[index] = obj;
}
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

@end
