//
//  QNAsyncRun.m
//  QiniuSDK
//
//  Created by bailong on 14/10/17.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAsyncRun.h"

void QNAsyncRun(QNRun run) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
		run();
	});
}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com