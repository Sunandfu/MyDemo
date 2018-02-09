/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "TRSDialScrollView.h"
#import "TRSViewController.h"

@interface TRSViewController ()  <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet TRSDialScrollView *dialView;

@end

@implementation TRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];//尺寸间隔数
    [[TRSDialScrollView appearance] setMinorTickDistance:16];//尺寸宽度
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialBackground"]]];
    [[TRSDialScrollView appearance] setOverlayColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DialShadding"]]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:20]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor colorWithRed:0.800 green:0.553 blue:0.318 alpha:1.000]];
    [[TRSDialScrollView appearance] setMinorTickLength:15.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setSecondTickColor:[UIColor redColor]];
     
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    [[TRSDialScrollView appearance] setMajorTickLength:33.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:2.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    
    [_dialView setDialRangeFrom:0 to:250];
    
    _dialView.currentValue = 10;

    _dialView.delegate = self;
//    _dialView.transform = CGAffineTransformMakeRotation(M_PI_2);//旋转
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating:");
    NSLog(@"Current Value = %li", (long)_dialView.currentValue);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging:");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//     1 UniChar *characters;
//    2 CGGlyph *glyphs;
//    3CFIndex count;
//    4 5 CTFontRef ctFont = CTFontCreateWithName(CFSTR("STHeitiSC-Light"), 20.0, NULL);
//    6 CTFontDescriptorRef ctFontDesRef = CTFontCopyFontDescriptor(ctFont);
//    7 CGFontRef cgFont = CTFontCopyGraphicsFont(ctFont,&ctFontDesRef );
//    8CGContextSetFont(context, cgFont);
//    9 CFNumberRef pointSizeRef = (CFNumberRef)CTFontDescriptorCopyAttribute(ctFontDesRef,kCTFontSizeAttribute);
//    10CGFloat fontSize;
//    11 CFNumberGetValue(pointSizeRef, kCFNumberCGFloatType,&fontSize);
//    12CGContextSetFontSize(context, fontSize);
//    13 NSString* str2 = @"这是中文文本(Quartz 2D)。";
//    14 count = CFStringGetLength((CFStringRef)str2);
//    15 characters = (UniChar *)malloc(sizeof(UniChar) * count);
//    16 glyphs = (CGGlyph *)malloc(sizeof(CGGlyph) * count);
//    17 CFStringGetCharacters((CFStringRef)str2, CFRangeMake(0, count), characters);
//    18CTFontGetGlyphsForCharacters(ctFont, characters, glyphs, count);
//    19 CGContextShowGlyphsAtPoint(context, 0, 200, glyphs, str2.length);
//    20
//    21free(characters);
//    22 free(glyphs);
}




@end
