//
//  Auto_Father.m
//  代码助手
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 com/qianfeng/mac. All rights reserved.
//

#import "Auto_Father.h"

@implementation Auto_Father
+ (void)tableViewDelegateAndDataSource:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock{
    [strM appendString:@"self.tableView.delegate=self;\nself.tableView.dataSource=self;"];
    if (codeBlock)codeBlock(strM);
}
+ (void)tableViewCanEditRowAtIndexPath:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock{
    [self insertValueAndNewlines:@[@"/**是否可以编辑*/\n- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{\nif (indexPath.row==self.dataArr.count) {\nreturn NO;\n}\nreturn YES;"] ToStrM:strM];
    if (codeBlock)codeBlock(strM);
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:strM];
}
+ (void)tableViewEditingStyleForRowAtIndexPath:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock{
    [self insertValueAndNewlines:@[@"/**编辑风格*/\n- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{\nreturn UITableViewCellEditingStyleDelete;"] ToStrM:strM];
    if (codeBlock)codeBlock(strM);
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:strM];
}
+ (void)tableViewEditActionsForRowAtIndexPath:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock{
    [self insertValueAndNewlines:@[@"/**设置编辑的控件  删除,置顶,收藏*/\n- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n//设置删除按钮\n\
                                   UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@\"删除\" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {\n\
                                   [self.dataArr removeObjectAtIndex:indexPath.row];\n\
                                   [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:\(UITableViewRowAnimationAutomatic)];\n\
                                   }];\nreturn  @[deleteRowAction];\n"] ToStrM:strM];
    if (codeBlock)codeBlock(strM);
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:strM];
}

+ (void)viewDidLoad:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock{
    [strM appendString:@"- (void)viewDidLoad{\n[super viewDidLoad];\n"];
    if (codeBlock) {
        codeBlock(strM);
    }
    [strM appendString:@"}"];
}
+ (void)interfaceViewController:(NSMutableString *)strM codeBlock:(ZHFun)codeBlock ViewControllerName:(NSString *)ref{
    
    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@ViewController : UIViewController",ref]] ToStrM:strM];
    if (codeBlock!=nil) {
        codeBlock(strM);
    }
    [self insertValueAndNewlines:@[@"",@"@end",@""] ToStrM:strM];
}

