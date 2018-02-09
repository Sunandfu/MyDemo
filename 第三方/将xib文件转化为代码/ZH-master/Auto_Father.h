//
//  Auto_Father.h
//  代码助手
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 com/qianfeng/mac. All rights reserved.
//

#import "CreatFatherFile.h"

typedef void (^ZHFun)(NSMutableString *strM);

@interface Auto_Father : CreatFatherFile
+ (void)tableViewDelegateAndDataSource:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock;
+ (void)tableViewCanEditRowAtIndexPath:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock;
+ (void)viewDidLoad:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock;
+ (void)interfaceViewController:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock ViewControllerName:(NSString *)ref;
+ (void)requestData:(NSMutableString *)strM;
+ (void)sortArrByChineseNames:(NSMutableString *)strM;
@end