//  THPlayer
//
//  Created by inveno on 16/3/22.
//  Copyright © 2016年 inveno. All rights reserved.
//


#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (MJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (MJRefresh)

#pragma mark - header
static const char MJRefreshHeaderKey = '\0';
- (void)setMj_header:(MJRefreshHeader *)mj_header
{
    if (mj_header != self.mj_header) {
        // 删除旧的，添加新的
        [self.mj_header removeFromSuperview];
        [self insertSubview:mj_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"mj_header"]; // KVO
        objc_setAssociatedObject(self, &MJRefreshHeaderKey,
                                 mj_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mj_header"]; // KVO
    }
}

- (MJRefreshHeader *)mj_header
{
    return objc_getAssociatedObject(self, &MJRefreshHeaderKey);
}

#pragma mark - footer
static const char MJRefreshFooterKey = '\0';
- (void)setMj_footer:(MJRefreshFooter *)mj_footer
{
    if (mj_footer != self.mj_footer) {
        // 删除旧的，添加新的
        [self.mj_footer removeFromSuperview];
        [self addSubview:mj_footer];
        
        // 存储新的
        [self willChangeValueForKey:@"mj_footer"]; // KVO
        objc_setAssociatedObject(self, &MJRefreshFooterKey,
                                 mj_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mj_footer"]; // KVO
    }
}

- (MJRefreshFooter *)mj_footer
{
    return objc_getAssociatedObject(self, &MJRefreshFooterKey);
}

#pragma mark - 过期
- (void)setFooter:(MJRefreshFooter *)footer
{
    self.mj_footer = footer;
}

- (MJRefreshFooter *)footer
{
    return self.mj_footer;
}

- (void)setHeader:(MJRefreshHeader *)header
{
    self.mj_header = header;
}

- (MJRefreshHeader *)header
{
    return self.mj_header;
}

#pragma mark - other
- (NSInteger)mj_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char MJRefreshReloadDataBlockKey = '\0';
- (void)setMj_reloadDataBlock:(void (^)(NSInteger))mj_reloadDataBlock
{
    [self willChangeValueForKey:@"mj_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &MJRefreshReloadDataBlockKey, mj_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"mj_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))mj_reloadDataBlock
{
    return objc_getAssociatedObject(self, &MJRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.mj_reloadDataBlock ? : self.mj_reloadDataBlock(self.mj_totalDataCount);
}
@end

@implementation UITableView (MJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (MJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}
@end
 // 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com