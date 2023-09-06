//
//  DragAndDropManger.h
//  CardScrlDemo
//
//  Created by lotus on 2019/12/28.
//  Copyright © 2019 lotus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DragAndDropManger : NSObject<UIDragInteractionDelegate, UIDropInteractionDelegate>

@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIView *dropView;
@end

NS_ASSUME_NONNULL_END
