//
//  WSPersonModel.m
//  AddressBook
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "WSPersonModel.h"

@implementation WSPersonModel

- (NSMutableArray *)mobileArray
{
    if(!_mobileArray)
    {
        _mobileArray = [NSMutableArray array];
    }
    return _mobileArray;
}


@end
