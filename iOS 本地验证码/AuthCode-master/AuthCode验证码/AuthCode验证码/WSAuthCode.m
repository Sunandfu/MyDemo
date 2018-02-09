//
//  WSAuthCode.m
//  AuthCode验证码
//
//  Created by iMac on 16/9/19.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "WSAuthCode.h"
#define KrandomColor   [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

@interface WSAuthCode ()

@property(nonatomic,strong)NSArray *numbersArray;

@property(nonatomic,strong)NSArray *wordsArray;

@end
@implementation WSAuthCode
-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        [self loadingDefaultProperty];
        
        
        [self produceAuthCodeString];
        
        
    }
    
    return self;
    
}


-(instancetype)initWithFrame:(CGRect)frame allWordArraytype:(AllWordArraytypes )allWordArraytype{
    
    
    if (self = [super initWithFrame:frame]) {
        
        _allWordArraytype = allWordArraytype;
        
        
        [self loadingDefaultProperty];
        
        [self produceAuthCodeString];
        
    }
    
    return self;
    
    
}




#pragma mark --- 初始化默认设置 ---

-(void)loadingDefaultProperty{
    
    
    self.numbersArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    self.wordsArray = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    _authCodeNumber = 4;
    
    _disturbLineNumber = 2;
    
    _fontSize = 17;
    
    _wordSpacingType = WordSpacingTypeMedium;
    
    _authCodeRect = CGRectMake(0,self.frame.size.height/4 , self.frame.size.width , self.frame.size.height/4*3);
    
    //设置圆角
    self.layer.cornerRadius = 5;
    
    self.layer.masksToBounds = YES;
    
    
}


-(void)reloadAuthCodeView{
    
    [self produceAuthCodeString];
    
    
    [self setNeedsDisplay];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self produceAuthCodeString];
    
    
    [self setNeedsDisplay];
    
}



#pragma mark ---- 随机生成验证码 ----
-(void)produceAuthCodeString{
    
    NSMutableString *produceString = [[NSMutableString alloc]initWithCapacity:16];
    
    switch (self.allWordArraytype) {
        case BlendWordAndNumbers:{
            
            //混合库模式
            
            NSMutableArray *blendArray = [NSMutableArray arrayWithArray:self.numbersArray];
            
            [blendArray addObjectsFromArray:self.wordsArray];
            
            for (int i = 0; i<self.authCodeNumber; i++) {
                
                //随机下标
                int indexNumber = arc4random()%(blendArray.count);
                
                [produceString appendString:blendArray[indexNumber]];
                
            }
            
            
            
        }
            
            break;
            
        case OnlyNumbers:{
            
            //数字模式
            
            NSMutableArray *blendArray = [NSMutableArray arrayWithArray:self.numbersArray];
            
            
            for (int i = 0; i<self.authCodeNumber; i++) {
                
                //随机下标
                int indexNumber = arc4random()%(blendArray.count);
                
                [produceString appendString:blendArray[indexNumber]];
                
            }
            
            
            
            
        }
            
            break;
            
            
            
        case OnlyWord:{
            
            //字母模式
            NSMutableArray *blendArray = [NSMutableArray arrayWithArray:self.wordsArray];
            
            
            for (int i = 0; i<self.authCodeNumber; i++) {
                
                //随机下标
                int indexNumber = arc4random()%(blendArray.count);
                
                [produceString appendString:blendArray[indexNumber]];
                
            }
            
            
            
            
        }
            
            break;
            
            
            
    }
    
    
    self.authCodeString = produceString;
    
    
    
    
}

#pragma mark --- 根据字符间距属性 返回一个NSnumber类型 ----

-(NSNumber *)wordSpacingNumberWithType{
    
    NSNumber *wordSpacingNumber;
    
    switch (_wordSpacingType) {
        case WordSpacingTypeNone:
            
            wordSpacingNumber = [NSNumber numberWithInt:0];
            break;
        case WordSpacingTypeSmall:
            
            wordSpacingNumber = [NSNumber numberWithInt:10];
            break;
        case WordSpacingTypeMedium:
            
            wordSpacingNumber = [NSNumber numberWithInt:20];
            break;
        case WordSpacingTypeBig:
            
            wordSpacingNumber = [NSNumber numberWithInt:40];
            break;
            
    }
    
    
    return wordSpacingNumber;
}



#pragma mark --- 绘制验证码View ---
- (void)drawRect:(CGRect)rect {
    
    
    //背景设置
    self.backgroundColor = KrandomColor;
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentCenter;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    
    
    [self.authCodeString drawInRect:_authCodeRect withAttributes:@{
                                                                   
                                                                   NSForegroundColorAttributeName :KrandomColor,
                                                                   NSKernAttributeName: [self wordSpacingNumberWithType],
                                                                   NSParagraphStyleAttributeName:paragraphStyle,
                                                                   NSFontAttributeName : [UIFont systemFontOfSize:_fontSize],
                                                                   
                                                                   }];
    
    
    
    for (int i = 0; i < _disturbLineNumber; i++) {
        
        //设置随机位置的x和y
        CGSize viewSize = self.frame.size;
        
        int startX = arc4random()%((int)viewSize.width/2);
        
        int endX = arc4random()%((int)viewSize.width - (int)viewSize.width/2) +(int)viewSize.width/2;
        
        int startY = arc4random()%((int)viewSize.height);
        
        int endY = arc4random()%((int)viewSize.height);
        
        
        //获取上下文
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        //创建路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, nil, startX, startY);
        
        CGPathAddLineToPoint(path, nil, endX, endY);
        
        CGContextAddPath(contextRef, path);
        
        //设置图形上下文状态属性
        CGContextSetRGBStrokeColor(contextRef, arc4random_uniform(256) / 255.0, arc4random_uniform(256) / 255.0, arc4random_uniform(256) / 255.0, 1);//设置笔触颜色
        CGContextSetLineWidth(contextRef, 1);//设置线条宽度
        
        CGContextDrawPath(contextRef, kCGPathFillStroke);//最后一个参数是填充类型
        
        CGPathRelease(path);
    }
    
}


#pragma mark ---- 设置属性就会重新绘制 ---

-(void)setAllWordArraytype:(AllWordArraytypes)allWordArraytype{
    
    _allWordArraytype = allWordArraytype;
    
    [self reloadAuthCodeView];
    
    
}

-(void)setAuthCodeNumber:(NSInteger)authCodeNumber{
    
    _authCodeNumber = authCodeNumber;
    
    [self reloadAuthCodeView];
    
}

-(void)setDisturbLineNumber:(NSInteger)disturbLineNumber{
    
    _disturbLineNumber = disturbLineNumber;
    
    [self reloadAuthCodeView];
    
}

-(void)setFontSize:(NSInteger)fontSize{
    
    _fontSize = fontSize;
    
    [self reloadAuthCodeView];
    
    
}

-(void)setWordSpacingType:(WordSpacingTypes)wordSpacingType{
    
    _wordSpacingType = wordSpacingType;
    
    [self reloadAuthCodeView];
    
    
}

-(void)setAuthCodeRect:(CGRect)authCodeRect{
    
    _authCodeRect = authCodeRect;
    
    [self reloadAuthCodeView];
    
    
}


//开始验证   string是输入的字符串
- (BOOL)startAuthWithString:(NSString *)string {
    int result = [self.authCodeString compare:string options:NSCaseInsensitiveSearch | NSNumericSearch];
    
    if (result == 0) {
        return YES;
    }
    else {
        return NO;
    }
    
}


@end
