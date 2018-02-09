//
//  QNCrc.m
//  QiniuSDK
//
//  Created by bailong on 14-9-29.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <zlib.h>

#import "QNCrc32.h"
#import "QNConfig.h"

@implementation QNCrc32

+ (UInt32)data:(NSData *)data {
	uLong crc = crc32(0L, Z_NULL, 0);

	crc = crc32(crc, [data bytes], (uInt)[data length]);
	return (UInt32)crc;
}

+ (UInt32)file:(NSString *)filePath
         error:(NSError **)error {
	@autoreleasepool {
		NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:error];
		if (*error != nil) {
			return 0;
		}

		int len = (int)[data length];
		int count = (len + kQNBlockSize - 1) / kQNBlockSize;

		uLong crc = crc32(0L, Z_NULL, 0);
		for (int i = 0; i < count; i++) {
			int offset = i * kQNBlockSize;
			int size = (len - offset) > kQNBlockSize ? kQNBlockSize : (len - offset);
			NSData *d = [data subdataWithRange:NSMakeRange(offset, (unsigned int)size)];
			crc = crc32(crc, [d bytes], (uInt)[d length]);
		}
		return (UInt32)crc;
	}
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com