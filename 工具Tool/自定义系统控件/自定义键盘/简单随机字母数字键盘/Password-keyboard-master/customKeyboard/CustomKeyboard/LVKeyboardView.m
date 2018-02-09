
#import "LVKeyboardView.h"
#import "NSString+DYRandomLetter.h"
#define LVKeyboardCols 3
#define LVKeyboardTextFont 20

@interface LVKeyboardView ()

/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;

/** 切换大小写按钮 */
@property (nonatomic, weak) UIButton *shiftButton;

//c_symbol_keyboardSwitchButton

/** 切换数字 英文 */
@property (nonatomic, weak) UIButton *changeButton;

/** 符号按钮 */
@property (nonatomic, weak) UIButton *symbolBtn;

/** ABC 文字按钮 */
@property (nonatomic, weak) UIButton *textBtn;

/** 空格按钮 */
@property (nonatomic, weak) UIButton *blankBtn;

/** return按钮 */
@property (nonatomic, weak) UIButton *returnBtn;
/** 切换按钮状态*/
@property (nonatomic, assign, getter = isChange) BOOL shiftChange;



@end


@implementation LVKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shiftChange = YES;
        [self imagepp];
   
//        char str = @"][.,?)(|}{*&^%$#@￥!~:+_-\=;@/`";
    
    }
    return self;
}
- (void)imagepp{

    [self setupTopButtonsWithImage:[self nomImage:YES] highImage:[self nomImage:NO] isLowercase:YES];
    [self setupBottomButtonsWithImage:[self nomImage:NO] highImage:[self nomImage:YES]];
   [self layoutSubviewst];

}

- (UIImage *)nomImage:(BOOL)isNom {
    
    if (isNom) {

        // 普通图片
        UIImage *image     = [UIImage imageNamed:@"c_chaKeyboardButton"];
        image              = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];

        return image;
    }else{
            // 高亮图片
        UIImage *highImage = [UIImage imageNamed:@"c_chaKeyboardButtonSel"];
        highImage          = [highImage stretchableImageWithLeftCapWidth:highImage.size.width * 0.5 topCapHeight:highImage.size.height * 0.5];
        return highImage;

    }
}


#pragma mark - 数字按钮
- (void)setupTopNumButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    
    // 删除重新布局
    for(id temp in self.subviews)
    {
        if([temp respondsToSelector:@selector(setTitle:forState:)])
        {//判断这个里面的子视图是否是按钮
            [temp removeFromSuperview];
        }
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM removeAllObjects];
    for (int i = 0 ; i < 10; i++) {
        int j = arc4random_uniform(10);
        
        NSNumber *number = [[NSNumber alloc] initWithInt:j];
        if ([arrM containsObject:number]) {
            i--;
            continue;
        }
        [arrM addObject:number];
    }
    
    for (int i = 0; i < 10; i++) {
        
        UIButton *numBtn = [[UIButton alloc] init];
        NSNumber *number = arrM[i];
        NSString *title = number.stringValue;
        [numBtn setTitle:title forState:UIControlStateNormal];
        
        [numBtn setBackgroundImage:image forState:UIControlStateNormal];
        [numBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = [UIFont boldSystemFontOfSize:LVKeyboardTextFont];
        [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:numBtn];
    }

}

#pragma mark - 字母按钮
- (void)setupTopButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage isLowercase:(BOOL)change  {
   
    
    // 删除重新布局
    for(id temp in self.subviews)
    {
        if([temp respondsToSelector:@selector(setTitle:forState:)])
        {//判断这个里面的子视图是否是按钮
            [temp removeFromSuperview];
        }
    }

    NSMutableArray *arrM = [NSMutableArray array];
    [arrM removeAllObjects];
    for (int i = 0 ; i < 26; i++) {
        
        NSString *str =[NSString DYRandomLetterLowercase:change];
        if ([arrM containsObject:str]) {
            i--;
            continue;
        }
        [arrM addObject:str];
    }
    
    for (int i = 0; i < 26; i++) {
       
        UIButton *numBtn = [[UIButton alloc] init];
        NSString *number = arrM[i];
        NSString *title = number;
        [numBtn setTitle:title forState:UIControlStateNormal];
        
        [numBtn setBackgroundImage:image forState:UIControlStateNormal];
        [numBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = [UIFont boldSystemFontOfSize:LVKeyboardTextFont];
        [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:numBtn];
    }

    self.shiftChange = !change;
}
#pragma mark - 删除按钮可以点
- (void)setupBottomButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    
    // 切换英文/数字按钮
    self.changeButton = [self setupBottomButtonWithTitle:@"123" image:image];
    [self.changeButton addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    
    // 切换符号
    self.symbolBtn = [self setupBottomButtonWithTitle:@"符" image:image];
    // 空格
    self.blankBtn = [self setupBottomButtonWithTitle:@"" image:image];
    
    // return
    self.returnBtn = [self setupBottomButtonWithTitle:@"return" image:image];
    [self.returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 切换按钮
    self.shiftButton = [self setupBottomButtonWithTitle:nil image:nil];
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"c_chaKeyboardShiftButton"] forState:UIControlStateNormal];
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"c_chaKeyboardShiftButtonSel"] forState:UIControlStateHighlighted];
    self.shiftButton.contentMode = UIViewContentModeCenter;
    [self.shiftButton addTarget:self action:@selector(changeLetter) forControlEvents:UIControlEventTouchUpInside];
     
    // 删除按钮
    self.deleteBtn = [self setupBottomButtonWithTitle:nil image:nil];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"c_number_keyboardDeleteButton"] forState:UIControlStateNormal];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"c_number_keyboardDeleteButtonSel"] forState:UIControlStateHighlighted];
    self.deleteBtn.contentMode = UIViewContentModeCenter;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  
}

