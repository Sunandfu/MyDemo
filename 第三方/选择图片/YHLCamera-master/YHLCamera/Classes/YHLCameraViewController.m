//
//  YHLCameraViewController.m
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "YHLCameraViewController.h"
#import "YHLCameraButton.h"
#import "YHLCamera.h"
#import "YHLPanel.h"
#import "YHLClipViewController.h"

@interface YHLCameraViewController ()<YHLClipViewDelegate>
{
    BOOL _isInit;
    UIImage *_image;
}

@property (nonatomic,assign) cameraType type;

@property (nonatomic,strong) YHLCamera *camera;
@property (nonatomic,strong) YHLClipViewController *clipVC;

- (IBAction)cameraClick:(id)sender;
- (IBAction)closeClick:(id)sender;
@property (weak, nonatomic) IBOutlet YHLCameraButton *cameraButon;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/**
 驾驶证正面左下角标记
*/
//拍摄驾驶证正本正面 行驶证正本正面
@property (weak, nonatomic) IBOutlet UIView *driverFrontMarkView;
//驾驶证副本
@property (weak, nonatomic) IBOutlet UIView *driverBackMarkView;
//驾驶证正本背面 行驶证副本
@property (weak, nonatomic) IBOutlet UIView *drivingMarkBackView;

@property (weak, nonatomic) IBOutlet YHLPanel *maskView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *contentV;

@end

@implementation YHLCameraViewController

-(instancetype)initWithParam:(cameraType)type{
    self = [self initWithNibName:@"YHLCameraViewController" bundle:[NSBundle bundleForClass:[YHLCameraViewController class]]];
//    self = [self init];
    if (self) {
        self.type=type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    [self setupUI];
    self.maskView.type=self.type;
    self.camera=[[YHLCamera alloc] init];
    
    self.clipVC=[[YHLClipViewController alloc] initWithNibName:@"YHLClipViewController" bundle:[NSBundle bundleForClass:[YHLClipViewController class]]];
    self.clipVC.delegate=self;
    
    [self addChildViewController:self.clipVC];
}

-(void)setupUI{
    self.cameraButon.layer.cornerRadius=25;
    self.cameraButon.clipsToBounds=YES;
    
    self.closeButton.hidden=self.navigationController!=nil;
    
    self.driverFrontMarkView.layer.borderWidth=1;
    self.driverFrontMarkView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.driverFrontMarkView.layer.cornerRadius=3;
    
    self.drivingMarkBackView.layer.borderWidth=1;
    self.drivingMarkBackView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.drivingMarkBackView.layer.cornerRadius=3;
    
    self.driverBackMarkView.layer.borderWidth=1;
    self.driverBackMarkView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.driverBackMarkView.layer.cornerRadius=3;
    
    cameraType type = self.type;
    if (type==driverFrontType||type==drivingFrontType) {
        self.driverBackMarkView.hidden=YES;
        self.drivingMarkBackView.hidden=YES;
        self.driverFrontMarkView.hidden=NO;
    }else if(type == drivingCopyType){
        self.driverBackMarkView.hidden=YES;
        self.drivingMarkBackView.hidden=NO;
        self.driverFrontMarkView.hidden=YES;
    }else if(type == driverBackType){
        self.driverBackMarkView.hidden=NO;
        self.drivingMarkBackView.hidden=YES;
        self.driverFrontMarkView.hidden=YES;
    }else if(type == personType){
        self.contentV.hidden=YES;
        self.desLabel.hidden=YES;
    }else if (type == defaultType){
        self.contentV.hidden=YES;
        self.desLabel.hidden=YES;
    }
    else{
        self.driverBackMarkView.hidden=YES;
        self.drivingMarkBackView.hidden=YES;
        self.driverFrontMarkView.hidden=YES;
    }
    
    if (type==driverFrontType) {
        self.titleLabel.text=@"中华人民共和国机动车驾驶证";
        self.desLabel.text=@"将驾驶证主页置于此区域，并对齐左下角发证机关印章";
        self.navigationItem.title=@"拍摄驾驶证正本正面";
    }else if (type==driverBackType){
        self.titleLabel.text=@"中华人民共和国机动车驾驶证";
        self.desLabel.text=@"将驾驶证正本背面置于此区域，并对齐左下角的条形码";
        self.navigationItem.title=@"拍摄驾驶证正本背面";
    }else if (type==driverCopyType){
        self.titleLabel.text=@"中华人民共和国机动车驾驶证副本";
        self.desLabel.text=@"将驾驶证副本置于此区域，并对齐右下角条形码";
        self.navigationItem.title=@"拍摄驾驶证副本";
    }else if (type==drivingFrontType){
        self.titleLabel.text=@"中华人民共和国机动车行驶证";
        self.desLabel.text=@"将行驶证主页置于此区域，并对齐左下角发证机关印章";
        self.navigationItem.title=@"拍摄行驶证正本";
    }else if (type==drivingCopyType){
        self.titleLabel.text=@"中华人民共和国机动车行驶证副本";
        self.desLabel.text=@"将行驶证副本置于此区域，并对齐右下角条形码";
        self.navigationItem.title=@"拍摄行驶证副本";
    }else if (type==idFrontType){
        self.titleLabel.text=@"中华人民共和国居民身份证正面";
        self.desLabel.text=@"将身份证正面置于此区域";
        self.navigationItem.title=@"拍摄身份证正面";
    }else if (type==idBackType){
        self.titleLabel.text=@"中华人民共和国居民身份证背面";
        self.desLabel.text=@"将身份证背面置于此区域";
        self.navigationItem.title=@"拍摄身份证背面";
    }else if (type==personType){
        self.titleLabel.text=@"";
        self.desLabel.text=@"";
        self.navigationItem.title=@"拍摄个人上半身照片";
    }else if (type==defaultType){
        self.titleLabel.text=@"";
        self.desLabel.text=@"";
        self.navigationItem.title=@"系统默认拍摄";
    }
}

- (IBAction)cameraClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.camera stop:^(UIImage *image) {
        [weakSelf clipImage:image];
    }];
}

