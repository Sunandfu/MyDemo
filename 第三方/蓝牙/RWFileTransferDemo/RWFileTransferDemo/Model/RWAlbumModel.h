//
//  RWAlbum.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/26.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHFetchResult.h>

@interface RWAlbumModel : NSObject

@property (copy, nonatomic)NSString *title;

@property (strong, nonatomic)PHFetchResult *result;

@property (assign, nonatomic)NSInteger count;

@property (assign, nonatomic)NSString *fileType;

@end
