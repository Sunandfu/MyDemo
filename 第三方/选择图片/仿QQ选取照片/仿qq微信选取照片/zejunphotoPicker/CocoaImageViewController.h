//
//  CocoaImageViewController.h
//  CocoaPicker
//
//  Created by 薛泽军 on 15/11/25.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaGroup.h"
@interface CocoaImageViewController : UIViewController
@property (strong,nonatomic)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *sendBackArray;
@property(nonatomic,strong)NSArray *newimageArray;
@property (strong,nonatomic)void (^selectBlock)(BOOL isyes);
@end

