//
//  SFKVOObserverItem.h
//  MedProAdapter
//
//  Created by lurich on 2022/3/22.
//

#import <Foundation/Foundation.h>
#import "NSObject+SFCustomKVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFKVOObserverItem : NSObject

@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) id observer;
@property (nonatomic, copy) sf_KVOObserverBlock callback;

@end

NS_ASSUME_NONNULL_END
