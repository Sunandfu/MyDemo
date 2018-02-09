//
//  SDRefresh.h
//  SDRefreshView
//
//  Created by aier on 15-2-27.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 {
 SDRefreshFooterView *_refreshFooter;
 SDRefreshHeaderView *_refreshHeader;
 }
 上拉加载
 *******************************************************

 __weak typeof(self) weakSelf = self;
 
 // 上拉加载
 _refreshFooter = [SDRefreshFooterView refreshView];
 [_refreshFooter addToScrollView:self.tableView];
 __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
 _refreshFooter.beginRefreshingOperation = ^() {
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 //一秒后异步执行下面代码
 weakSelf.rowCount += 10;
 [weakSelf.tableView reloadData];
 [weakRefreshFooter endRefreshing];
 });
 };
 
 下拉刷新
 *******************************************************
 _refreshHeader = [SDRefreshHeaderView refreshView];
 [_refreshHeader addToScrollView:self.tableView];
 __weak typeof(_refreshHeader) weakRefreshHeader = _refreshHeader;
 _refreshHeader.beginRefreshingOperation = ^(){
 [weakRefreshHeader endRefreshing];
 };
 */

#import "SDRefreshHeaderView.h"
#import "SDRefreshFooterView.h"
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com