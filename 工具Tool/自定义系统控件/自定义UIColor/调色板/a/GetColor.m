//
//  GetColor.m
//  a
//
//  Created by Ibokan on 15/9/28.
//  Copyright © 2015年 Crazy凡. All rights reserved.
//

#import "GetColor.h"
#import "TouchView.h"

typedef struct {
    double a;
    int r;
    int g;
    int b;
    
}MyColor;

@interface GetColor ()

@property (nonatomic,strong) UIImageView *mainViewa;
@property (nonatomic,strong) UIView *mainViewb;
@property (nonatomic,strong) UIView *mainViewc;
@property (nonatomic,strong) UIView *mainViewcsub;
@property (nonatomic,strong) UIView *rgbView;
@property (nonatomic,strong) UIImageView *rgbViewBG;
@property (nonatomic,strong) UILabel *pointera;
@property (nonatomic,strong) UILabel *pointerb;
@property (nonatomic,strong) UILabel *pointerc;
@property (nonatomic,strong) UILabel *rLabel;
@property (nonatomic,strong) UITextField *rText;
@property (nonatomic,strong) UILabel *gLabel;
@property (nonatomic,strong) UITextField *gText;
@property (nonatomic,strong) UILabel *bLabel;
@property (nonatomic,strong) UITextField *bText;
@property (nonatomic,strong) UILabel *aLabel;
@property (nonatomic,strong) UITextField *aText;
@property (nonatomic,assign) MyColor colora;
@property (nonatomic,assign) MyColor colorb;
@property (nonatomic,assign) MyColor colorc;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic, strong) UILabel *hexLabel;
@end


@implementation GetColor

- (instancetype)init {
    self = [super init];
    if (self) {
        [self otherInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self otherInit];
    }
    return self;
}
#pragma -mark 初始化
- (void)otherInit {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

    
    self.colora = self.colorb = self.colorc = [self setMyColorWithR:255 G:0 B:0 A:1];
    self.color = [UIColor redColor];
    
    self.mainViewa = [self myViewInitWithcase:NO];
    self.mainViewa.contentMode = UIViewContentModeScaleToFill;
    self.mainViewa.image = [self getMainImg];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mainViewa attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:16]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mainViewa attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_mainViewa attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    self.mainViewb = [self myViewInitWithcase:YES];
    [self setTopAndHeightWithViewA:_mainViewb ViewB:_mainViewa Distance:30 Height:50];
    self.mainViewc = [self myViewInitWithcase:YES];
    [self setTopAndHeightWithViewA:_mainViewc ViewB:_mainViewb Distance:30 Height:50];
    self.rgbViewBG = [self myViewInitWithcase:NO];
    [self setTopAndHeightWithViewA:_rgbViewBG ViewB:_mainViewc Distance:30 Height:80];
    self.rgbView = [self myViewInitWithcase:YES];
    [self setTopAndHeightWithViewA:_rgbView ViewB:_mainViewc Distance:30 Height:80];
    
    self.rLabel = [self myLabelInitWithTitle:@"R:"];
    self.rText = [self myTextFieldinit];
    self.gLabel = [self myLabelInitWithTitle:@"G:"];
    self.gText = [self myTextFieldinit];
    self.bLabel = [self myLabelInitWithTitle:@"B:"];
    self.bText = [self myTextFieldinit];
    self.aLabel = [self myLabelInitWithTitle:@"A:"];
    self.aText = [self myTextFieldinit];
    self.hexLabel = [self myLabelInitWithTitle:@"#FF0000"];
    self.hexLabel.backgroundColor = [UIColor clearColor];
    
    NSDictionary * dice = NSDictionaryOfVariableBindings(_rLabel,_gLabel,_bLabel,_rText,_gText,_bText,_aLabel,_aText);
    NSString * stre = @"H:|-0-[_rLabel]-0-[_rText]-0-[_gLabel]-0-[_gText]-0-[_bLabel]-0-[_bText]-0-[_aLabel]-0-[_aText]-0-|";
    NSArray * arre = [NSLayoutConstraint constraintsWithVisualFormat:stre options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dice];
    [self.rgbView addConstraints:arre];
    
    [self setTopAndHeightWithViewA:_rLabel ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_gLabel ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_bLabel ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_aLabel ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_rText ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_gText ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_bText ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_aText ViewB:_rgbView Distance:-80 Height:35];
    [self setTopAndHeightWithViewA:_hexLabel ViewB:_rgbView Distance:-45 Height:45];
    
    [self setEWidthWithViewA:_bLabel ViewB:_rLabel Multiple:1];
    [self setEWidthWithViewA:_gLabel ViewB:_bLabel Multiple:1];
    [self setEWidthWithViewA:_aLabel ViewB:_gLabel Multiple:1];
    [self setEWidthWithViewA:_rText ViewB:_rLabel Multiple:2];
    [self setEWidthWithViewA:_gText ViewB:_gLabel Multiple:2];
    [self setEWidthWithViewA:_bText ViewB:_bLabel Multiple:2];
    [self setEWidthWithViewA:_aText ViewB:_aLabel Multiple:2];
    [self setEWidthWithViewA:_hexLabel ViewB:_rgbView Multiple:1];
    
    self.rText.text = @"255";
    self.gText.text = @"0";
    self.bText.text = @"0";
    self.aText.text = @"1";
    
}
#pragma -mark Addtouch 事件
- (void)addTouchViews; {
    TouchView *tva = [[TouchView alloc]initWithFrame:self.mainViewa.frame];
    [self addSubview:tva];
    __weak __block GetColor *copy_self = self;
    [tva setBlock:^(CGPoint point,short flag) {
        [copy_self touchAWithPoint:point Flag:flag];
    }];
    
    TouchView *tvb = [[TouchView alloc]initWithFrame:self.mainViewb.bounds];
    [self.mainViewb addSubview:tvb];
    [tvb setBlock:^(CGPoint point,short flag) {
        [copy_self touchBWithPoint:point Flag:flag];
    }];
    
    TouchView *tvc = [[TouchView alloc]initWithFrame:self.mainViewc.bounds];
    [self.mainViewc addSubview:tvc];
    [tvc setBlock:^(CGPoint point,short flag) {
        [copy_self touchCWithPoint:point Flag:flag];
    }];
    
}