#pragma mark - 删除按钮可以点击 符号、ABC按钮不能点击
- (void)setupBottomNumButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    
    self.symbolBtn = [self setupBottomButtonWithTitle:@"符" image:image];
    self.textBtn = [self setupBottomButtonWithTitle:@"ABC" image:image];
    [self.textBtn addTarget:self action:@selector(imagepp) forControlEvents:UIControlEventTouchUpInside];
    // 删除按钮
    self.deleteBtn = [self setupBottomButtonWithTitle:nil image:nil];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"c_number_keyboardDeleteButton"] forState:UIControlStateNormal];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"c_number_keyboardDeleteButtonSel"] forState:UIControlStateHighlighted];
    self.deleteBtn.contentMode = UIViewContentModeCenter;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 点击事件
//代理传值
- (void)numBtnClick:(UIButton *)numBtn {
    
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickButton:)]) {
        [self.delegate keyboard:self didClickButton:numBtn];
    }
}
- (void)deleteBtnClick:(UIButton *)deleteBtn {

    if ([self.delegate respondsToSelector:@selector(keyboard:didClickDeleteBtn:)]) {
        [self.delegate keyboard:self didClickDeleteBtn:deleteBtn];
    }
}
- (void)returnBtnClick:(UIButton *)returnBtn {
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickReturnBtn:)]) {
        [self.delegate keyboard:self didClickReturnBtn:returnBtn];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////

// 切换字母数字
- (void)changeNum:(UIButton *)btn {
 NSLog(@"切换字母数字");
    [self setupTopNumButtonsWithImage:[self nomImage:YES] highImage:[self nomImage:NO]];
    [self setupBottomNumButtonsWithImage:[self nomImage:NO] highImage:[self nomImage:YES]];
     [self layoutSubview];
}
// 切换大小写
- (void)changeLetter {
    NSLog(@"切换大小写");
    [self setupTopButtonsWithImage:[self nomImage:YES] highImage:[self nomImage:NO] isLowercase:self.shiftChange];
    [self setupBottomButtonsWithImage:[self nomImage:NO] highImage:[self nomImage:YES]];
    [self layoutSubviewst];

}
#pragma mark - 布局
- (void)layoutSubviewst{

    CGFloat topMargin = 10;
    CGFloat bottomMargin = 10;
    CGFloat leftMargin = 8;
    CGFloat colMargin = 2;
    CGFloat rowMargin = 10;
    
    CGFloat topBtnW = (self.width - 2 * leftMargin - 9 * colMargin) / 10;
    CGFloat topBtnH = (self.height - topMargin - bottomMargin -  2* rowMargin-35) / 3;

    NSUInteger count = self.subviews.count;
    
    // 布局数字按钮
    for (NSUInteger i = 0; i < count; i++) {
       
        if (i < 20) { // 0 ~ 9
        
            UIButton *topButton = self.subviews[i];
            CGFloat row = i / 10;
            CGFloat col = i % 10;
            
            topButton.x = leftMargin + col * (topBtnW + colMargin);
            topButton.y = topMargin + row * (topBtnH + rowMargin);
            topButton.width = topBtnW;
            topButton.height = topBtnH;
        }
   
        if (i > 19) {
        
        UIButton *buttonZero  = self.subviews[i];
        CGFloat col           = i % 6;
        buttonZero.x          = leftMargin + (topBtnW + colMargin) *2 + col * (topBtnW + colMargin) ;
        buttonZero.y          = self.height - topBtnH *2;
        buttonZero.width      = topBtnW;
        buttonZero.height     = topBtnH;

        // 符号、文字及删除按钮的位置
        self.deleteBtn.x        = 8 *(topBtnW +colMargin) + leftMargin +topBtnW*0.5-15;
        self.deleteBtn.y        = buttonZero.y;
        self.deleteBtn.width    = buttonZero.width*1.5 + colMargin+15;
        self.deleteBtn.height   = buttonZero.height;


        self.shiftButton.x      = leftMargin;
        self.shiftButton.y      =  buttonZero.y;
        self.shiftButton.width  = self.deleteBtn.width;
        self.shiftButton.height = buttonZero.height;
            
            self.changeButton.x      = leftMargin;
            self.changeButton.y      = CGRectGetMaxY(buttonZero.frame)+ rowMargin-5;
            self.changeButton.width  = self.deleteBtn.width;
            self.changeButton.height = buttonZero.height-10;
          
            self.symbolBtn.x      = CGRectGetMaxX(self.changeButton.frame)+colMargin;
            self.symbolBtn.y      =  self.changeButton.y;
            self.symbolBtn.width  = self.changeButton.width;
            self.symbolBtn.height = self.changeButton.height;
           
            self.blankBtn.x       = CGRectGetMaxX(self.symbolBtn.frame) + colMargin;
            self.blankBtn.y      =  self.changeButton.y;
            self.blankBtn.width  = 5 *(topBtnW +colMargin) -colMargin;
            self.blankBtn.height = self.changeButton.height;
          
            
            self.returnBtn.x       = 8 *(topBtnW +colMargin) + leftMargin + 3*colMargin;
            self.returnBtn.y      =  self.changeButton.y;
            self.returnBtn.width  = self.changeButton.width *1.2;
            self.returnBtn.height = self.changeButton.height;
    
        }
     
    }
    
}

- (void)layoutSubview {
    
    CGFloat topMargin = 10;
    CGFloat bottomMargin = 3;
    CGFloat leftMargin = 3;
    CGFloat colMargin = 5;
    CGFloat rowMargin = 3;
    
    CGFloat topBtnW = (self.width - 2 * leftMargin - 2 * colMargin) / 3;
    CGFloat topBtnH = (self.height - topMargin - bottomMargin - 3 * rowMargin) / 4;
    
    NSUInteger count = self.subviews.count;
    
    // 布局数字按钮
    for (NSUInteger i = 0; i < count; i++) {
        if (i == 0 ) { // 0
            UIButton *buttonZero = self.subviews[i];
            buttonZero.height = topBtnH;
            buttonZero.width = topBtnW;
            buttonZero.centerX = self.centerX;
            buttonZero.centerY = self.height - bottomMargin - buttonZero.height * 0.5;
            
            // 符号、文字及删除按钮的位置
            self.deleteBtn.x = CGRectGetMaxX(buttonZero.frame) + colMargin;
            self.deleteBtn.y = buttonZero.y;
            self.deleteBtn.width = buttonZero.width;
            self.deleteBtn.height = buttonZero.height;
            
            self.textBtn.x = leftMargin;
            self.textBtn.y = buttonZero.y;
            self.textBtn.width = buttonZero.width / 2 - colMargin / 2;
            self.textBtn.height = buttonZero.height;

            self.symbolBtn.x = CGRectGetMaxX(self.textBtn.frame) + colMargin;
            self.symbolBtn.y = buttonZero.y;
            self.symbolBtn.width = self.textBtn.width;
            self.symbolBtn.height = buttonZero.height;
           
            
        }
        if (i > 0 && i < 10) { // 0 ~ 9
            
            UIButton *topButton = self.subviews[i];
            CGFloat row = (i - 1) / 3;
            CGFloat col = (i - 1) % 3;
            
            topButton.x = leftMargin + col * (topBtnW + colMargin);
            topButton.y = topMargin + row * (topBtnH + rowMargin);
            topButton.width = topBtnW;
            topButton.height = topBtnH;
        }
        
    }
    
}

- (UIButton *)setupBottomButtonWithTitle:(NSString *)title image:(UIImage *)image {
    
    UIButton *bottomBtn = [[UIButton alloc] init];
    if (title) {
        [bottomBtn setTitle:title forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:LVKeyboardTextFont];
        [bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (image) {
        [bottomBtn setBackgroundImage:image forState:UIControlStateNormal];
        bottomBtn.userInteractionEnabled = YES;
    }
    [self addSubview:bottomBtn];
    return bottomBtn;
}


@end