-(void)clipImage:(UIImage *)image{
    CGSize sz = [image size];
    CGSize size = self.view.bounds.size;
    
    if (self.type == personType) {
        CGFloat left = ([UIScreen mainScreen].bounds.size.width-240)*0.5;
        CGFloat top = ([UIScreen mainScreen].bounds.size.height-360-80)*0.5;//80 底部空白
        CGFloat x = (sz.width/size.width)*left;
        CGFloat y = (sz.height/size.height)*top;
        CGFloat w = (sz.width/size.width)*(size.width-left*2);
        CGFloat h =(sz.height/size.height)*240;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
        
    }else if (self.type == defaultType){
        CGFloat x =0;
        CGFloat y = 0;
        CGFloat w = (sz.width/size.width)*(size.width);
        CGFloat h =(sz.height/size.height)*size.height;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    }else{
        CGSize sz = [image size];
        CGSize size = self.view.bounds.size;
        CGFloat x = (sz.width/size.width)*15;
        CGFloat y = (sz.height/size.height)*150;
        CGFloat w = (sz.width/size.width)*(size.width-30);
        CGFloat h =(sz.height/size.height)*((size.width-30)*11.0/16);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    }
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    _image=im;
    if (self.type==defaultType) {
        self.clipVC.defaultImage.image=im;
        self.clipVC.imageView.hidden=YES;
        self.clipVC.defaultImage.hidden=NO;
    }else{
        self.clipVC.imageView.image=im;
        self.clipVC.defaultImage.hidden=YES;
        self.clipVC.imageView.hidden=NO;
    }
    
    UIGraphicsEndImageContext();
    
    
    [self.view addSubview:self.clipVC.view];
    
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark YHLClipViewDelegate
- (void)resetCameraClick{
    [self.clipVC.view removeFromSuperview];
    [self.camera start];
}
- (void)okCameraClick{
    
    if ([self.delegate respondsToSelector:@selector(camera:)]) {
        [self.delegate camera:_image];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.clipVC.view.frame=self.view.bounds;
    if (!_isInit) {
        [self.camera pz:self];
        _isInit=YES;
    }
}
@end