#pragma -mark touchEvent 事件
- (void)touchAWithPoint:(CGPoint)point Flag:(short)flag{
    if(flag == -1)
    {
        point = self.pointera.frame.origin;
        point.x += 5;
        point.y += 5;
    }
    CGFloat pointX = point.x;
    CGFloat pointY = point.y;
    CGFloat viewHalfH = self.mainViewa.frame.size.height;
    CGFloat viewhalfW = self.mainViewa.frame.size.width;
    //确定特殊的pointY
    if (pointY < 0){
        pointY = 0;
    }
    if (pointY > viewHalfH) {
        pointY = viewHalfH;
    }
    //确定特殊的pointX
    if (pointX < 0){
        pointX = 0;
    }
    if (pointX > viewhalfW){
        pointX = viewhalfW;
    }
    
    //改变指示器位置
    CGRect frame = self.pointera.frame;
    frame.origin.x = pointX - 5;
    frame.origin.y = pointY - 5;
    self.pointera.frame = frame;
    
    int r,g,b;
    double xrate = [self check: pointX / viewhalfW];
    double yrate = 1 - [self check: pointY / viewHalfH];
    
    MyColor tempa = [self setMyColorWithR:255 * yrate G:255 * yrate B:255 * yrate A:1];
    r = self.colora.r * yrate;
    g = self.colora.g * yrate;
    b = self.colora.b * yrate;
    MyColor tempb = [self setMyColorWithR:r G:g B:b A:1];
    r = tempa.r - xrate * (tempa.r - tempb.r);
    g = tempa.g - xrate * (tempa.g - tempb.g);
    b = tempa.b - xrate * (tempa.b - tempb.b);
    self.colorc = self.colorb = [self setMyColorWithR:r G:g B:b A:1];
    
    [self setBackgroundColorWithUIColors:@[[self transformMyColorToUIColor:self.colorb],[UIColor clearColor]] View:self.mainViewcsub];
    [self touchCWithPoint:CGPointMake(0, 0) Flag:-1];
}
- (void)touchBWithPoint:(CGPoint)point Flag:(short)flag{
    CGFloat pointX = point.x;
    CGFloat viewhalfW = self.mainViewb.frame.size.width;
    //控制边界
    if (pointX < 0){
        pointX = 0;
    }
    if (pointX > viewhalfW){
        pointX = viewhalfW;
    }
    
    //改变指示器位置
    CGRect frame = self.pointerb.frame;
    frame.origin.x = pointX - 2;
    self.pointerb.frame = frame;
    
    //颜色计算器部分
    int r,g,b;
    int n = 1530 * [self check: pointX / viewhalfW];
    switch (n/255) {
        case 0: r = 255; g = 0; b = n; break;
        case 1: r = 255 - (n % 255); g = 0; b = 255; break;
        case 2: r = 0; g = n % 255; b = 255; break;
        case 3: r = 0; g = 255; b = 255 - (n % 255); break;
        case 4: r = n % 255; g = 255; b = 0; break;
        case 5: r = 255; g = 255 - (n % 255); b = 0; break;
        default: r = 255; g = 0; b = 0; break;
    }
    
    self.colora = [self setMyColorWithR:r G:g B:b A:1];
    
    self.mainViewa.backgroundColor = [self transformMyColorToUIColor:self.colora];
    [self touchAWithPoint:CGPointMake(0, 0) Flag:-1];
}
- (void)touchCWithPoint:(CGPoint)point Flag:(short)flag{
    if(flag == -1)
    {
        point = self.pointerc.frame.origin;
        point.x += 2;
    }
    CGFloat pointX = point.x;
    CGFloat viewhalfW = self.mainViewc.frame.size.width;
    //控制边界
    if (pointX < 0){
        pointX = 0;
    }
    if (pointX > viewhalfW){
        pointX = viewhalfW;
    }
    CGRect frame = self.pointerc.frame;
    frame.origin.x = pointX - 2;
    self.pointerc.frame = frame;
    
    double xrate = 1 - [self check: pointX / viewhalfW];
    MyColor temp = self.colorc;
    temp.a = xrate;
    self.colorc = temp;
    
    self.color = [self transformMyColorToUIColor:self.colorc];
    self.rgbView.backgroundColor = self.color;
    self.rText.text = [NSString stringWithFormat:@"%d",self.colorc.r];
    self.gText.text = [NSString stringWithFormat:@"%d",self.colorc.g];
    self.bText.text = [NSString stringWithFormat:@"%d",self.colorc.b];
    self.aText.text = [NSString stringWithFormat:@"%.2lf",self.colorc.a];
    self.hexLabel.text = [NSString stringWithFormat:@"#%02X%02X%02X",self.colorc.r,self.colorc.g,self.colorc.b];
    self.hexLabel.textColor = [UIColor colorWithRed:(255-self.colorc.r)/255.0 green:(255-self.colorc.g)/255.0 blue:(255-self.colorc.b)/255.0 alpha:self.colorc.a];
    self.block(self.color);
}
//避免拖动值超出边界
- (double)check:(double)a {
    return  a > 1 ? 1 : a < 0 ? 0 : a;
}

