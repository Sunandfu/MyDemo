//
//  CityHeaderView.m
//  InstantMessage
//
//  Created by 林英伟 on 15/12/16.
//  Copyright © 2015年 林英伟. All rights reserved.
//

#import "CityHeaderView.h"
#import "UIView+SDAutoLayout.h"
#define ScreenH [[UIScreen mainScreen] bounds].size.height
#define ScreenW [[UIScreen mainScreen] bounds].size.width
@interface CityHeaderView ()
@property (nonatomic,strong) UILabel *location;
@property (nonatomic,assign) CGFloat headerViewHeight;
@end
@implementation CityHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    [self initUI];
    frame = CGRectMake(frame.origin.x, frame.origin.y, self.width, self.headerViewHeight);
    self.frame = frame;
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    UIView *citySection = [[UIView alloc]init];
    citySection.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self addSubview:citySection];
    
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"所在城市";
    cityLabel.font = [UIFont systemFontOfSize:16];
    cityLabel.textColor = [UIColor grayColor];
    [citySection addSubview:cityLabel];
    
    UILabel *location = [[UILabel alloc]init];
    location.text = @"上海市";
    location.textColor = [UIColor redColor];
    location.textAlignment = NSTextAlignmentLeft;
    self.location = location;
    [self addSubview:location];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"ico-refresh"];
    [self addSubview:imageView];
    
    UIView *hotCSection = [[UIView alloc]init];
    hotCSection.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self addSubview:hotCSection];
    
    UILabel *hcityLabel = [[UILabel alloc]init];
    hcityLabel.text = @"热门城市";
    hcityLabel.font = [UIFont systemFontOfSize:16];
    hcityLabel.textColor = [UIColor grayColor];
    [hotCSection addSubview:hcityLabel];
    
    UIView *citiesBtnView = [[UIView alloc]init];
    [self addSubview:citiesBtnView];
   
    citySection.sd_layout
    .topSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(30);
    
    cityLabel.sd_layout
    .topSpaceToView(citySection,5)
    .leftSpaceToView(citySection,20)
    .widthIs(100)
    .heightIs(21);
    
    self.location.sd_layout
    .topSpaceToView(citySection,15)
    .leftSpaceToView(self,20)
    .widthIs(100)
    .heightIs(21);
    
    imageView.sd_layout
    .topEqualToView(self.location)
    .rightSpaceToView(self,20)
    .widthIs(15)
    .heightIs(15);
    
    hotCSection.sd_layout
    .topSpaceToView(self.location,15)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(30);
    
    hcityLabel.sd_layout
    .topSpaceToView(hotCSection,5)
    .leftSpaceToView(hotCSection,20)
    .widthIs(100)
    .heightIs(21);
    
    
    NSArray *textArr = @[@"北京市",@"上海市",@"广州市",@"深圳市"];
    for (int i = 0; i < textArr.count; i++) {
        UIButton * headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(i%4*(ScreenW - 40)*0.265, i/4*50+10, ScreenW*0.17, 30)];
        headerBtn.tag = i;
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [headerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [headerBtn setTitle:[NSString stringWithFormat:@"%@",textArr[i]] forState:UIControlStateNormal];
        headerBtn.layer.masksToBounds = YES;
        headerBtn.layer.cornerRadius = 15.0f;
        headerBtn.layer.borderColor = [UIColor grayColor].CGColor;
        headerBtn.layer.borderWidth = 0.5f;
        headerBtn.clipsToBounds = NO;
        [citiesBtnView addSubview:headerBtn];
    }
    CGFloat CHeight = ((int)textArr.count/4+1)*50;
    if ((int)textArr.count%4==0) {
        CHeight = ((int)textArr.count/4)*50;
    }
    citiesBtnView.sd_layout
    .topSpaceToView(hotCSection,10)
    .leftSpaceToView(self,20)
    .rightSpaceToView(self,20)
    .heightIs(CHeight);
    
    self.headerViewHeight = 130 + citiesBtnView.bounds.size.height;
}

- (void)setCityName:(NSString *)cityName
{
    self.location.text = cityName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
