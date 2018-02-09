//
//  CATranViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//

#import "CATranViewController.h"

@interface CATranViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property(nonatomic,strong)NSArray *nameTitle;

@end
/**
 *************常用转场效果**************
 
 fade ,                   //淡入淡出
 push,                       //推挤
 reveal,                     //揭开
 moveIn,                     //覆盖
 cube,                       //立方体
 suckEffect,                 //吮吸
 oglFlip,                    //翻转
 rippleEffect,               //波纹
 pageCurl,                   //翻页
 pageUnCurl,                 //反翻页
 cameraIrisHollowOpen,       //开镜头
 cameraIrisHollowClose,      //关镜头
 curlDown,                   //下翻页
 curlUp,                     //上翻页
 flipFromLeft,               //左翻转
 flipFromRight,              //右翻转

 */


@implementation CATranViewController

static int i = 2;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title =@"过场动画";
    
    [self makeUi];
    
}



#pragma mark ----- Tab
-(void)makeUi{
    
    _nameTitle =@[@"淡入淡出",@"推挤",@"揭开",@"覆盖",@"立方体",@"吮吸",@"翻转",@"波纹",@"翻页",@"反翻页",@"开镜头",@"关镜头",@"下翻页",@"上翻页",@"左翻转",@"右翻转"];
    _tab.dataSource =self;
    _tab.delegate =self;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameTitle.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text =_nameTitle[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:

            [self begin:@"fade"];
            
            break;
        case 1:
            
            [self begin:@"push"];
            
            break;
        case 2:
            
            [self begin:@"reveal"];
            
            break;
        case 3:
            
            [self begin:@"moveIn"];
            
            break;
        case 4:
            
            [self begin:@"cube"];
            
            break;
        case 5:
            
            [self begin:@"suckEffect"];
            
            break;
        case 6:
            
            [self begin:@"oglFlip"];
            
            break;
        case 7:
            
            [self begin:@"rippleEffect"];
            
            break;
        case 8:
            
            [self begin:@"pageCurl"];
            
            break;
        case 9:
            
            [self begin:@"pageUnCurl"];
            
            break;
        case 10:
            
            [self begin:@"cameraIrisHollowOpen"];
            
            break;
        case 11:
            
            [self begin:@"cameraIrisHollowClose"];
            
            break;
        case 12:
            
            [self begin:@"curlDown"];
            break;
        case 13:
            
            [self begin:@"curlUp"];
            
            break;
        case 14:
            
            [self begin:@"flipFromLeft"];
            
            break;
        case 15:
            
            [self begin:@"flipFromRight"];
            
            break;
            
            
        default:
            break;
    }
}
#pragma mark ----- Action
-(void)fade{
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionFade;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    //anima.startProgress = 0.3;//设置动画起点
    //anima.endProgress = 0.8;//设置动画终点
    anima.duration = 1.0f;
    [_imageV.layer addAnimation:anima forKey:@"fadeAnimation"];
}
-(void)begin:(NSString*)str{
    
    if (i == 4) {
        i = 1;
    }
    // 加载图片名称
    NSString *imageN = [NSString stringWithFormat:@"%d",i];
    
    _imageV.image = [UIImage imageNamed:imageN];
    
    i++;
    
    CATransition *anim = [CATransition animation];
   /**
    kCATransitionFromLeft
    kCATransitionFromTop
    kCATransitionFromBottom
    kCATransitionFromRight
    */
    
    anim.subtype = kCATransitionFromRight; //设置动画的方向
    
    anim.type = str;
    
    anim.duration = 2;
    
    NSString *animation=@"Animation";
  
    str =[str stringByAppendingString:animation];

    [_imageV.layer addAnimation:anim forKey:str];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