#pragma -mark 贴图准备工作
- (void)runThisMetodWhenViewDidAppear {
    //初始化颜色显示
    [self setBackgroundColorWithUIColors:@[[UIColor redColor],[UIColor magentaColor],[UIColor blueColor],[UIColor cyanColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor]] View:self.mainViewb];
    
    //初始化颜色显示
    UIImage *img = [self getBGImg];
    self.rgbViewBG.contentMode = UIViewContentModeScaleAspectFill;
    [self.rgbViewBG setImage:img];
    
    UIImageView * p = [[UIImageView alloc]initWithFrame:self.mainViewc.bounds];
    p.contentMode = UIViewContentModeScaleAspectFill;
    p.image = img;
    [self.mainViewc addSubview:p];
    
    self.mainViewcsub = [[UIView alloc]initWithFrame:self.mainViewc.bounds];
    [self.mainViewc addSubview:self.mainViewcsub];
    [self setBackgroundColorWithUIColors:@[[UIColor redColor],[UIColor clearColor]] View:self.mainViewcsub];
    
    //添加指示点
    self.pointera = [self addPointerToView:self.mainViewa Type:1];
    self.pointerb = [self addPointerToView:self.mainViewb Type:2];
    self.pointerc = [self addPointerToView:self.mainViewc Type:2];
    //touch事件
    [self addTouchViews];
}

#pragma -mark 添加Top and Height 约束
- (void)setTopAndHeightWithViewA:(UIView*)va ViewB:(UIView*)vb Distance:(int)distance Height:(double)height {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:va attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:vb attribute:NSLayoutAttributeBottom multiplier:1 constant:distance]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:va attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:height]];
}

#pragma -mark 添加宽度 约束
- (void)setEWidthWithViewA:(UIView*)va ViewB:(UIView*)vb Multiple:(double)mu {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:va attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:vb attribute:NSLayoutAttributeWidth multiplier:mu constant:0]];
}

