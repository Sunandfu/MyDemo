//
//  SFOneClickImportBookSourceView.h
//  ReadBook
//
//  Created by lurich on 2020/11/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^importBtnBlock)(NSString *jsonStr);

@interface SFOneClickImportBookSourceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *showTipLabel;
@property (weak, nonatomic) IBOutlet UITextView *showContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
@property (nonatomic, copy) importBtnBlock block;

- (void)importBtnClickBlock:(importBtnBlock)block;

@end

NS_ASSUME_NONNULL_END
