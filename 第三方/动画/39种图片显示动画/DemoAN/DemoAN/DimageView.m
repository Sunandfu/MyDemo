//
//  DimageView.m
//  DemoAN
//
//  Created by Dolphin-MC700 on 14-9-17.
//  Copyright (c) 2014年 kid8. All rights reserved.
//

#import "DimageView.h"


@implementation DimageView

- (id)initWithFrame:(CGRect)frame maxWight:(float) wight maxHight:(float)hight number:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setNeedsDisplay];
//        self.backgroundColor = [UIColor whiteColor];
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
        myImageObj= [[UIImage alloc] initWithContentsOfFile:imagePath];
        [myImageObj drawAtPoint:CGPointMake(0, 0)];
        
        _number = number;
        imageFrame = frame;
        switch (_number) {
            case 0:{
                h = frame.size.height;
                w = frame.size.width;
                r = 0;
                R = hypot(h,w);
                x = w/2 - r/2;
                y = h/2 - r/2;
                break;
            }
            case 1:{
                h = frame.size.height;
                w = frame.size.width;
                r = hypot(h,w);
                x = w/2 - r/2;
                y = h/2 - r/2;
                break;
            }
            case 2:{
                h = 0;
                w = 0;
                x = frame.size.width/2;
                y = frame.size.height/2;
                scale = frame.size.width/frame.size.height;
                break;
            }
            case 3:{
                h = frame.size.height;
                w = frame.size.width;
                x = 0;
                y = 0;
                R = frame.size.width;
                r = frame.size.height;
                scale = R/r;
                break;
            }
            case 4:{
                h = frame.size.height;
                w = 2*frame.size.width;
                h1 = 2*frame.size.height;
                w1 = frame.size.width;
                x = -(frame.size.width/2);
                y = 0;
                x1 = 0;
                y1 = -(frame.size.height/2);
                scale = w1/h;
                break;
            }
            case 5:{
                h = 0;
                w = frame.size.width*2;
                h1 = frame.size.height*2;
                w1 = 0;
                x = -frame.size.width/2;
                y = frame.size.height/2;
                x1 = frame.size.width/2;
                y1 = -frame.size.height/2;
                scale = frame.size.width/frame.size.height;
                break;
            }
            case 6:{
                x = frame.size.width/2;
                y = frame.size.height/2;
                x1 = frame.size.width/2;
                y1 = frame.size.height/2;
                x2 = frame.size.width/2;
                y2 = frame.size.height/2;
                x3 = frame.size.width/2;
                y3 = frame.size.height/2;
                scale = frame.size.width/frame.size.height;
                break;
            }
            case 7:{
                x = -(frame.size.width/2);
                y = frame.size.height/2;
                x1 = frame.size.width/2;
                y1 = -(frame.size.height/2);
                x2 = frame.size.width*1.5;
                y2 = frame.size.height/2;
                x3 = frame.size.width/2;
                y3 = frame.size.height*1.5;
                scale = frame.size.width/frame.size.height;
                break;
            }
            case 8:{
                x = 0;
                h = frame.size.height;
                w = frame.size.width;
                break;
            }
            case 9:{
                x = 50;
                h = frame.size.height;
                w = frame.size.width;
                break;
            }
            case 10:{
                x = 0;
                y = 0;
                x1 = frame.size.width/2;
                y1 = 0;
                h = frame.size.height;
                w = frame.size.width/2;
                break;
            }
            case 11:{
                x = 0;
                y = 0;
                x1 = frame.size.width;
                y1 = 0;
                h = frame.size.height;
                w = frame.size.width;
                w1 = 0;
                break;
            }
            case 12:{
                x = 0;
                h = frame.size.height;
                w = frame.size.width;
                break;
            }
            case 13:{
                x = 50;
                h = frame.size.height;
                w = frame.size.width;
                break;
            }
            case 14:{
                x = 0;
                y = 0;
                x1 = 0;
                y1 = frame.size.height;
                h = 0;
                w = frame.size.width;
                break;
            }
            case 15:{
                x = 0;
                y = 0;
                x1 = 0;
                y1 = frame.size.height/2;
                h = frame.size.height;
                w = frame.size.width;
                h1 = frame.size.height/2;
                break;
            }
            case 16:{
                x = 0;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                break;
            }
            case 17:{
                x = 50;
                y = 50;
                h = frame.size.height;
                w = frame.size.width;
                break;
            }
            case 18:{
                x = 0;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                w1 = 0;
                break;
            }
            case 19:{
                x = frame.size.width;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                w1 = 0;
                break;
            }
            case 20:{
                x = 0;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                h1 = 0;
                break;
            }
            case 21:{
                x = 0;
                y = frame.size.height;
                y1 = frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                h1 = 0;
                break;
            }
            case 22:{
                x = 0;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                w1 = frame.size.width;
                break;
            }
            case 23:{
                x = 0;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                w1 = frame.size.width;
                break;
            }
            case 24:{
                x = 0;
                y = 0;
                h = frame.size.height;
                w = frame.size.width;
                h1 = frame.size.height;
                break;
            }
            case 25:{
                x = 0;
                y = 0;
                y1 = 0;
                h = frame.size.height;
                w = frame.size.width;
                h1 = frame.size.height;
                break;
            }
            case 26:{
                x = 0;
                y = 0;
                x1 = 0;
                y1 = 0;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 27:{
                x = frame.size.width;
                y = 0;
                x1 = frame.size.width;
                y1 = 0;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 28:{
                x = 0;
                y = frame.size.height;
                x1 = 0;
                y1 = frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 29:{
                x = frame.size.width;
                y = frame.size.height;
                x1 = frame.size.width;
                y1 = frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 30:{
                x = frame.size.width;
                y = frame.size.height;
                x1 = -frame.size.width;
                y1 = -frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 31:{
                x = 0;
                y = frame.size.height;
                x1 = 2*frame.size.width;
                y1 = -frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 32:{
                x = frame.size.width;
                y = 0;
                x1 = -frame.size.width;
                y1 = 2*frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            case 33:{
                x = 0;
                y = 0;
                x1 = 2*frame.size.width;
                y1 = 2*frame.size.height;
                h = frame.size.height;
                w = frame.size.width;
                scale = w/h;
                break;
            }
            default:
                break;
        }
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    if (_number == 0||_number == 1||_number == 2||_number == 3||_number == 6||_number == 7) {
    }else{
        [myImageObj drawInRect:self.bounds];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self circleIn:context];
}

-(void)circleIn:(CGContextRef)context{
    switch (_number) {
        case 0:{
            if (r>R) {
                [self.delegate stopDraw];
            }else{
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, w, h));
                CGContextSetBlendMode(context, kCGBlendModeXOR);
                CGContextFillPath(context);
                CGContextFillEllipseInRect(context, CGRectMake(x, y, r,r));
                NSLog(@"w %f h : %f x: %f y : %f r: %f ", w, h, x, y, r);
                r+=2;
                x--;
                y--;
            }
            break;
        }
        case 1:
            if (r<0) {
                [self.delegate stopDraw];
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, w, h));
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGContextFillPath(context);
            }else{
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, w, h));
                CGContextSetBlendMode(context, kCGBlendModeXOR);
                CGContextFillPath(context);
                CGContextFillEllipseInRect(context, CGRectMake(x, y, r,r));
                r-=2;
                x++;
                y++;
            }
            break;
        case 2:
            if (w<0) {
                [self.delegate stopDraw];
            }else{
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
                CGContextSetBlendMode(context, kCGBlendModeXOR);
                CGContextFillPath(context);
                CGRect rectangle = CGRectMake(x, y, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                x-=scale;
                y--;
                w+=2*scale;
                h+=2;
            }
            break;
        case 3:{
            if (w<0) {
                [self.delegate stopDraw];
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGContextFillPath(context);
            }else{
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
                CGContextSetBlendMode(context, kCGBlendModeXOR);
                CGContextFillPath(context);
                CGRect rectangle = CGRectMake(x, y, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                x+=scale/2;
                y+=0.5;
                w-=scale;
                h--;
            }
            break;
        }
        case 4:{
            CGRect rectangle1 = CGRectMake(x, y, w, h);
            CGRect rectangle2 = CGRectMake(x1, y1, w1, h1);
            if (h<0) {
                [self.delegate stopDraw];
            }else{
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
                CGContextStrokeRect(context, rectangle2);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle2);
                h -= 2;
                y ++;
                x1 +=scale;
                w1 -= 2*scale;
            }
            break;
        }
        case 5:{
            CGRect rectangle1 = CGRectMake(x, y, w, h);
            CGRect rectangle2 = CGRectMake(x1, y1, w1, h1);
            if (y<0) {
                [self.delegate stopDraw];
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
            }else{
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
                CGContextStrokeRect(context, rectangle2);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle2);
                h += 2;
                y --;
                x1 -=scale;
                w1 += 2*scale;
            }
            break;
        }
        case 6:{
            if (x<-(imageFrame.size.width/2)) {
                [self.delegate stopDraw];
            }else{
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
                CGContextSetBlendMode(context, kCGBlendModeXOR);
                CGContextFillPath(context);
                CGContextMoveToPoint(context, x, y);
                CGContextAddLineToPoint(context, x1, y1);
                CGContextAddLineToPoint(context, x2, y2);
                CGContextAddLineToPoint(context, x3, y3);
                CGContextAddLineToPoint(context, x, y);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillPath(context);
                CGContextStrokePath(context);
                x-=scale;
                y1--;
                x2+=scale;
                y3++;
            }
            break;
        }
        case 7:{
            if (x>imageFrame.size.width/2) {
                [self.delegate stopDraw];
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGContextFillPath(context);
            }else{
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
                CGContextAddRect(context, CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height));
                CGContextSetBlendMode(context, kCGBlendModeXOR);
                CGContextFillPath(context);
                CGContextMoveToPoint(context, x, y);
                CGContextAddLineToPoint(context, x1, y1);
                CGContextAddLineToPoint(context, x2, y2);
                CGContextAddLineToPoint(context, x3, y3);
                CGContextAddLineToPoint(context, x, y);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillPath(context);
                CGContextStrokePath(context);
                x+=scale;
                y1++;
                x2-=scale;
                y3--;
            }
            break;
        }
        case 8:{
            if (x>50) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                for (int i=0; i<w/50; i++) {
                    CGRect rectangle = CGRectMake(i*50, 0, x, h);
                    CGContextStrokeRect(context, rectangle);
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                    CGContextFillRect(context, rectangle);
                }
                
                x++;
            }
            break;
        }
        case 9:{
            if (x<0) {
                [self.delegate stopDraw];
            }else{
                for (int i=0; i<w/50; i++) {
                    CGRect rectangle = CGRectMake(i*50, 0, x, h);
                    CGContextStrokeRect(context, rectangle);
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                    CGContextFillRect(context, rectangle);
                }
                
                x--;
            }
            break;
        }
        case 10:{
            if (w<0) {
                [self.delegate stopDraw];
            }else{
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                CGRect rectangle1 = CGRectMake(x1, 0, w, h);
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
                x1++;
                w--;
            }
            break;
        }
        case 11:{
            if (w1>imageFrame.size.width/2) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGRect rectangle = CGRectMake(0, 0, w1, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                CGRect rectangle1 = CGRectMake(x1, 0, w, h);
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
                x1--;
                w1++;
            }
            break;
        }
        case 12:{
            if (x>50) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                for (int i=0; i<h/50; i++) {
                    CGRect rectangle = CGRectMake(0, i*50, w, x);
                    CGContextStrokeRect(context, rectangle);
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                    CGContextFillRect(context, rectangle);
                }
                
                x++;
            }
            break;
        }
        case 13:{
            if (x<0) {
                [self.delegate stopDraw];
            }else{
                for (int i=0; i<h/50; i++) {
                    CGRect rectangle = CGRectMake(0, i*50, w, x);
                    CGContextStrokeRect(context, rectangle);
                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                    CGContextFillRect(context, rectangle);
                }
                x--;
            }
            break;
        }
        case 14:{
            if (h>imageFrame.size.height/2) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, imageFrame.size.height);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                CGRect rectangle1 = CGRectMake(0, y1, w, h);
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
                y1--;
                h++;
            }
            break;
        }
        case 15:{
            if (h1<0) {
                [self.delegate stopDraw];
            }else{
                CGRect rectangle = CGRectMake(0, 0, w, h1);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                CGRect rectangle1 = CGRectMake(0, y1, w, h1);
                CGContextStrokeRect(context, rectangle1);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle1);
                y1++;
                h1--;
            }
            break;
        }
        case 16:{
            if (x>50) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                for (int i=0; i<w/50; i++) {
                    for (int j=0; j<h/50; j++) {
                        CGRect rectangle = CGRectMake(i*50, j*50, x, y);
                        CGContextStrokeRect(context, rectangle);
                        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                        CGContextFillRect(context, rectangle);
                    }
                }
                x++;
                y++;
            }
            break;
        }
        case 17:{
            if (x<0) {
                [self.delegate stopDraw];
            }else{
                for (int i=0; i<w/50; i++) {
                    for (int j=0; j<h/50; j++) {
                        CGRect rectangle = CGRectMake(i*50, j*50, x, y);
                        CGContextStrokeRect(context, rectangle);
                        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                        CGContextFillRect(context, rectangle);
                    }
                }
                x--;
                y--;
            }
            break;
        }
        case 18:{
            if (w1>imageFrame.size.width) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGRect rectangle = CGRectMake(0, 0, w1, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                w1++;
            }
            break;
        }
        case 19:{
            if (w1>imageFrame.size.width) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGRect rectangle = CGRectMake(x, 0, w1, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                x--;
                w1++;
            }
            break;
        }
        case 20:{
            if (h1>imageFrame.size.height) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGRect rectangle = CGRectMake(0, 0, w, h1);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                h1++;
            }
            break;
        }
        case 21:{
            if (h1>imageFrame.size.height) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGRect rectangle = CGRectMake(0, y1, w, h1);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                y1--;
                h1++;
            }
            break;
        }
        case 22:{
            if (w1<0) {
                [self.delegate stopDraw];
            }else{
                CGRect rectangle = CGRectMake(0, 0, w1, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                w1--;
            }
            break;
        }
        case 23:{
            if (w1<0) {
                [self.delegate stopDraw];
            }else{
                CGRect rectangle = CGRectMake(x, 0, w1, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                x++;
                w1--;
            }
            break;
        }
        case 24:{
            if (h1<0) {
                [self.delegate stopDraw];
            }else{
                CGRect rectangle = CGRectMake(0, 0, w, h1);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                h1--;
            }
            break;
        }
        case 25:{
            if (h1<0) {
                [self.delegate stopDraw];
            }else{
                CGRect rectangle = CGRectMake(0, y1, w, h1);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
                y1++;
                h1--;
            }
            break;
        }
        case 26:{
            if (x1>2*w) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,0, y1);//设置起点
                CGContextAddLineToPoint(context,0, 0);
                CGContextAddLineToPoint(context,x1, 0);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
//                [[UIColor whiteColor] setStroke]; //设置边框颜色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1+=scale;
                y1++;
            }
            break;
        }
        case 27:{
            if (x1<-w) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,x1, 0);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x, y1);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1-=scale;
                y1++;
            }
            break;
        }
        case 28:{
            if (x1>2*w) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,0, y1);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x1, y);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1+=scale;
                y1--;
            }
            break;
        }
        case 29:{
            if (x1<-w) {
                [self.delegate stopDraw];
                CGRect rectangle = CGRectMake(0, 0, w, h);
                CGContextStrokeRect(context, rectangle);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextFillRect(context, rectangle);
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,x1, y);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x, y1);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1-=scale;
                y1--;
            }
            break;
        }
        case 30:{
            if (x1>w) {
                [self.delegate stopDraw];
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,x1, y);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x, y1);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1+=scale;
                y1++;
            }
            break;
        }
        case 31:{
            if (x1<0) {
                [self.delegate stopDraw];
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,x, y1);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x1, y);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1-=scale;
                y1++;
            }
            break;
        }
        case 32:{
            if (x1>w) {
                [self.delegate stopDraw];
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,x1, y);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x, y1);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1+=scale;
                y1--;
            }
            break;
        }
        case 33:{
            if (x1<0) {
                [self.delegate stopDraw];
            }else{
                CGContextBeginPath(context);//标记
                CGContextMoveToPoint(context,x1, y);//设置起点
                CGContextAddLineToPoint(context,x, y);
                CGContextAddLineToPoint(context,x, y1);
                CGContextClosePath(context);//路径结束标志，不写默认封闭
                [[UIColor blackColor] setFill]; //设置填充色
                CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
                x1-=scale;
                y1--;
            }
            break;
        }
        default:
            break;
    }
}

@end
