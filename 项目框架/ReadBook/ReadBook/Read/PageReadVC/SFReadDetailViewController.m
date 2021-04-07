//
//  SFReadDetailViewController.m
//  ReadBook
//
//  Created by lurich on 2020/6/1.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFReadDetailViewController.h"
#import <CoreText/CoreText.h>
#import "SFTextView.h"
#import "ReadSetModel.h"
#import "SFSafeAreaInsets.h"
#import "BaiduMobStatForSDK.h"

@interface SFReadDetailViewController ()

@property (nonatomic, strong) SFTextView *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UILabel *timeLabel;
/**夜间数据源*/
@property (nonatomic, strong) ReadSetModel *nightSetModel;
/**日间数据源*/
@property (nonatomic, strong) ReadSetModel *daySetModel;
//@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation SFReadDetailViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BaiduMobStatForSDK defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",self.bookTitleName] withAppId:@"718527995f"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[BaiduMobStatForSDK defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",self.bookTitleName] withAppId:@"718527995f"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateFrameWithSize:size];
}
#pragma mark - setter
- (void)setBookModel:(BookDetailModel *)bookModel {
    _bookModel = bookModel;
    self.titleLabel.text = bookModel.title;
}
- (void)setPage:(NSUInteger)page {
    _page = page;
    self.contentLabel.attributedText = [self getStringWithpage:page andChapter:_bookModel];
    self.timeLabel.text = [SFTool getNowTimeWithDataFormat:@"HH:mm"];
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%zd", (long)page+1, _bookModel.pageCount];
    BOOL bookHiddleTitle = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookHiddleTitle];
    self.titleLabel.hidden = self.bottomView.hidden = bookHiddleTitle;
    
    NSNumber *nightNum = self.viewSetDict[@"isNignt"];
    self.nightSetModel = self.viewSetDict[@"nightSetModel"];
    self.daySetModel = self.viewSetDict[@"daySetModel"];
    //用图片做背景颜色
    self.view.layer.contents = (__bridge id _Nullable)(nightNum.intValue?[SFTool imageWithColor:[SFTool colorWithHexString:self.nightSetModel.color]].CGImage:(self.daySetModel.bgImage.length>0?([UIImage imageNamed:self.daySetModel.bgImage]).CGImage:[SFTool imageWithColor:[SFTool colorWithHexString:self.daySetModel.color]].CGImage));
    self.contentLabel.textColor = nightNum.intValue?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
    self.timeLabel.textColor = nightNum.intValue?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
    self.pageLabel.textColor = nightNum.intValue?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
    self.titleLabel.textColor = nightNum.intValue?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
    
    [self updateFrameWithSize:self.view.bounds.size];
}
- (void)updateFrameWithSize:(CGSize)size{
    if (size.width > size.height) {
        self.titleLabel.frame = CGRectMake(20, 0, size.width-40, 20);
        self.contentLabel.frame = CGRectMake(kReadSpaceX, kReadingTopH, size.width - kReadSpaceX*2, size.height - kReadingTopH - kReadingBottomH);
        self.bottomView.frame = CGRectMake(0, size.height-20, size.width, 20);
        self.timeLabel.frame = CGRectMake(20, 0, size.width/2.0-20, CGRectGetHeight(self.bottomView.frame));
        self.pageLabel.frame = CGRectMake(size.width/2.0, 0, size.width/2.0-20, CGRectGetHeight(self.bottomView.frame));
    } else {
        self.titleLabel.frame = CGRectMake(20, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, size.width-40, 20);
        self.contentLabel.frame = [SFSafeAreaInsets shareInstance].getRect;
        self.bottomView.frame = CGRectMake(0, size.height-[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom-20, size.width, 20);
        self.timeLabel.frame = CGRectMake(20, 0, size.width/2.0-20, CGRectGetHeight(self.bottomView.frame));
        self.pageLabel.frame = CGRectMake(size.width/2.0, 0, size.width/2.0-20, CGRectGetHeight(self.bottomView.frame));
    }
}

//获取某章节某一页的内容
- (NSAttributedString *)getStringWithpage:(NSInteger)page andChapter:(BookDetailModel *)model {
    if (page < model.pageContentArray.count) {
        return model.pageContentArray[page];
    }
    return [[NSAttributedString alloc] init];
}


#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, self.view.bounds.size.width-40, 20)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITextView *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[SFTextView alloc] initWithFrame:[SFSafeAreaInsets shareInstance].getRect];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentLabel.scrollEnabled = NO;
        _contentLabel.textContainerInset = UIEdgeInsetsZero;
        [self.view addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom-20, self.view.bounds.size.width, 20)];
        _bottomView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width/2.0-20, CGRectGetHeight(self.bottomView.frame))];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        [self.bottomView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0, 0, self.view.bounds.size.width/2.0-20, CGRectGetHeight(self.bottomView.frame))];
        _pageLabel.textColor = [UIColor blackColor];
        _pageLabel.textAlignment = NSTextAlignmentRight;
        _pageLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        [self.bottomView addSubview:_pageLabel];
    }
    return _pageLabel;
}

@end
