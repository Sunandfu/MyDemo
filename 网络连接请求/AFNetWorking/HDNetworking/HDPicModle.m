//
//  HDPicModle.m
//  PortableTreasure
//
//  Created by HeDong on 16/2/10.
//  Copyright © 2016年 hedong. All rights reserved.
//

#import "HDPicModle.h"

@implementation HDPicModle

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ : %p> \n{picName : %@ \n pic : %@ \n}", [self class], self,self.picName, self.pic];
}

@end