+ (void)requestData:(NSMutableString *)strM{
    [self insertValueAndNewlines:@[@"- (void)requestData{\n\
                                   \n\
                                   //解析数据\n\
                                   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];\n\
                                   \n\
                                   [manager GET:@\"URL\" parameters:@{@\"p\":[NSString stringWithFormat:@\"%ld\",self.page]} success:^(AFHTTPRequestOperation *operation, id responseObject) {\n\
                                   \n\
                                   <#Model#> *model=[<#Model#> new];\n\
                                   [model setValuesForKeysWithDictionary:responseObject];\n\
                                   \n\
                                   if(self.page==1){\n\
                                   [self.dataArr removeAllObjects];\n\
                                   }\n\
                                   \n\
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {\n\
                                   NSLog(@\"网络出错\");\n\
                                   }];\n\
                                   }",@"\n//检查网络状态\n- (void)updateInternetStatus\n\
                                   {\n\
                                   AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];\n\
                                   [manager startMonitoring];\n\
                                   [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {\n\
                                   if (status == AFNetworkReachabilityStatusNotReachable) {\n\
                                   \n\
                                   }else{\n\
                                   //请求数据\n\
                                   [self requestData];\n\
                                   }\n\
                                   }];\n\
                                   }"] ToStrM:strM];
}
+ (void)sortArrByChineseNames:(NSMutableString *)strM{
    //进行排序
    [self insertValueAndNewlines:@[@"- (NSMutableArray *)sortArrByChineseNames:(NSMutableArray *)arrM{\n\
                                   \n\
                                   NSMutableDictionary *ArrSortHelpDictionary=[NSMutableDictionary dictionary];\n\
                                   [arrM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {\n\
                                   \n\
                                   ContactModel *model1=obj1;\n\
                                   ContactModel *model2=obj2;\n\
                                   \n\
                                   NSString *pinyin1,*pinyin2;\n\
                                   \n\
                                   if (ArrSortHelpDictionary[model1.name]==nil) {\n\
                                   \n\
                                   pinyin1=[[[TranslaterChineseCharactersToPinyin translaterChineseCharactersToPinyin:model1.name]uppercaseString]stringByReplacingOccurrencesOfString:@\" \" withString:@\"\"];\n\
                                   \n\
                                   [ArrSortHelpDictionary setValue:pinyin1 forKey:model1.name];\n\
                                   }else{\n\
                                   \n\
                                   pinyin1=ArrSortHelpDictionary[model1.name];\n\
                                   \n\
                                   }\n\
                                   \n\
                                   if (ArrSortHelpDictionary[model2.name]==nil) {\n\
                                   \n\
                                   pinyin2=[[[TranslaterChineseCharactersToPinyin translaterChineseCharactersToPinyin:model2.name]uppercaseString]stringByReplacingOccurrencesOfString:@\" \" withString:@\"\"];\n\
                                   \n\
                                   [ArrSortHelpDictionary setValue:pinyin2 forKey:model2.name];\n\
                                   \n\
                                   }else{\n\
                                   \n\
                                   pinyin2=ArrSortHelpDictionary[model2.name];\n\
                                   \n\
                                   }\n\
                                   \n\
                                   if ([pinyin1 compare:pinyin2 options:NSCaseInsensitiveSearch]==NSOrderedAscending) {\n\
                                   return NO;\n\
                                   }\n\
                                   return YES;\n\
                                   }];\n\
                                   \n\
                                   return [NSMutableArray arrayWithArray:[self groupArrByChineseNames:arrM withArrSortHelpDictionary:ArrSortHelpDictionary]];\n\
                                   \n\
                                   }\n\
                                   \n\
                                   - (NSMutableArray *)groupArrByChineseNames:(NSMutableArray *)arrM withArrSortHelpDictionary:(NSDictionary *)ArrSortHelpDictionary{\n\
                                   \n\
                                   NSMutableArray *tempArrM=[NSMutableArray array];\n\
                                   NSMutableArray *subArrM=[NSMutableArray array];\n\
                                   NSString *firstLetter=@\"用第一个字母进行排序\";\n\
                                   \n\
                                   for (ContactModel *model in arrM) {\n\
                                   \n\
                                   NSString *pinyin;\n\
                                   \n\
                                   if (ArrSortHelpDictionary[model.name]!=nil) {\n\
                                   \n\
                                   pinyin=ArrSortHelpDictionary[model.name];\n\
                                   \n\
                                   }else{\n\
                                   \n\
                                   pinyin=[[[TranslaterChineseCharactersToPinyin translaterChineseCharactersToPinyin:model.name]uppercaseString]stringByReplacingOccurrencesOfString:@\" \" withString:@\"\"];\n\
                                   \n\
                                   }\n\
                                   if (pinyin.length>0) {\n\
                                   \n\
                                   unichar ch=[pinyin characterAtIndex:0];\n\
                                   NSString *tempStr=[NSString stringWithFormat:@\"%C\",ch];\n\
                                   \n\
                                   if ([tempStr isEqualToString:firstLetter]) {\n\
                                   [subArrM addObject:model];\n\
                                   if ([arrM indexOfObject:model]==arrM.count-1) {\n\
                                   [tempArrM addObject:subArrM];\n\
                                   }\n\
                                   }else{\n\
                                   if (subArrM.count>0) {\n\
                                   [tempArrM addObject:subArrM];\n\
                                   }\n\
                                   subArrM=[NSMutableArray array];\n\
                                   [subArrM addObject:model];\n\
                                   if ([arrM indexOfObject:model]==arrM.count-1) {\n\
                                   [tempArrM addObject:subArrM];\n\
                                   }\n\
                                   \n\
                                   firstLetter=[tempStr copy];\n\
                                   if ([firstLetter isEqualToString:@\"_\"]) {\n\
                                   \n\
                                   [self.sectionDataArr addObject:@\"＊\"];\n\
                                   \n\
                                   }else\n\
                                   [self.sectionDataArr addObject:[firstLetter copy]];\n\
                                   }\n\
                                   }\n\
                                   }\n\
                                   \n\
                                   return tempArrM;\n\
                                   }\n"] ToStrM:strM];
}
@end