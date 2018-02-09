//
//  ViewController.m
//  SHMenu
//
//  Created by 宋浩文的pro on 16/4/15.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "ViewController.h"
#import "MenuContentViewController.h"
#import "SHMenu.h"

@interface ViewController ()

@property (nonatomic, strong) SHMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)popMenu:(id)sender {
    
    if (_menu.state == MenuShow) return;
    
    MenuContentViewController *menuVC = [[MenuContentViewController alloc] init];
    SHMenu *menu = [[SHMenu alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
    _menu = menu;
    menu.contentVC = menuVC;
    menu.anchorPoint = CGPointMake(1, 0);//视图要出现的起始点(范围最好（0～1）)
    menu.contentOrigin = CGPointMake(0, 8);//视图内容的偏移位置
    [menu showFromPoint:CGPointMake(100, 100)];//视图显示的位置点
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_menu hideMenu];
}



@end
