//
//  SFStack.m
//  ApiTestDemo
//
//  Created by lurich on 2021/8/30.
//

#import "SFStack.h"

@interface SFStack ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFStack

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)size{
    return self.dataArray.count;
}
- (void)pushObject:(id)anObject{
    [self.dataArray addObject:anObject];
}
- (id)pop{
    id obj = [self.dataArray lastObject];
    [self.dataArray removeLastObject];
    return obj;
}
- (void)clear{
    [self.dataArray removeAllObjects];
}
- (BOOL)isEmpty{
    return self.dataArray.count==0;
}
- (id)peek{
    return [self.dataArray lastObject];
}
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

@end
