//
//  Singleton.h
//  JinJiangInn
//
//  Created by xie aki on 12-12-19.
//  Copyright (c) 2012年 JJInn. All rights reserved.
//

#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname) \
+ (classname *)sharedInstance;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *sharedInstance = nil; \
static dispatch_once_t onceToken; \
\
+ (classname *)sharedInstance \
{ \
@synchronized(self) \
{ \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[classname alloc] init]; \
}); \
} \
\
return sharedInstance; \
} \
\
