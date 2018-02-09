//
//  CZBottomMenu.m
//  D12.MenuTest
//
//  Created by Vincent_Guo on 14-10-10.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "CZBottomMenu.h"

#define delta 80.0
#define ADuration 5.7

@interface CZBottomMenu ()
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;

@property(nonatomic,strong)NSMutableArray *menuItems;
@end
@implementation CZBottomMenu

+(instancetype)bottomMenu{
    return [[[NSBundle mainBundle] loadNibNamed:@"CZBottomMenu" owner:nil options:nil] lastObject];
}

-(NSMutableArray *)menuItems{
    if (!_menuItems) {
        _menuItems = [NSMutableArray array];
    }
    
    return _menuItems;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
         [self initItems];
     }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initItems];
        
    }
    return self;
}

-(void)initItems{
    // 添加3个按钮
    [self addItemWithImageName:@"menu_btn_call" tag:0];
    [self addItemWithImageName:@"menu_btn_cheyou" tag:1];
    [self addItemWithImageName:@"menu_btn_tixing" tag:2];

}
-(void)addItemWithImageName:(NSString *)imageName tag:(int)tag{
    UIButton *menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuItem setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    menuItem.bounds = CGRectMake(0, 0, 39, 39);
    menuItem.tag = tag;
    [menuItem addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuItem];
    [self.menuItems addObject:menuItem];

}

-(void)awakeFromNib{

    for (UIButton *item in self.menuItems){
        item.center = self.mainBtn.center;
    }
    
    [self bringSubviewToFront:self.mainBtn];
}


-(void)itemsClick:(UIButton *)btn{
    
    NSLog(@"%s %ld",__func__,btn.tag);
}

-(IBAction)mainBtnClick:(UIButton *)btn{
    
    BOOL open = CGAffineTransformIsIdentity(btn.transform);
    
    [UIView animateWithDuration:ADuration animations:^{
        if (open) {
            btn.transform = CGAffineTransformMakeRotation(M_PI_4);
        }else{
            btn.transform = CGAffineTransformIdentity;
        }
        
    }];
        
    [self openItems:open];
}

-(void)openItems:(BOOL)open{
    CGPoint mainBtnCenter = self.mainBtn.center;
    for (UIButton *item in self.menuItems) {
        
        CGPoint itemCenter = item.center;
        // 计算需要移动的x方向的距离
        CGFloat transX = (item.tag + 1) * delta;
        
        // 重新设置center的X值
        itemCenter.x += transX;
        
        CAKeyframeAnimation *posAni = [CAKeyframeAnimation animation];
        posAni.keyPath = @"position";
        // 原点
        NSValue *value1 = [NSValue valueWithCGPoint:mainBtnCenter];
        
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(mainBtnCenter.x + transX * 0.4,mainBtnCenter.y)];
        
        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(mainBtnCenter.x + transX * 1.05,mainBtnCenter.y)];
        
        NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(mainBtnCenter.x + transX * 1,mainBtnCenter.y)];
        if (open) {
            posAni.values = @[value1,value2,value3,value4];
        }else{
            posAni.values = @[value4,value3,value2,value1];
        }
        
        
        
        CAKeyframeAnimation *rotAni = [CAKeyframeAnimation animation];
        rotAni.keyPath = @"transform.rotation.z";
        if (open) {
           rotAni.values = @[@(0),@(M_PI * 2),@(M_PI * 4),@(M_PI * 2 )];
        }else{
           rotAni.values = @[@(0),@(M_PI * 2),@(0),@(-M_PI * 2)];
        }
        
        
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[posAni,rotAni];
        group.duration = ADuration;
//        group.repeatCount = 1;//执行的次数
//        group.repeatDuration = 1.5;//执行的时间
//        group.beginTime = 2.0;//延迟加载动画
        /*
         1> kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
         
         2> kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
         
         3> kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
         
         4> kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。        这个是默认的动画行为。
         */
//        group.timingFunction = kCAMediaTimingFunctionEaseOut;
//        group.removedOnCompletion = NO;
//        group.fillMode = kCAFillModeForwards;
        [item.layer addAnimation:group forKey:nil];
        
        
        // 更新center的X值
        if (open) {
            item.center = itemCenter;
        }else{
            item.center = mainBtnCenter;
        }
        
        
    }
}

@end
