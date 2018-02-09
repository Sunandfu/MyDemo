//
//  ViewController.h
//  BluetoothPrint
//
//  Created by Tgs on 16/3/8.
//  Copyright © 2016年 Tgs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property(nonatomic,strong)NSDictionary *jsonDic;
@property(nonatomic,strong)NSString *infoStr;
@property(nonatomic,strong)NSTimer *reloadTimer;
@property(nonatomic,assign)NSInteger printNum;

@end

