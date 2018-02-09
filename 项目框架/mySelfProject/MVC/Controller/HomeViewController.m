//
//  HomeViewController.m
//  mySelfProject
//
//  Created by 小富 on 16/3/14.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "HomeViewController.h"
#import "SFLoopView.h"
#import "InformationController.h"

@interface HomeViewController ()<SFLoopViewDelegate>
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
        
        [self.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_more_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    NSLog(@"%@",city);
    UIButton *button = [Factory createButtonWithFrame:CGRectMake(0, 0, 30, 15) title:[city substringToIndex:2] target:self Selector:@selector(leftClick)];
    [self addItemWithCustomView:@[button] isLeft:YES];
    
    NSArray *images = @[@"http://pic36.nipic.com/20131217/6704106_233034463381_2.jpg",@"http://pic.to8to.com/attch/day_160218/20160218_d968438a2434b62ba59dH7q5KEzTS6OH.png",@"http://pic.to8to.com/attch/day_160218/20160218_d968438a2434b62ba59dH7q5KEzTS6OH.png"];
    SFLoopView *loopView = [[SFLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2.5) images:images autoPlay:YES delay:3.0];
    loopView.delegate = self;
    [self.view addSubview:loopView];
}
- (void)loopViewDidSelectedImage:(SFLoopView *)loopView index:(int)index{
    NSLog(@"点击了：%d",index);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [BlueToothViewTipView showWithTitle:@"请连接设备"];
//    InformationController *pvc=[[InformationController alloc]init];
//    [pvc returnLastViewController:^{
//        
//    }];
//    pvc.pageAnimatable = YES;
//    pvc.menuItemWidth = 80;
//    pvc.menuViewStyle = WMMenuViewStyleLine;
//    pvc.postNotification = YES;
//    pvc.titleColorNormal = [UIColor blackColor];
//    pvc.titleColorSelected =RedColor;
//    pvc.menuBGColor =  [UIColor whiteColor];
//    pvc.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:pvc animated:YES];
}
- (void)leftClick{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
