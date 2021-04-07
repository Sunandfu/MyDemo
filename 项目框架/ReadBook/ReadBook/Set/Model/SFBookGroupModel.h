//
//  SFBookGroupModel.h
//  ReadBook
//
//  Created by lurich on 2020/11/9.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBookGroupModel : NSObject

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *name;//文件名
@property (nonatomic,copy) NSString *createTime;//阅读时间

@property (copy,nonatomic) NSString *other1;//备用1
@property (copy,nonatomic) NSString *other2;//备用2
@property (nonatomic, assign) float other3;//备用3

@end

NS_ASSUME_NONNULL_END
