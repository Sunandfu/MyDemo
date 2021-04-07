//
//  LNReaderSettingView.m
//  LookNovel
//
//  Created by wangchengshan on 2019/5/21.
//  Copyright © 2019 wcs Co.,ltd. All rights reserved.
//

#import "LNReaderSettingView.h"
#import "UIView+MJExtension.h"
#import "SFTool.h"
#import "SFConstant.h"

@interface LNReaderSettingView ()

@property (weak, nonatomic) IBOutlet UISlider *brightSlider;
@property (weak, nonatomic) IBOutlet UIButton *fontMinButton;
@property (weak, nonatomic) IBOutlet UIButton *fontPlusButton;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UISwitch *lockSwitch;

@property (weak, nonatomic) IBOutlet UILabel *lineHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *paragraphHeightLabel;

@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, weak) UIButton *lastButton;

@end

@implementation LNReaderSettingView

- (NSMutableArray *)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backScrollView.contentInset = UIEdgeInsetsZero;
    
    self.fontMinButton.layer.cornerRadius = self.fontPlusButton.layer.cornerRadius = 6;
}

- (void)setSkin:(ReadSetModel *)skin
{
    self.backgroundColor = [SFTool colorWithHexString:skin.controlViewBgColor];
    self.fontMinButton.backgroundColor = [SFTool colorWithHexString:skin.settingBtnColor];
    self.fontPlusButton.backgroundColor = [SFTool colorWithHexString:skin.settingBtnColor];
    for (UIView *subView in self.subviews.firstObject.subviews) {
        if ([subView isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)subView;
            label.textColor = [SFTool colorWithHexString:skin.settingTextColor];
        }
    }
    [self.brightSlider setThumbImage:[UIImage imageNamed:skin.sliderThumb] forState:UIControlStateNormal];
    self.fontSizeLabel.textColor = [SFTool colorWithHexString:skin.settingTextColor];
    
}

- (void)setSkinList:(NSArray<ReadSetModel *> *)skinList
{
    _skinList = skinList;
    
    for (int i = 0; i < skinList.count; i ++) {
        ReadSetModel *skin = [skinList objectAtIndex:i];
        UIButton *button = [self buttonWithImage:skin.normalIcon selectImage:skin.selectIcon];
        button.tag = i;
        button.selected = ([skin.themeId isEqualToString:self.currentModel.themeId]);
        if (button.selected) {
            self.lastButton = button;
        }
        [self.backScrollView addSubview:button];
        [self.viewArray addObject:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int idx = 0;
    for (int i = 0; i < self.viewArray.count; i ++) {
        UIButton *button = [self.viewArray objectAtIndex:i];
        if (button.selected) {
            idx = i;
        }
        button.frame = CGRectMake(i * (30 + 20), 0, 30, 30);
    }
    UIButton *last = self.viewArray.lastObject;
    self.backScrollView.contentSize = CGSizeMake(last.mj_x+last.mj_w, 0);
    UIButton *select = self.viewArray[idx];
    [self.backScrollView scrollRectToVisible:select.frame animated:YES];
}

- (UIButton *)buttonWithImage:(NSString *)image selectImage:(NSString *)selImage
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickSkin:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)clickSkin:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(settingViewDidClickSkinAtIndex:)]) {
        [self.delegate settingViewDidClickSkinAtIndex:button.tag];
    }
    self.lastButton.selected = NO;
    button.selected = YES;
    self.lastButton = button;
}

- (IBAction)toggleSlider:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeBright:)]) {
        [self.delegate settingViewDidChangeBright:sender.value];
    }
}

- (void)setFontSize:(float)fontSize
{
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%.0f",fontSize];
}

- (float)currentFont
{
    return [self.fontSizeLabel.text floatValue];
}

- (void)cancelAllSelect
{
    self.lastButton.selected = NO;
}

- (void)setSelectAtIndex:(NSInteger)index
{
    UIButton *button = [self.viewArray objectAtIndex:index];
    self.lastButton.selected = NO;
    button.selected = YES;
    self.lastButton = button;
}

- (IBAction)clickMinFontButton {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeFontSize:)]) {
        [self.delegate settingViewDidChangeFontSize:[self currentFont] - 1];
    }
}

- (IBAction)clickPlusFontButton {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeFontSize:)]) {
        [self.delegate settingViewDidChangeFontSize:[self currentFont] + 1];
    }
}

- (IBAction)clickSwitch:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeSwitch:)]) {
        [self.delegate settingViewDidChangeSwitch:sender.on];
    }
}

- (void)setLineHeight:(float)lineHeight{
    self.lineHeightLabel.text = [NSString stringWithFormat:@"%.1f",lineHeight];
}
- (float)currentLineHeight
{
    CGFloat lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookLineHeight];
    return lineHeight;
}
- (void)setParagraphHeight:(float)paragraphHeight{
    self.paragraphHeightLabel.text = [NSString stringWithFormat:@"%.1f",paragraphHeight];
}
- (float)currentParagraphHeight
{
    CGFloat paragraphHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookParagraphHeight];
    return paragraphHeight;
}
- (IBAction)LineHeightMinButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeLineHeight:)]) {
        [self.delegate settingViewDidChangeLineHeight:[self currentLineHeight] - 0.5];
    }
}
- (IBAction)LineHeightPlusButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeLineHeight:)]) {
        [self.delegate settingViewDidChangeLineHeight:[self currentLineHeight] + 0.5];
    }
}
- (IBAction)ParagraphHeightMinButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeParagraphHeight:)]) {
        [self.delegate settingViewDidChangeParagraphHeight:[self currentParagraphHeight] - 1];
    }
}
- (IBAction)ParagraphHeightPlusButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(settingViewDidChangeParagraphHeight:)]) {
        [self.delegate settingViewDidChangeParagraphHeight:[self currentParagraphHeight] + 1];
    }
}

- (void)setBright:(float)bright
{
    [self.brightSlider setValue:bright animated:YES];
}

- (void)setNotLock:(BOOL)lock
{
    self.lockSwitch.on = lock;
}
@end
