//
//  ATLabel.m
//  LHALoadingView
//
//  Created by LiuHao on 16/4/26.
//  Copyright © 2016年 littleye. All rights reserved.
//

#import "ATLabel.h"

@implementation ATLabel
@synthesize wordList = _wordList;
@synthesize duration = _duration;

- (void)animateWithWords:(NSArray *)words forDuration:(double)time {
    self.duration = time;
    if(self.wordList){
        self.wordList = nil;
    }
    self.wordList = [[NSArray alloc] initWithArray:words];
    self.text = [self.wordList objectAtIndex:0];
    [NSThread detachNewThreadSelector:@selector(_startAnimations:) toTarget:self withObject:self.wordList];
    
}

- (void) _startAnimations:(NSArray *)images {
    
    @autoreleasepool {
        
        for (uint i = 1; i < [images count]; i++) {
            [NSThread sleepForTimeInterval:self.duration];
            [self performSelectorOnMainThread:@selector(_animate:)
                                   withObject:[NSNumber numberWithInt:i]
                                waitUntilDone:YES];
            [NSThread sleepForTimeInterval:self.duration];
            if (i == [images count] - 1) {
                i = -1;
            }
            
        }
        
    }
}


- (void) _animate:(NSNumber*)num
{
    
    [UIView animateWithDuration:self.duration animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:self.duration animations:^{
            self.alpha = 1.0;
            self.text = [self.wordList objectAtIndex:[num intValue]];
        } completion:^(BOOL finished) {
            
        }];
    }];
}
@end