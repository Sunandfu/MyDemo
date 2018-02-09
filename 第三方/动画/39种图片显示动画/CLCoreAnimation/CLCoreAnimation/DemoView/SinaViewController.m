//
//  SinaViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/21.
//  Copyright © 2016年 More. All rights reserved.
//



#import "SinaViewController.h"

#import "CLButton.h"

@interface SinaViewController ()

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *imageArr;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,strong)NSMutableArray *btns;
@property (nonatomic,strong)CLButton *btn;



@end

@implementation SinaViewController

static int x =0;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title =@"新浪";
    
    [self makeArr];
    
    self.btns =[[NSMutableArray alloc]init];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(WIDTH/2, 64, 100, 40);
    [btn setTitle:@"开始动画" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)change{
    NSLog(@"开始动画");
    
    if (x==_titleArr.count) {
         [_timer invalidate];
    }
    if (_btns.count>0) {
        
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        
    }else{
        
    [self makeButton];
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.btns removeAllObjects];
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[CLButton class]]) {
           
            [subView removeFromSuperview];
        }
    }
}
-(void)timeChange{

    if (x==_titleArr.count) {
        
        x = -1;
        
        [_timer invalidate];
        
    }else{
        
    UIButton *btn = self.btns[x];
        
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        btn.transform = CGAffineTransformIdentity;
        
        [self.view addSubview:btn];
        
    } completion:nil];
    }
    
    x++;
}
-(void)makeArr{
    
    _titleArr = @[@"点评",@"更多",@"拍摄",@"相册",@"文字",@"签到"];
    _imageArr =@[@"tabbar_compose_review",@"tabbar_compose_more",@"tabbar_compose_camera",@"tabbar_compose_photo",@"tabbar_compose_idea",@"tabbar_compose_review"];
    
    
}
/**
 Button
 */
-(void)makeButton
{
    CGFloat btnWH = 100;
    NSInteger col = 0;
    NSInteger row = 0;
    NSInteger cols = 3;
   
    CGFloat margin =(WIDTH - cols*btnWH)/(cols+1);
    
    for (NSInteger i =0; i<_titleArr.count; i++) {
        
        col =i%cols;
        
        row =i/cols;
        _btn =[[CLButton alloc]init];
        _btn =[CLButton buttonWithType: UIButtonTypeCustom];
        
        [_btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        
        _btn.frame =CGRectMake((btnWH+margin)*col+margin, row*(margin+btnWH)+200, btnWH, btnWH);
        
        _btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
    
     
        [self.btns addObject:_btn];
        
        NSLog(@"%ld",self.btns.count);
        
        if (self.btns.count==6) {
            
            [self change];
            
        }
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