#pragma -mark view初始化
- (id)myViewInitWithcase:(BOOL)a {
    UIView *temp;
    temp = a ? [[UIView alloc]init] : [[UIImageView alloc]init];
    temp.translatesAutoresizingMaskIntoConstraints = NO;
    temp.layer.masksToBounds = YES;
    temp.backgroundColor = [UIColor redColor];
    [self addSubview:temp];
    
    NSDictionary * dicc = NSDictionaryOfVariableBindings(temp);
    NSString * strc = @"H:|-16-[temp]-16-|";
    NSArray * arrc = [NSLayoutConstraint constraintsWithVisualFormat:strc options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dicc];
    [self addConstraints:arrc];
    return temp;
}

#pragma -mark label初始化
- (UILabel*)myLabelInitWithTitle:(NSString*)title {
    UILabel *temp = [[UILabel alloc]init];
    temp.text = title;
    temp.textColor = [UIColor whiteColor];
    temp.textAlignment = NSTextAlignmentCenter;
    temp.backgroundColor = [UIColor grayColor];
    temp.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rgbView addSubview:temp];
    return temp;
}

#pragma -mark textfield 初始化
- (UITextField*)myTextFieldinit {
    UITextField *temp = [[UITextField alloc]init];
    temp.translatesAutoresizingMaskIntoConstraints = NO;
    temp.textAlignment = NSTextAlignmentCenter;
    temp.textColor = [UIColor blackColor];
    temp.backgroundColor = [UIColor whiteColor];
    [self.rgbView addSubview:temp];
    return temp;
}

#pragma -mark 指示点初始化
- (UILabel *)addPointerToView:(UIView*)view Type:(int)type{
    if(type ==1)
    {
        UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width - 5, -5, 10, 10)];
        temp.backgroundColor = [UIColor clearColor];
        temp.layer.borderWidth = 2;
        temp.layer.borderColor = [UIColor whiteColor].CGColor;
        temp.layer.masksToBounds = YES;
        temp.layer.cornerRadius = 5;
        [view addSubview:temp];
        return temp;
    }
    if (type ==2) {
        UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(-2, 0, 4,view.frame.size.height)];
        temp.backgroundColor = [UIColor clearColor];
        temp.layer.borderWidth = 1;
        temp.layer.borderColor = [UIColor whiteColor].CGColor;
        temp.layer.masksToBounds = YES;
        [view addSubview:temp];
        return temp;
    }
    return nil;
}

#pragma -mark 渐变背景色设置
- (void)setBackgroundColorWithUIColors:(NSArray*)colors View:(UIView*)view {
    NSMutableArray *colorArray = [NSMutableArray array];
    for(UIColor * color in colors)
    {
        [colorArray addObject:(id)color.CGColor];
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.colors = colorArray;
    
    for (CAGradientLayer * p in view.layer.sublayers) {
        [p removeFromSuperlayer];
    }
    
    [view.layer insertSublayer:gradient atIndex:0];
}

#pragma -mark mainViewa覆盖图
//请勿修改长字符串中的任何字符
- (UIImage*)getMainImg {
    NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:[MainImg stringByReplacingOccurrencesOfString:@"Copyright_Lurich" withString:@"c"] options:0];
    return  [UIImage imageWithData:dataFromString];
}

#pragma -mark 透明度背景图 
//请勿修改长字符串中的任何字符
- (UIImage*)getBGImg {
    NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:[AlphaImg stringByReplacingOccurrencesOfString:@"Copyright_Lurich" withString:@"c"] options:0];
    return  [UIImage imageWithData:dataFromString];
}

#pragma -mark 图片转字符串
- (NSString *)ImgToB64String:(UIImage*)img {
    NSData *data =  UIImagePNGRepresentation(img);
    NSString * base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

#pragma -mark 字符串转图片
- (UIImage*)B64StringToImg:(NSString*)string {
    NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return  [UIImage imageWithData:dataFromString];
}
#pragma -mark 设置Mycolor
- (MyColor)setMyColorWithR:(int)r G:(int)g B:(int)b A:(double)a {
    MyColor color ;
    color.a = a;
    color.r = r;
    color.g = g;
    color.b = b;
    return color;
}

#pragma -mark 将Mycolor 转换成UIcolor
- (UIColor *)transformMyColorToUIColor:(MyColor)color {
    return [UIColor colorWithRed:color.r/255.0 green:color.g/255.0 blue:color.b/255.0 alpha:color.a];
}
@end
