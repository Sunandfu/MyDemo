//
//  CocoaCollectionViewCell.m
//  CocoaPicker
//
//  Created by 薛泽军 on 15/11/25.
//  Copyright © 2015年 Cocoa Lee. All rights reserved.
//

#import "CocoaCollectionViewCell.h"
#import "CocoaGroup.h"
@implementation CocoaCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.selectButton setBackgroundImage:[[UIImage imageNamed:@"BRNImagePickerSheet-checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[[UIImage imageNamed:@"BRNImagePickerSheet-checkmark-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    self.selectButton.layer.cornerRadius =CGRectGetHeight(self.selectButton.frame) / 2.0;
}
- (void)setCellDict:(NSDictionary *)cellDict
{
    self.headImageView.image=cellDict[@"image"];
    NSLog(@"ddd~~%@",cellDict);
    self.typeIamgeView.hidden=NO;
    self.durationLable.hidden=NO;
    if ([cellDict[@"type"] isEqualToString:@"ALAssetTypePhoto"]) {
        self.typeIamgeView.hidden=YES;
        self.durationLable.hidden=YES;
    }else
    {
        self.durationLable.text =[self getTimeWith:[cellDict[@"duration"] intValue]];
    }
}
- (NSString *)getTimeWith:(NSInteger)secCount;
{
    
    NSString *tmphh = [NSString stringWithFormat:@"%.2ld",secCount/3600];
    NSString *tmpmm = [NSString stringWithFormat:@"%.2ld",(secCount/60)%60];
    NSString *tmpss = [NSString stringWithFormat:@"%.2ld",secCount%60];
    if (secCount/3600>0) {
        return  [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    }else if ((secCount/60)%60>0) {
        return  [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
    }else if (secCount%60>0) {
        return  [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
    }
    return  [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
}
- (void)setSelected:(BOOL)selected
{
    self.selectButton.selected=selected;
    self.selectButton.backgroundColor=selected?COLORSELECT:[self getColor:@"efefef"];
}
- (UIColor *)getColor:(NSString*)hexColor

{
    
    unsigned int red,green,blue;
    
    NSRange range;
    
    range.length = 2;
    
    
    
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    
    
    range.location = 2;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    
    
    range.location = 4;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    
}

@end
