//
//  ViewController.m
//  VideoDemo
//
//  Created by lurich on 2021/3/15.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVKit/AVKit.h>
//照片详细操作，推荐使用Photos库
#import <Photos/Photos.h>
//视频更多操作，推荐使用MediaPlayer库
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,AVPlayerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic, strong) NSTimer *timer;

//录音与音频播放
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

//录制视频与视频播放
@property (nonatomic, strong) AVPlayerViewController *videoPlayer;
@property (nonatomic, strong) NSURL *videoUrl;

//调用照片
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        NSLog(@"PHAuthorizationStatus = %ld",(long)status);
    }];
}
- (AVAudioRecorder *)recorder{
    if (!_recorder) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music"];
        NSLog(@"path = %@",path);
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        //录音格式
        [settings setValue:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
        //采样率
        [settings setValue:@(44100) forKey:AVSampleRateKey];
        //录音通道
        [settings setValue:@(1) forKey:AVNumberOfChannelsKey];
        //录音质量
        [settings setValue:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
        _recorder.delegate = self;
        [_recorder prepareToRecord];
    }
    return _recorder;;
}
- (AVAudioPlayer *)musicPlayer{
    if (!_musicPlayer) {
//        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"folle" ofType:@"mp3"];
        NSLog(@"path = %@",path);
        _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        _musicPlayer.delegate = self;
        _musicPlayer.numberOfLoops = -1;//小于0，无限循环；等于0，不循环；大于0，循环N次
        [_musicPlayer prepareToPlay];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.currentTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02ld",self.musicPlayer.currentTime/60.0,(long)self.musicPlayer.currentTime%60];
            self.maxTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02ld",self.musicPlayer.duration/60.0,(long)self.musicPlayer.duration%60];
            self.progressSlider.value = self.musicPlayer.currentTime*1.0/self.musicPlayer.duration;
        }];
    }
    return _musicPlayer;
}
- (AVPlayerViewController *)videoPlayer{
    if (!_videoPlayer) {
        _videoPlayer = [[AVPlayerViewController alloc] init];
        _videoPlayer.delegate = self;
        _videoPlayer.requiresLinearPlayback = NO;//是否禁用快进和后退
        _videoPlayer.exitsFullScreenWhenPlaybackEnds = YES;//播放结束后，是否自动退出全屏
        _videoPlayer.entersFullScreenWhenPlaybackBegins = NO;//点击播放视频后，视频是否自动进入全屏幕
        if (@available(iOS 14.2, *)) {
            //进入后台是否自动画中画播放
            _videoPlayer.canStartPictureInPictureAutomaticallyFromInline = YES;
        } else {
            // Fallback on earlier versions
        }
        _videoPlayer.allowsPictureInPicturePlayback = YES;//是否允许画中画回放
        _videoPlayer.videoGravity = AVLayerVideoGravityResizeAspect;//不拉伸全部展示
        _videoPlayer.showsTimecodes = YES;//是否显示时间码(针对包含时间码的视频)
        _videoPlayer.showsPlaybackControls = YES;//是否显示播放控件
    }
    return _videoPlayer;;
}
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (IBAction)startRecordingAudio:(UIButton *)sender {
    if (sender.isSelected == NO) {
        [self.recorder record];
        sender.selected = YES;
    } else {
        [self.recorder stop];
        sender.selected = NO;
    }
//    if ([self.recorder isRecording]) {
//    } else {
//    }
}
- (IBAction)playAudio:(UIButton *)sender {
//    if ([self.musicPlayer isPlaying]) {
//    } else {
//    }
    
    if (sender.isSelected == NO) {
        [self.musicPlayer play];
        sender.selected = YES;
    } else {
        [self.musicPlayer pause];
        sender.selected = NO;
    }
}
- (IBAction)volumeAdjustWithSlider:(UISlider *)sender {
    self.musicPlayer.volume = sender.value;
}
- (IBAction)progressAdjustWithSlider:(UISlider *)sender {
    [self.musicPlayer pause];
    [self.musicPlayer setCurrentTime:self.musicPlayer.duration*sender.value];
    [self.musicPlayer play];
}
- (IBAction)startRecordVideo:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = @[(__bridge NSString *)kUTTypeMovie];
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//摄像机捕捉模式->Photo
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//默认摄像头为->后方
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;//闪光灯模式->自动
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"没有相机");
    }
}
- (IBAction)playVideo:(UIButton *)sender {
    if (sender.selected == NO) {
        [self.videoPlayer.player play];
        sender.selected = YES;
    } else {
        [self.videoPlayer.player pause];
        sender.selected = NO;
    }
}
- (IBAction)albumChoosePic:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"没有相册");
    }
}
- (IBAction)cameraShootPic:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.showsCameraControls = YES;//是否显示相机相关控件
//        self.imagePicker.cameraOverlayView = self.showImageView;//设置视图，已覆盖预览图，多为重定义拍照界面所用
//        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;//摄像机捕捉模式->Photo
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//默认摄像头为->后方
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;//闪光灯模式->自动
        self.imagePicker.cameraViewTransform = CGAffineTransformIdentity;//设置预览视图的转场动画
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"没有相机");
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音完成 success = %d",flag);
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    NSLog(@"录音出现错误 error = %@",error);
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放音频完成 success = %d",flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    NSLog(@"播放音频出现错误 error = %@",error);
}
#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewController:(AVPlayerViewController *)playerViewController willBeginFullScreenPresentationWithAnimationCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"视频即将全屏播放");
}
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"视频即将开始播放");
}
- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error{
    NSLog(@"视频播放失败");
}
- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"播放视频即将结束");
}
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController{
    return NO;
}
//画中画停止前的回调，用于处理界面
- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        self.showImageView.image = image;
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([type isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            //播放视频
            self.videoPlayer.player = [[AVPlayer alloc] initWithURL:videoUrl];
            self.videoPlayer.view.frame = self.videoView.bounds;
            [self.videoView addSubview:self.videoPlayer.view];
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
