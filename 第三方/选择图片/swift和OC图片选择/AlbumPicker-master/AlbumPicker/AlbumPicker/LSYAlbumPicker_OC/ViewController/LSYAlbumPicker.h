//
//  LSYAlbumPicker.h
//  AlbumPicker
//
//  Created by okwei on 15/7/23.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYAlbumPickerDelegate<NSObject>
-(void)AlbumPickerDidFinishPick:(NSArray *)assets;
@end
@interface LSYAlbumPicker : UIViewController
@property (nonatomic,strong) ALAssetsGroup *group;
@property (nonatomic) NSInteger maxminumNumber;
@property (nonatomic,weak) id<LSYAlbumPickerDelegate>delegate;
-(void)sendButtonClick;
@end
