//
//  HTY360PlayerVC.h
//  HTY360Player
//
//  Created by  on 11/8/15.
//  Copyright © 2015 Hanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HTY360PlayerVC : UIViewController <AVPlayerItemOutputPullDelegate>

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) IBOutlet UIView *debugView;
@property (strong, nonatomic) IBOutlet UILabel *rollValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *yawValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *pitchValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *orientationValueLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL*)url;
- (CVPixelBufferRef)retrievePixelBufferToDraw;
- (void)toggleControls;

@end
