//
//  CZAudioTool.h
//  B01_短音频播放
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface CZAudioTool : NSObject
singleton_interface(CZAudioTool);


/**
 *  通过MP3的名字播放音频
 *
 */
-(void)playMp3WithName:(NSString *)mp3Name;
@end
