//
//  NSObject+TDCopy.m
//  Roomorama
//
//  Created by Roomorama on 27/12/12.
//  Copyright (c) 2012 Roomorama. All rights reserved.
//

#import "NSObject+RMCopyable.h"
#import "RMMapper.h"


@implementation NSObject (RMCopyable)

-(id)copyWithZone:(NSZone *)zone {
    typeof(self) copiedObj = [[[self class] allocWithZone:zone] init];
    if (copiedObj) {
        NSDictionary* properties = [RMMapper propertiesForClass:[self class]];
        for (NSString* key in properties) {
            id val = [self valueForKey:key];
            [copiedObj setValue:val forKey:key];
        }
    }
    return copiedObj;
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com