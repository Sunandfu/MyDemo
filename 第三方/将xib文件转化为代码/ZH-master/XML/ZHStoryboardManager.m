#import "ZHStoryboardManager.h"
#import "ZHStoryboardXMLManager.h"
#import "ZHStoryboardTextManager.h"
#import "ZHStroyBoardFileManager.h"

#import "ZHFileManager.h"

@interface ZHStoryboardManager ()
@property (nonatomic,assign)NSInteger viewCount;

@property (nonatomic,strong)NSDictionary *customAndId;
@property (nonatomic,strong)NSDictionary *customAndName;
@end

@implementation ZHStoryboardManager
- (void)StroyBoard_To_Masonry:(NSString *)stroyBoard{
    _viewCount=0;
    NSLog(@"%@",@"开始");
    
    NSString *filePath=stroyBoard;
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return;
    }
    
    NSString *mainPath=[ZHFileManager getFilePathRemoveFileName:filePath];
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[ZHStoryboardTextManager addCustomClassToAllViews:context];
//    [context writeToFile:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViewControllers=[ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的ViewController名字
    NSArray *viewControllers=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
    
    for (NSString *viewController in viewControllers) {
        //创建MVC文件夹
        [ZHStroyBoardFileManager creat_MVC_WithViewControllerName:viewController];
        //创建对应的ViewController文件
        [ZHStroyBoardFileManager creat_m_h_file:viewController isModel:NO isView:NO isController:YES isTableView:YES isCollectionView:NO forViewController:viewController];
    }
    
    //获取所有View的CustomClass与对应的id
    NSDictionary *customAndId=[ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndId=customAndId;
    //获取所有View的CustomClass与对应的真实控件类型名字
    NSDictionary *customAndName=[ZHStoryboardXMLManager getAllViewCustomAndNameWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndName=customAndName;
    
    //开始操作所有ViewController
    for (NSDictionary *dic in allViewControllers) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                
                NSString *viewControllerFileName=[viewController stringByAppendingString:viewController];//对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                //先创建所有cell文件
                NSArray *allTableViewCells=[ZHStoryboardXMLManager getAllTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *tableViewCell in allTableViewCells) {
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManager creat_m_h_file:tableViewCell isModel:NO isView:YES isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                    //创建对应的Model文件
                    [ZHStroyBoardFileManager creat_m_h_file:tableViewCell isModel:YES isView:NO isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                }
                
                NSArray *allCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *collectionViewCell in allCollectionViewCells) {
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManager creat_m_h_file:collectionViewCell isModel:NO isView:YES isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                    //创建对应的Model文件
                    [ZHStroyBoardFileManager creat_m_h_file:collectionViewCell isModel:YES isView:NO isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                }
                
                
                //获取这个ViewController的所有tableView ,其中每个tableView都对应其所有的tableViewCell
                NSDictionary *tableViewCellDic=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                //                NSLog(@"**tableViewCellDic=%@",tableViewCellDic);
                //获取这个ViewController的所有tableViewCell
                NSMutableArray *tableViewCells=[NSMutableArray array];
                for (NSString *tableView in tableViewCellDic) {
                    NSArray *cells=tableViewCellDic[tableView];
                    for (NSString *cell in cells) {
                        if ([tableViewCells containsObject:cell]==NO) {
                            [tableViewCells addObject:cell];
                        }
                    }
                }
                
                //获取这个ViewController的所有collectionView ,其中每个collectionView都对应其所有的collectionViewCell
                NSDictionary *collectionViewCellDic=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                //                NSLog(@"------collectionViewCellDic=%@",collectionViewCellDic);
                //获取这个ViewController的所有collectionViewCell
                NSMutableArray *collectionViewCells=[NSMutableArray array];
                for (NSString *collectionView in collectionViewCellDic) {
                    NSArray *cells=collectionViewCellDic[collectionView];
                    for (NSString *cell in cells) {
                        if ([collectionViewCells containsObject:cell]==NO) {
                            [collectionViewCells addObject:cell];
                        }
                    }
                }
                
                //插入#import
                for (NSString *tableViewCell in tableViewCells) {
                    [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                for (NSString *collectionViewCell in collectionViewCells) {
                    [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                //插入属性property
                NSArray *views=[ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                //                NSLog(@"%@\n\n\n\n",views);
                _viewCount+=views.count;
                
                //获取特殊的View --- >self.view
                [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:@"self.view" withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    
//                    if ([idStr hasPrefix:@"tableView"]||[idStr hasPrefix:@"collectionView"]) {
//                        continue;
//                    }
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                    
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=[ZHStoryboardTextManager getPropertyWithViewName:customAndId[idStr] withViewCategory:customAndName[idStr]];
                    
                    if (property.length>0) {
                        [ZHStoryboardTextManager addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [ZHStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n"];
                for (NSString *idStr in views) {
                    NSString *fatherView=[ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    NSString *creatCode=[ZHStoryboardTextManager getCreateViewCodeWithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] addToFatherView:fatherView withDoneArrM:brotherOrderArrM];
                    [creatCodeStrM appendString:creatCode];
                    
                    //创建约束
                    NSString *constraintCode=[ZHStoryboardTextManager getCreatConstraintCodeWithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView];
                    [creatCodeStrM appendString:constraintCode];
                }
                [creatCodeStrM appendString:@"}\n"];
                
                [ZHStoryboardTextManager addCodeText:creatCodeStrM andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                
                //                NSLog(@"%@",creatCodeStrM);
                //                NSLog(@"viewConstraintDicM_Self=%@",viewConstraintDicM_Self_NEW);
                
                
                //再添加代码
                if(tableViewCellDic.count>0&&collectionViewCellDic.count>0){
                    
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[ZHStoryboardTextManager getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"%@",@"筛选没有筛选完");
                    }
                    NSInteger collectionViewCount_new=[ZHStoryboardTextManager getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"%@",@"筛选没有筛选完");
                    }
                    
                    //添加代理方法
                    [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO];
                    [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO];
                }
                else if (tableViewCellDic.count>0){
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[ZHStoryboardTextManager getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"%@",@"筛选没有筛选完");
                    }
                    
                    if (tableViewCount==1) {
                        //添加代理方法
                        [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:YES];
                    }else{
                        //添加代理方法
                        [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO];
                    }
                    
                }else if (collectionViewCellDic.count>0){
                    
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger collectionViewCount_new=[ZHStoryboardTextManager getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"%@",@"筛选没有筛选完");
                    }
                    
                    if (collectionViewCount==1) {
                        //添加代理方法
                        [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:YES];
                    }else{
                        //添加代理方法
                        [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO];
                    }
                }
            }
            
            
            NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            
            [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
            [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        }
    }
    
    NSInteger count=0;
    
    count=[ZHStoryboardTextManager getAllViewCount];
    //    NSLog(@"count=%ld",count);
    
    //删除副本故事版StroyBoard
    [[NSFileManager defaultManager]removeItemAtPath:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] error:nil];
    
    //这句话一定要加
    [ZHStroyBoardFileManager done];
    [ZHStoryboardTextManager done];
    
    customAndId=nil;
    customAndName=nil;
    xml=nil;
    
    NSLog(@"%@",@"结束");//时间花销 0.6s
    NSLog(@"%ld",_viewCount);
}
- (void)Xib_To_MasonryForView:(NSString *)xib{
    _viewCount=0;
    
    NSString *filePath=xib;
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return;
    }
    
    NSString *mainPath=[ZHFileManager getFilePathRemoveFileName:filePath];
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[ZHStoryboardTextManager addCustomClassToAllViews:context];
    
//    [context writeToFile:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViews=[ZHStoryboardXMLManager getAllViewWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的ViewController名字
    NSArray *views=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViews];
    
    for (NSString *view in views) {
        //创建MVC文件夹
        [ZHStroyBoardFileManager creat_V_WithViewName_XIB:view];
        //创建对应的View文件
        [ZHStroyBoardFileManager creat_m_h_file_XIB:view forView:view];
    }
    
    //获取所有View的CustomClass与对应的id
    NSDictionary *customAndId=[ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewArrM_XIB:allViews andXMLHandel:xml];
    self.customAndId=customAndId;
    //获取所有View的CustomClass与对应的真实控件类型名字
    NSDictionary *customAndName=[ZHStoryboardXMLManager getAllViewCustomAndNameWithAllViewArrM_XIB:allViews andXMLHandel:xml];
    self.customAndName=customAndName;
    
    //开始操作所有View
    for (NSDictionary *dic in allViews) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                NSString *viewControllerFileName=[viewController stringByAppendingString:viewController];//对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                //插入属性property
                NSArray *views;
                if ([viewController hasSuffix:@"TableViewCell"]||[viewController hasSuffix:@"CollectionViewCell"]) {
                    views=[ZHStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                }
                else views=[ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                _viewCount+=views.count;
                
                //获取特殊的View --- >self.view
                [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:viewController withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                    
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=[ZHStoryboardTextManager getPropertyWithViewName:customAndId[idStr] withViewCategory:customAndName[idStr]];
                    
                    if (property.length>0) {
                        [ZHStoryboardTextManager addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [ZHStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                [brotherOrderArrM addObject:viewController];
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n"];
                for (NSString *idStr in views) {
                    NSString *fatherView=[ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    NSString *creatCode=[ZHStoryboardTextManager getCreateViewCodeWithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] addToFatherView:fatherView withDoneArrM:brotherOrderArrM];
                    [creatCodeStrM appendString:creatCode];
                    
                    //创建约束
                    NSString *constraintCode=[ZHStoryboardTextManager getCreatConstraintCodeWithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView];
                    [creatCodeStrM appendString:constraintCode];
                }
                [creatCodeStrM appendString:@"}\n"];
                
                //对creatCodeStrM进行替换
                NSString *creatCodeStrM_new=[creatCodeStrM stringByReplacingOccurrencesOfString:viewController withString:@"self"];
                creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.view." withString:@"self."];
                creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.view " withString:@"self "];
                
                [ZHStoryboardTextManager addCodeText:creatCodeStrM_new andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                
            }
        }
    }
    
    NSInteger count=0;
    
    count=[ZHStoryboardTextManager getAllViewCount];
    //    NSLog(@"count=%ld",count);
    
    //删除副本故事版StroyBoard
    [[NSFileManager defaultManager]removeItemAtPath:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] error:nil];
    
    //这句话一定要加
    [ZHStroyBoardFileManager done];
    [ZHStoryboardTextManager done];
    xml=nil;
}
- (void)Xib_To_MasonryForTableViewCell:(NSString *)xib{
    _viewCount=0;
    
    NSString *filePath=xib;
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return;
    }
    
    NSString *mainPath=[ZHFileManager getFilePathRemoveFileName:filePath];
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[ZHStoryboardTextManager addCustomClassToAllViews:context];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViews=[ZHStoryboardXMLManager getAllViewWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的ViewController名字
    NSArray *views=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViews];
    
    for (NSString *view in views) {
        //创建MVC文件夹
        [ZHStroyBoardFileManager creat_V_WithViewName_XIB:view];
        //创建对应的View文件
        [ZHStroyBoardFileManager creat_m_h_file_XIB:view forView:view];
    }
    
    //获取所有View的CustomClass与对应的id
    NSDictionary *customAndId=[ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewArrM_XIB:allViews andXMLHandel:xml];
    self.customAndId=customAndId;
    //获取所有View的CustomClass与对应的真实控件类型名字
    NSDictionary *customAndName=[ZHStoryboardXMLManager getAllViewCustomAndNameWithAllViewArrM_XIB:allViews andXMLHandel:xml];
    self.customAndName=customAndName;
    
    //开始操作所有View
    for (NSDictionary *dic in allViews) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                NSString *viewControllerFileName=[viewController stringByAppendingString:viewController];//对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                //插入属性property
                NSArray *views=[ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                _viewCount+=views.count;
                
                //获取特殊的View --- >self.view
                [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:viewController withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                    
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=[ZHStoryboardTextManager getPropertyWithViewName:customAndId[idStr] withViewCategory:customAndName[idStr]];
                    
                    if (property.length>0) {
                        [ZHStoryboardTextManager addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [ZHStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                [brotherOrderArrM addObject:viewController];
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n"];
                for (NSString *idStr in views) {
                    NSString *fatherView=[ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    NSString *creatCode=[ZHStoryboardTextManager getCreateViewCodeWithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] addToFatherView:fatherView withDoneArrM:brotherOrderArrM];
                    [creatCodeStrM appendString:creatCode];
                    
                    //创建约束
                    NSString *constraintCode=[ZHStoryboardTextManager getCreatConstraintCodeWithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView];
                    [creatCodeStrM appendString:constraintCode];
                }
                [creatCodeStrM appendString:@"}\n"];
                
                //对creatCodeStrM进行替换
                NSString *creatCodeStrM_new=[creatCodeStrM stringByReplacingOccurrencesOfString:viewController withString:@"self"];
                creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.view." withString:@"self."];
                creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.view " withString:@"self "];
                
                [ZHStoryboardTextManager addCodeText:creatCodeStrM_new andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                
            }
        }
    }
    
    NSInteger count=0;
    
    count=[ZHStoryboardTextManager getAllViewCount];
    
    //删除副本故事版StroyBoard
    [[NSFileManager defaultManager]removeItemAtPath:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] error:nil];
    
    //这句话一定要加
    [ZHStroyBoardFileManager done];
    [ZHStoryboardTextManager done];
    xml=nil;
}
- (void)Xib_To_Masonry:(NSString *)xib{
    //先生成ViewController,因为XIB里面也可能有ViewController
    
    [self StroyBoard_To_Masonry:xib];
    
    [self Xib_To_MasonryForView:xib];
}
- (void)detailSubCells:(NSArray *)subCells andXMLHandel:(ReadXML *)xml withFatherViewController:(NSString *)viewController{
    for (NSDictionary *subDic in subCells) {
        
        NSString *fatherCellName=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
        NSString *NewFileName=[viewController stringByAppendingString:fatherCellName];
        
        //给.h文件添加refreshUI的方法
        //先导入model头文件
        [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        //再添加refreshUI方法
        [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"- (void)refreshUI:(%@ *)dataModel;",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //给.m文件添加refreshUI
        [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"\n- (void)refreshUI:(%@ *)dataModel{\n\
                                              \n\
                                              }",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        
        NSDictionary *subTableViewCells=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subTableViewCells.count>0) {
            //插入#import
            for (NSString *tableViewName in subTableViewCells) {
                NSArray *tableViewCells=subTableViewCells[tableViewName];
                for (NSString *tableViewCell in tableViewCells) {
                    [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        NSDictionary *subCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subCollectionViewCells.count>0) {
            for (NSString *collectionViewName in subCollectionViewCells) {
                NSArray *collectionViewCells=subCollectionViewCells[collectionViewName];
                for (NSString *collectionViewCell in collectionViewCells) {
                    [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        //插入属性property
        NSArray *views=[ZHStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:subDic andXMLHandel:xml];
        
        //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
        NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
        NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
        
        //                NSLog(@"%@\n\n\n\n",views);
        _viewCount+=views.count;
        
        //获取特殊的View --- >self.view
        [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:fatherCellName withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        
        
        for (NSString *idStr in views) {
            
//            if ([idStr hasPrefix:@"tableView"]||[idStr hasPrefix:@"collectionView"]) {
//                continue;
//            }
            
            //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
            [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
            
            //这里获取的属性不包括特殊控件,比如tableView,collectionView
            NSString *property=[ZHStoryboardTextManager getPropertyWithViewName:self.customAndId[idStr] withViewCategory:self.customAndName[idStr]];
            
            if (property.length>0) {
                [ZHStoryboardTextManager addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
        }
        
        
        NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
        NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        
        //在这里插入所有view的创建和约束
        
        //开始建立一个父子和兄弟关系的链表
        NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
        [ZHStoryboardXMLManager createRelationShipWithControllerDic:subDic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:YES];
        
        
        //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
        NSMutableArray *brotherOrderArrM=[NSMutableArray array];
        
        //1.首先开始创建控件  从父亲的subViews开始
        NSMutableString *creatCodeStrM=[NSMutableString string];
        [creatCodeStrM appendString:@"- (void)addSubViews{\n"];
        for (NSString *idStr in views) {
            NSString *fatherView=[ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
            NSString *creatCode=[ZHStoryboardTextManager getCreateViewCodeWithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] addToFatherView:fatherView withDoneArrM:brotherOrderArrM];
            [creatCodeStrM appendString:creatCode];
            
            //创建约束
            NSString *constraintCode=[ZHStoryboardTextManager getCreatConstraintCodeWithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW isCell:YES withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView];
            [creatCodeStrM appendString:constraintCode];
        }
        [creatCodeStrM appendString:@"}"];
        [ZHStoryboardTextManager addCodeText:creatCodeStrM andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //                NSLog(@"%@",creatCodeStrM);
        //        NSLog(@"viewConstraintDicM_Self=%@",viewConstraintDicM_Self_NEW);
        
        
        //再添加代码
        if(subTableViewCells.count>0&&subCollectionViewCells.count>0){
            
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger tableViewCount_new=[ZHStoryboardTextManager getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            NSInteger collectionViewCount_new=[ZHStoryboardTextManager getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            //添加代理方法
            [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO];
            [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO];
        }
        else if (subTableViewCells.count>0){
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            
            NSInteger tableViewCount_new=[ZHStoryboardTextManager getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (tableViewCount==1) {
                //添加代理方法
                [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:YES];
            }else{
                //添加代理方法
                [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO];
            }
            
        }else if (subCollectionViewCells.count>0){
            
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger collectionViewCount_new=[ZHStoryboardTextManager getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (collectionViewCount==1) {
                //添加代理方法
                [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:YES];
            }else{
                //添加代理方法
                [ZHStoryboardTextManager addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO];
            }
        }
        NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
    }
}
@end