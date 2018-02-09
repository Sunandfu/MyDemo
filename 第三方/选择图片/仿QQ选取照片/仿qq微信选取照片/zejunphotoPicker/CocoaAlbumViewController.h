//
//  CocoaAlbumViewController.h
//  baixiaosheng
//
//  Created by 薛泽军 on 15/11/25.
//  Copyright © 2015年 薛泽军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CocoaAlbumViewController : UIViewController
@property (strong,nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *sendBackArray;
@property(nonatomic,strong)NSMutableArray *albumArray;
@property(nonatomic,strong)NSArray *newimageArray;
@property (strong,nonatomic)void (^selectBlock)(BOOL isyes);

@end
