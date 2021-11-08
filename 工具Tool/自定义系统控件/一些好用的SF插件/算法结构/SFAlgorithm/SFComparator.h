//
//  SFComparator.h
//  ApiTestDemo
//
//  Created by lurich on 2021/9/2.
//

#import <Foundation/Foundation.h>

typedef int (^SFComparatorBlock)(id _Nonnull obj1, id _Nonnull obj2);

NS_ASSUME_NONNULL_BEGIN

@protocol SFComparator <NSObject>

@required
- (int)compare:(id)obj1 another:(id)obj2;

@end

NS_ASSUME_NONNULL_END
