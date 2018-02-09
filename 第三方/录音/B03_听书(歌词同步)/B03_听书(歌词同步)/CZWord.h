//
//  CZWords.h
//  B03_听书(歌词同步)
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZWord : NSObject
@property(nonatomic,strong)NSString *text;//诗词
@property(nonatomic,assign)double time;//诗词开始读的时间
@end
