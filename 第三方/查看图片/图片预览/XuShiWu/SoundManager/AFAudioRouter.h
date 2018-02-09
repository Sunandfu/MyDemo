//
//  AFAudioRouter.h
//  XuShiWu
//
//  Created by xsw on 15/12/23.
//  Copyright © 2015年 xsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AFAudioRouter : NSObject <AVAudioPlayerDelegate>

+(void)initAudioSessionRouting;
+(void)switchToDefaultHardware;
+(void)forceOutputToBuiltInSpeakers;

@end
