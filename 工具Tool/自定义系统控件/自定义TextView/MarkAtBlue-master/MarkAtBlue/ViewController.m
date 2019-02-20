//
//  ViewController.m
//  MarkAtBlue
//
//  Created by tongleiming on 2018/10/11.
//  Copyright © 2018年 tongleiming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
    
@property (weak, nonatomic) IBOutlet UITextView *textView;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textView.delegate = self;
}


- (void)textViewDidChange:(UITextView *)textView {
    [self markAtBlue:textView.text];
}

- (void)markAtBlue:(NSString *)text {
    NSString *sendString = text;
    [self.textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, sendString.length)];
    [self.textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, sendString.length)];
    
    NSError *error = nil;
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:@"@[\u4e00-\u9fa5a-zA-Z0-9_-]+" options:NSRegularExpressionCaseInsensitive error:&error];
    [atPersionRE enumerateMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.location != NSNotFound) {
            [self.textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:60/255.0 green:150/255.0 blue:255/255.0 alpha:1/1.0] range:result.range];
        }
    }];
}
@end
