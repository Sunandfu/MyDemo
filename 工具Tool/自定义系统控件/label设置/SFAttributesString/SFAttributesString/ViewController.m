//
//  ViewController.m
//  SFAttributesString
//
//  Created by lurich on 2021/7/14.
//

#import "ViewController.h"
#import "NSAttributedString+SFMake.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.testLabel.layer.cornerRadius = 8;
    self.testLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.testLabel.layer.borderWidth = 0.6;
    self.testLabel.clipsToBounds = YES;
    self.testLabel.backgroundColor = [UIColor whiteColor];
    self.testLabel.numberOfLines = 0;
    self.testLabel.text = @"请选择 demo ";
    
    NSAttributedString *attr = [NSAttributedString sf_UIKitText:^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
        make.font([UIFont boldSystemFontOfSize:16]).textColor(UIColor.blackColor).lineSpacing(5);
        
        make.append(@":Image -");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.bounds = CGRectMake(0, 0, 30, 30);
            make.alignment = SFUTVerticalAlignmentCenter;
        });

        make.append(@"\n");
        make.append(@":UnderLine   test").underLine(^(id<SFUTDecoration>  _Nonnull make) {
            make.style = NSUnderlineStyleSingle | NSUnderlineStylePatternDot | NSUnderlineByWord;
            make.color = UIColor.greenColor;
        });
        
        make.append(@"\n");
        make.append(@":Strikethrough").strikethrough(^(id<SFUTDecoration>  _Nonnull make) {
            make.style = NSUnderlineStyleThick;
            make.color = UIColor.redColor;
        });
        
        make.append(@"\n");
        make.append(@":BackgroundColor").backgroundColor(UIColor.greenColor);
        
        make.append(@"\n");
        make.append(@":Kern").kern(6);

        make.append(@"\n");
        make.append(@":Shadow").shadow(^(NSShadow * _Nonnull make) {
            make.shadowColor = [UIColor redColor];
            make.shadowOffset = CGSizeMake(0, 1);
            make.shadowBlurRadius = 5;
        });

        make.append(@"\n");
        make.append(@":Stroke").stroke(^(id<SFUTStroke>  _Nonnull make) {
            make.color = [UIColor greenColor];
            make.width = 1;
        });

        make.append(@"\n");
        make.append(@"oOo").font([UIFont boldSystemFontOfSize:25]).alignment(NSTextAlignmentCenter);
        
        make.append(@"\n");
        make.append(@"点击https://baidu.com网站获取详情").font([UIFont boldSystemFontOfSize:15]).alignment(NSTextAlignmentCenter).textColor(UIColor.redColor);
        make.regex(@"https://baidu.com").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
            make.font([UIFont boldSystemFontOfSize:18]).textColor(UIColor.blueColor);
        });

        make.append(@"\n");
        make.append(@"Regular Expression").backgroundColor([UIColor greenColor]);
        make.regex(@"Regular").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
            make.font([UIFont boldSystemFontOfSize:25]).textColor(UIColor.purpleColor);
        });
        
        make.regex(@"ss").replaceWithString(@"SS").backgroundColor([UIColor redColor]);
        make.regex(@"on").replaceWithText(^(id<SFUIKitTextMakerProtocol>  _Nonnull make) {
            make.append(@"ON😆").textColor([UIColor yellowColor]).backgroundColor([UIColor blueColor]).font([UIFont boldSystemFontOfSize:30]);
        });
        
        make.append(@"\n");
        make.append(@"@迷你世界联机 :@江叔 用小淘气耍赖野人#迷你世界#");
        make.regex(@"[@#][^\\s]+[\\s#]").update(^(id<SFUTAttributesProtocol>  _Nonnull make) {
            make.textColor([UIColor purpleColor]);
        });
        
        make.append(@"\n");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.bounds = CGRectMake(0, 0, 25, 25);
        });
        make.append(@"\n上下图文");
        
        make.append(@"\n");
        make.append(@"  左右图文  ");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.bounds = CGRectMake(0, -18, 25, 25);
        });
        
        make.append(@"\n");
        make.append(@"Top->");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.alignment = SFUTVerticalAlignmentTop;
            make.bounds = CGRectMake(0, 0, 25, 25);
        });
        
        make.append(@"Center->");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.alignment = SFUTVerticalAlignmentCenter;
            make.bounds = CGRectMake(0, 0, 25, 25);
        });
        
        make.append(@"Bottom->");
        make.appendImage(^(id<SFUTImageAttachment>  _Nonnull make) {
            make.image = [UIImage imageNamed:@"sample2"];
            make.alignment = SFUTVerticalAlignmentBottom;
            make.bounds = CGRectMake(0, 0, 25, 25);
        });
    }];
    self.testLabel.attributedText = attr;
    [self.testLabel sf_addAttributeTapActionWithStrings:@[@"https://baidu.com"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSLog(@"string=%@ range=%@ index=%ld",string,NSStringFromRange(range),index);
    }];
    [self updateConstraints];
}
- (void)updateConstraints {
    CGSize size = [self.testLabel sf_getAttributedStringSizeWithWidth:self.view.bounds.size.width - 40 Height:CGFLOAT_MAX];
    self.widthConstraint.constant = size.width;
    self.heightConstraint.constant = size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
