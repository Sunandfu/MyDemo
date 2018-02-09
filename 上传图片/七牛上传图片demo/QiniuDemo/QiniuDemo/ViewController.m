//
//  ViewController.m
//  QiniuDemo
//
//  Created by Nemo on 16/3/9.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#define kDocumentsPath                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define kIOS7_OR_LATER      ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define kMainScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define kMainScreenHeight     [[UIScreen mainScreen] bounds].size.height


#import "ViewController.h"
#import "QiniuSDK.h"
#import "QiniuPutPolicy.h"
#import "UIImage-Extensions.h"
#import "UIImageView+WebCache.h"

//   七牛账号 3290235031@qq.com   密码为通用密码
/**
 *  注册七牛获取
 */
static NSString *QiniuAccessKey        = @"h0bXX0GmjrPhYmiIsEAYhDfBfDV3TRlUzw5x2KgM";
static NSString *QiniuSecretKey        = @"VnfjFKOYxlow2u-yCBRJWoVUqOV_F5oew0z-i2fF";
static NSString *QiniuBucketName       = @"lurich";
static NSString *QiniuBaseURL          = @"http://o9s9yvu2a.bkt.clouddn.com/";

@interface ViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIImageView *faceImage;

@end

@implementation ViewController

#pragma mark - QINIU Method
- (NSString *)tokenWithScope:(NSString *)scope
{
    QiniuPutPolicy *policy = [QiniuPutPolicy new];
    policy.scope = scope;
    return [policy makeToken:QiniuAccessKey secretKey:QiniuSecretKey];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (kIOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"七牛上传";
    
    UIButton *sendPhoto = [[UIButton alloc] initWithFrame:CGRectMake(0, (kMainScreenHeight-64)/2-20, kMainScreenWidth/2, 40)];
    sendPhoto.backgroundColor = [UIColor orangeColor];
    sendPhoto.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sendPhoto addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    [sendPhoto setTitle:@"上传图片" forState:UIControlStateNormal];
    [self.view addSubview:sendPhoto];
    
    
    UIButton *sendMovie = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, (kMainScreenHeight-64)/2-20, kMainScreenWidth/2, 40)];
    sendMovie.backgroundColor = [UIColor greenColor];
    sendMovie.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sendMovie addTarget:self action:@selector(sendMoive) forControlEvents:UIControlEventTouchUpInside];
    [sendMovie setTitle:@"上传视频" forState:UIControlStateNormal];
    [self.view addSubview:sendMovie];
    

}

- (UIImageView *)faceImage
{
    if (!_faceImage) {
        
        _faceImage = [[UIImageView alloc] init];
        [self.view addSubview:_faceImage];
        _faceImage.frame = CGRectMake(10, 10, 90, 90);
    }
    return _faceImage;
}


#pragma mark - 上传图片
- (void)sendPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"照片库", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - 上传视频
- (void)sendMoive
{
    //快捷上传图片
   
    
        
        NSString *token = [self tokenWithScope:QiniuBucketName];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
        NSString *uniquePath = [[NSBundle mainBundle] pathForResource:@"psb5" ofType:@"jpg"];
    
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        
        NSString *key = [NSURL fileURLWithPath:uniquePath].lastPathComponent;
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                   progressHandler:^(NSString *key, float percent){
                                                       
                                                   }
                                                            params:@{ @"x:foo":@"fooval" }
                                                          checkCrc:YES
                                                cancellationSignal:nil];
        
        
        [upManager putData:data key:key token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (!info.error) {
                          NSString *contentURL = [NSString stringWithFormat:@"%@%@",QiniuBaseURL,key];
                          
                          NSLog(@"QN Upload Success URL= %@",contentURL);
                          
                      }
                      else {
                          
                          NSLog(@"%@",info.error);
                      }
                  } option:opt];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self albumBtnPressed];
    }else if (buttonIndex == 0){
        
        [self cameraBtnPressed];
    }

}

- (void)albumBtnPressed
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
        [alert show];
    }
    else {
        UIImagePickerController *filePicker = [[UIImagePickerController alloc] init];
        filePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        filePicker.delegate = self;
        filePicker.mediaTypes = [NSArray arrayWithObject:@"public.image"];
        filePicker.allowsEditing = YES;
        filePicker.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController presentViewController:filePicker animated:YES completion:^{
            
            
        }];
    }
}

- (void)cameraBtnPressed
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
        [alert show];
    }
    else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
        imagePickerController.allowsEditing = YES;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    {
        UIImage *originImage = [info valueForKey:UIImagePickerControllerEditedImage];
        
        CGSize cropSize;
        cropSize.width = 180;
        cropSize.height = cropSize.width * originImage.size.height / originImage.size.width;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        originImage = [originImage imageByScalingToSize:cropSize];
        
        NSData *imageData = UIImageJPEGRepresentation(originImage, 0.9f);
        
        NSString *uniqueName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:date]];
        NSString *uniquePath = [kDocumentsPath stringByAppendingPathComponent:uniqueName];
        
        NSLog(@"uniquePath: %@",uniquePath);
        
        [imageData writeToFile:uniquePath atomically:NO];
        
        NSLog(@"Upload Image Size: %lu KB",[imageData length] / 1024);
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            NSString *token = [self tokenWithScope:QiniuBucketName];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            
            NSData *data = [NSData dataWithContentsOfFile:uniquePath];
            
            NSString *key = [NSURL fileURLWithPath:uniquePath].lastPathComponent;
            
            QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                       progressHandler:^(NSString *key, float percent){
                                                          
                                                       }
                                                                params:@{ @"x:foo":@"fooval" }
                                                              checkCrc:YES
                                                    cancellationSignal:nil];
            
            
            [upManager putData:data key:key token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if (!info.error) {
                              NSString *contentURL = [NSString stringWithFormat:@"%@%@",QiniuBaseURL,key];
                              
                              NSLog(@"QN Upload Success URL= %@",contentURL);
                              
                              [self.faceImage sd_setImageWithURL:[NSURL URLWithString:contentURL] placeholderImage:[UIImage imageNamed:@"cu_icon_default"]];
                          }
                          else {
                              
                              NSLog(@"%@",info.error);
                          }
                      } option:opt];
        }];
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com