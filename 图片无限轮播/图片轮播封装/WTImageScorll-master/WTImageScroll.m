//
//  WTImageScroll.m
//  
//
//  Created by netvox-ios1 on 16/4/14.
//  Copyright © 2016年 netvox-ios1. All rights reserved.
//  

#import "WTImageScroll.h"
#import <CommonCrypto/CommonDigest.h>

#pragma  mark 创建md5加密
@interface NSString (MD5)

//返回一个当前字符串md5加密后的结果
- (NSString* )md5;

@end

@implementation NSString (MD5)

- (NSString* )md5 {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG)[self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

@end

@implementation WTImageScroll

{
    NSArray *imgArray;  //图片数组
    UIPageControl *pageView;//分页
    BtnClickBlock btnClicks;//block
    UIScrollView *myScroll;
    NSTimer *timer;//计时器
    NSInteger scrollIndex;//下表值
    NSDictionary *imgChaceDic; //图片缓存
}

+(UIView *)ShowLocationImageScrollWithFream:(CGRect)rect andImageArray:(NSArray *)array andBtnClick:(BtnClickBlock)btnClick
{
    WTImageScroll *selfImageScroll=[[WTImageScroll alloc]initWithFrame:rect];
    [selfImageScroll ShowImageScrollWithImageArray:array andBtnClick:btnClick andShowImageStyle:ImageShowStyleLocation];
    return selfImageScroll;
}

+(UIView *)ShowNetWorkImageScrollWithFream:(CGRect)rect andImageArray:(NSArray *)array andBtnClick:(BtnClickBlock)btnClick
{
    WTImageScroll *selfImageScroll=[[WTImageScroll alloc]initWithFrame:rect];
    [selfImageScroll ShowImageScrollWithImageArray:array andBtnClick:btnClick andShowImageStyle:ImageShowStyleNetwork];
    return selfImageScroll;
}

+(void)clearNetImageChace
{
   [[WTImageScroll alloc] clearNetImageChace];
}

//控制显示
-(void)ShowImageScrollWithImageArray:(NSArray *)array andBtnClick:(BtnClickBlock)btnClick andShowImageStyle:(ImageShowStyle)showStyle
{
    
    imgArray=array;
    btnClicks=btnClick;
    
    myScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
    myScroll.delegate=self;
    myScroll.pagingEnabled=YES;
    myScroll.contentSize=CGSizeMake(self.bounds.size.width*(array.count+2), 200);
    myScroll.contentOffset=CGPointMake(self.bounds.size.width, 0);
    myScroll.showsHorizontalScrollIndicator=NO;
    [self addSubview:myScroll];
    
    scrollIndex=1;
    
    for(NSInteger i = 0 ; i <array.count+1 ; i++){
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(self.bounds.size.width*(i+1), 0, self.bounds.size.width, self.bounds.size.height);
        btn.tag=100+i;
        if(showStyle==ImageShowStyleLocation){
            [btn setImage:[UIImage imageNamed:array[i>(array.count-1)?0:i]] forState:UIControlStateNormal];
        }else{
            [self networkImageSettingWithString:array[i>(array.count-1)?0:i] AndShowImageView:btn];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [myScroll addSubview:btn];
        
    }
    
    UIButton *regitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    regitBtn.frame=CGRectMake(self.bounds.size.width*(array.count+1), 0, self.bounds.size.width, self.bounds.size.height);
    [myScroll addSubview:regitBtn];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [myScroll addSubview:leftBtn];
    
    if(showStyle==ImageShowStyleNetwork){
        [self networkImageSettingWithString:[array firstObject] AndShowImageView:regitBtn];
        [self networkImageSettingWithString:[array lastObject] AndShowImageView:leftBtn];
    }else{
        [regitBtn setImage:[UIImage imageNamed:[array firstObject]] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:[array lastObject]] forState:UIControlStateNormal];
    }
    
    pageView=[[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
    pageView.numberOfPages=array.count;
    pageView.currentPage=0;
    pageView.userInteractionEnabled=NO;
    pageView.currentPageIndicatorTintColor=[UIColor greenColor];
    pageView.pageIndicatorTintColor=[UIColor grayColor];
    [self addSubview:pageView];
    
    [self startTime];

}


#pragma mark   ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    NSInteger index=scrollView.contentOffset.x/320;
    
    if(index==(imgArray.count+1)){
        
        scrollView.contentOffset=CGPointMake(self.bounds.size.width, 0);
        pageView.currentPage=0;
        scrollIndex=1;
        
    }else if(index==0){
        
        scrollView.contentOffset=CGPointMake(imgArray.count*self.bounds.size.width, 0);
        pageView.currentPage=imgArray.count-1;
        scrollIndex=imgArray.count;
        
    }else{
        
        pageView.currentPage=index-1;
        scrollIndex=index;
        
    }
    
    [self startTime];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //关闭计时器
    if(timer!=nil){
        [timer invalidate];
        timer=nil;
    }
}


#pragma mark 按钮点击
-(void)btnClick:(UIButton *)aBtn
{
    if(btnClicks){
        btnClicks(aBtn.tag-100);
    }
}

#pragma mark 添加滚动
-(void)scrollForTime:(NSTimer *)time
{
    scrollIndex=scrollIndex+1;
    
    if(scrollIndex==imgArray.count+1){
        
        [myScroll setContentOffset:CGPointMake(self.bounds.size.width*scrollIndex, 0) animated:YES];
        scrollIndex=1;
        
        [self performSelector:@selector(scrollToInit) withObject:nil afterDelay:0.5];
    }else{
        
        [myScroll setContentOffset:CGPointMake(self.bounds.size.width*scrollIndex, 0) animated:YES];
        
    }
    
    pageView.currentPage=scrollIndex-1;
}

//开启定时器
-(void)startTime
{
    if(timer==nil){
        timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollForTime:) userInfo:nil repeats:YES];
    }

}

//回到原点
-(void)scrollToInit
{
    [myScroll setContentOffset:CGPointMake(self.bounds.size.width*scrollIndex, 0) animated:NO];
}

#pragma  mark 网络图片处理
-(void)networkImageSettingWithString:(NSString *)str AndShowImageView:(UIButton *)aBtn
{
    /*
     *缓存图片原理, 三级缓存
     */
    NSString *md5Str=[str md5];
    
    NSData *imgData=[imgChaceDic objectForKey:md5Str];

    if(imgData){
        
        UIImage *img=[[UIImage alloc]initWithData:imgData];
        
        [aBtn setImage:img forState:UIControlStateNormal];
    }
    
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    
    [self imgFileDataLocationSettingWithPath:paths];
    
    NSString *path=[NSString stringWithFormat:@"%@/%@",paths,md5Str];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        
        UIImage *img=[[UIImage alloc]initWithContentsOfFile:path];
        
        [aBtn setImage:img forState:UIControlStateNormal];
        
        [imgChaceDic setValue:UIImagePNGRepresentation(img) forKey:@"md5Str"];
    }else{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:str]];
            
            UIImage *img=[[UIImage alloc]initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [aBtn setImage:img forState:UIControlStateNormal];
                
                [imgChaceDic setValue:UIImagePNGRepresentation(img) forKey:@"md5Str"];
                
                NSData *imgData=UIImagePNGRepresentation(img);
                
                [imgData writeToFile:path atomically:YES];
            });
        });
    }
}

//处理缓存路径
-(void)imgFileDataLocationSettingWithPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path]){
        
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    

}

//清理沙盒中的图片缓存
-(void)clearNetImageChace
{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:paths]){
        [fileManager removeItemAtPath:paths error:nil];
    }
    
    [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
}

@end





