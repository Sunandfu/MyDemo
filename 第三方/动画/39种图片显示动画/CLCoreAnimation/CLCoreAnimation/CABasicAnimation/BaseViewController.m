//
//  BaseViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//

// 基础动画
#import "BaseViewController.h"

@interface BaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property(nonatomic,strong)NSArray *nameTitle;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title =@"基础动画";
    
    [self makeUi];
    
}
-(void)makeUi{
    _nameTitle =@[@"位移",@"缩放",@"旋转",@"闪烁动画",@"圆角"];
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
            [self movePosition];
            break;
            
        case 1:
            [self scaleView];
            break;
            
        case 2:
            [self revolveView];
            break;
            
        case 3:
            [self alphaView];
            break;
            
        case 4:
            [self setbackCornerRadius];
            break;
            
        default:
            break;
    }
}

/**
 偏移
 */
-(void)movePosition{
    
    CABasicAnimation *anim =[CABasicAnimation animation];
    anim.keyPath =@"position";
    anim.fromValue =[NSValue valueWithCGPoint:CGPointMake(0, 200)];
    anim.toValue =[NSValue valueWithCGPoint: CGPointMake(WIDTH*1.5, 200)];
    anim.duration =0.2;//持续时间
    anim.repeatCount =1;//  重复的次数
    anim.speed =0.2;// 速度
    
    /**
    removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为
     
     Autoreverses 当设置为yes 时候在他达到目的地时候，取代原来的值
     
     timingFunction   各种状态的设置
     
     fillMode  决定当前对象在非active时间段的行为，比如动画开始之前，动画结束之后
     kCAFillModeRemoved   默认值，动画开始和结束后，对layer没有影响，动画结束后恢复之前
     kCAFillModeForwards  动画结束后，保持最后的状态
     kCAFillModeBackwards 动画添加到layer之上，便处于动画初始状态
     kCAFillModeBoth      动画添加到layer之上，便处于动画初始状态，完成之后保持最后的状态
     */
    anim.fillMode  =kCAFillModeForwards ;
    
    [_imageV.layer addAnimation:anim forKey:@"position"];
    
}
/**
 缩放
 */
-(void)scaleView{
    CABasicAnimation *anim =[CABasicAnimation animationWithKeyPath:@"transform.scale"];
   // anim.fillMode =kCAFillModeForwards ;
    anim.toValue = @0.2;
    anim.repeatCount =1;
    anim.removedOnCompletion = NO;//设置动画完成时候不移除
    [_imageV.layer addAnimation:anim forKey:@"transform.scale"];
}

/**
 旋转
 */
-(void)revolveView{
    
    /**
     
     transform.scale = 比例转换
     
     transform.scale.x = 宽的比例转化
     
     transform.scale.y = 高的比例转化
     
     transform.rotation.z = z轴的转化
     */
    CABasicAnimation *anim =[CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration =2.0;
    //  M_PI  180
    anim.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2+M_PI_4, 1, 1, 0)];
    anim.fillMode =kCAFillModeRemoved ;
    anim.repeatCount =1;
    [_imageV.layer addAnimation:anim forKey:@"transform"];
}

/**
  闪烁动画
 */
-(void)alphaView{
    CABasicAnimation *anim =[CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue =[NSNumber numberWithFloat:1.0f];
    anim.toValue   =[NSNumber numberWithFloat: 0.4f];
    
    anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
     anim.autoreverses=YES;
    [_imageV.layer addAnimation:anim forKey:@"opacityTimes"];
    
    
    
}
/**
 backgroundColor
 */
-(void)setbackCornerRadius
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    anim.duration = 1.f;
    anim.fromValue = [NSNumber numberWithFloat:0.f];
    anim.toValue = [NSNumber numberWithFloat:30.f];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    [_imageV.layer addAnimation:anim forKey:@"cornerRadius"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
