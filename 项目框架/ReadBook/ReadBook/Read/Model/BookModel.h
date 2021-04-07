//
//  Post.h
//  ParseHtmlDemo
//
//  Created by pi on 16/4/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UtilsMacro.h"

@interface BookModel : NSObject

//数据库索引ID
@property (nonatomic,assign) NSInteger ID;
@property (copy,nonatomic) NSString *bookIcon;//书籍配图
@property (copy,nonatomic) NSString *bookTitle;//书名
@property (copy,nonatomic) NSString *bookAuthor;//作者
@property (copy,nonatomic) NSString *bookSynopsis;//简介
@property (copy,nonatomic) NSString *bookDate;//阅读日期
@property (copy,nonatomic) NSString *bookUrl;//书详情链接
@property (copy,nonatomic) NSString *bookNumber;//书籍编号
@property (nonatomic, assign) NSInteger bookIndex;//当前阅读章节下标
@property (nonatomic, assign) NSInteger bookPage;//当前阅读页数下标
@property (nonatomic, assign) float pageOffset;//当前阅读章节内容偏移位

@property (copy,nonatomic) NSString *bookCatalog;//书籍目录xpath
@property (copy,nonatomic) NSString *bookContent;//书籍正文xpath
@property (nonatomic,assign) NSInteger bookDelegate;//多余的数据

@property (copy,nonatomic) NSString *other1;//备用1
@property (copy,nonatomic) NSString *other2;//备用2
@property (nonatomic, assign) float other3;//备用3

@property (nonatomic, assign) NSInteger bookNewCount;//当前目录数

@end

@interface BookDetailModel : NSObject

@property (copy,nonatomic) NSString *title;//章节标题
@property (copy,nonatomic) NSString *postUrl;//章节标题链接

@property (copy,nonatomic) NSString *content;//章节详情
@property (copy,nonatomic) NSAttributedString *attrText;//章节详情

@property (nonatomic, assign) NSInteger height;//章节高度
@property (nonatomic, copy  ) NSString *textColor;

//@property (nonatomic, strong) NSMutableArray *pageDatas;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger chapter;
@property (nonatomic, assign) SFTransitionStyle transitionStyle;

@end
