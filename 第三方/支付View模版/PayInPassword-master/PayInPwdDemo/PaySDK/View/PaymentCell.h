//
//  PaymentCell.h
//  PayInPwdDemo
//
//  Created by IOS-Sun on 16/2/24.
//  Copyright © 2016年 IOS-Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell

@property (nonatomic, assign)CGFloat cellWidth;

+ (instancetype)paymentCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com