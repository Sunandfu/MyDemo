#import "ZHStoryboardXMLManager.h"


@implementation ZHStoryboardXMLManager

/**获取所有的ViewController*/
+ (NSArray *)getAllViewControllerWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml{
    NSMutableArray *arrM=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"viewController" withDic:MyDic withArrM:arrM];
    return arrM;
}

/**获取XIB所有的View*/
+ (NSArray *)getAllViewWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml{
    //先找到tableView
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"view" withDic:MyDic withArrM:arrMSub notContain:@[@"view"] withSuccess:NO];
    [xml getTargetNodeArrWithName:@"tableViewCell" withDic:MyDic withArrM:arrMSub notContain:@[@"view",@"tableViewCell"] withSuccess:NO];
    [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:MyDic withArrM:arrMSub notContain:@[@"view",@"collectionViewCell"] withSuccess:NO];
    return arrMSub;
}

/**获取ViewController所有的打上了标志符的名字,也就是对应.m的文件名*/
+ (NSArray *)getViewControllerCountNamesWithAllViewControllerArrM:(NSArray *)arrM{
    NSMutableArray *arrMName=[NSMutableArray array];
    
    for (NSDictionary *dic in arrM) {
        if(dic[@"customClass"]!=nil)
           [arrMName addObject:dic[@"customClass"]];
    }
//    NSLog(@"所有的ViewController:%@",arrMName);
    return arrMName;
}

/**获取某个ViewController所有的tableViewCell*/
+ (NSArray *)getAllTableViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"tableViewCell" withDic:tempDic withArrM:arrMSub];
    
    for (NSDictionary *dicSub in arrMSub) {
        NSString *customClassTableViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        if ([arrM containsObject:customClassTableViewCell]==NO) {
            [arrM addObject:customClassTableViewCell];
        }
    }
//    [self getAllTableViewCellNamesWithConditionDic:tempDic andXMLHandel:xml toArrM:arrM];
    
    return arrM;
}
/**获取某个ViewController所有的tableViewCell*/
+ (NSDictionary *)getAllTableViewAndTableViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    //先找到tableView
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"tableView" withDic:tempDic withArrM:arrMSub notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
    
    for (NSDictionary *dicSub in arrMSub) {
        
        NSString *customClassTableView=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        
        NSMutableArray *tableViewCells=[NSMutableArray array];
        
        //继续获取这个TableView的TableViewCell
        NSMutableArray *arrMSubNew=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"tableViewCell" withDic:dicSub withArrM:arrMSubNew  notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
        for (NSDictionary *dicSubNew in arrMSubNew) {
            
            NSString *customClassTableViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSubNew];
            
            if ([tableViewCells containsObject:customClassTableViewCell]==NO) {
                [tableViewCells addObject:customClassTableViewCell];
            }
        }
        
        if ([[dicM allKeys] containsObject:customClassTableView]==NO) {
            [dicM setValue:tableViewCells forKey:customClassTableView];
        }
    }
    return dicM;
}
/**获取某个ViewController所有的tableViewCell (里面存放的是字典) 不包括嵌套*/
+ (NSArray *)getTableViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    //先找到tableView
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"tableView" withDic:tempDic withArrM:arrMSub notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
    
    for (NSDictionary *dicSub in arrMSub) {
        
        NSMutableArray *tableViewCells=[NSMutableArray array];
        
        //继续获取这个TableView的TableViewCell
        NSMutableArray *arrMSubNew=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"tableViewCell" withDic:dicSub withArrM:arrMSubNew  notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
        for (NSDictionary *dicSubNew in arrMSubNew) {
            
            NSString *customClassTableViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSubNew];
            if ([tableViewCells containsObject:customClassTableViewCell]==NO) {
                [tableViewCells addObject:customClassTableViewCell];
                [arrM addObject:dicSubNew];
            }
        }
    }
    return arrM;
}

/**递归获取某个ViewController所有的tableViewCell*/
//+ (NSArray *)getAllTableViewCellNamesWithConditionDic:(NSDictionary *)tempDic andXMLHandel:(ReadXML *)xml toArrM:(NSMutableArray *)arrM{
//    if (arrM==nil) {
//        arrM=[NSMutableArray array];
//    }
//    
//    NSMutableArray *arrMSub=[NSMutableArray array];
//    [xml getTargetNodeArrWithName:@"tableViewCell" withDic:tempDic withArrM:arrMSub];
//    
//    for (NSDictionary *dicSub in arrMSub) {
//        NSString *customClassTableViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
//        if ([arrM containsObject:customClassTableViewCell]==NO) {
//            [arrM addObject:customClassTableViewCell];
//        }
//        NSArray *childArr=[xml childDic:dicSub];
//        if (childArr!=nil) {
//            for (id obj in childArr) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    [self getAllTableViewCellNamesWithConditionDic:obj andXMLHandel:xml toArrM:arrM];
//                }
//            }
//        }
//    }
//    
//    return arrM;
//}

/**获取某个ViewController所有的collectionViewCell*/
+ (NSArray *)getAllCollectionViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:tempDic withArrM:arrMSub];
    
    for (NSDictionary *dicSub in arrMSub) {
        NSString *customClassCollectionViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        if ([arrM containsObject:customClassCollectionViewCell]==NO) {
            [arrM addObject:customClassCollectionViewCell];
        }
    }
//    [self getAllCollectionViewCellNamesWithConditionDic:tempDic andXMLHandel:xml toArrM:arrM];
    return arrM;
}

/**获取某个ViewController所有的collectionViewCell 不包括嵌套*/
+ (NSMutableDictionary *)getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{

    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    //先找到collectionView
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"collectionView" withDic:tempDic withArrM:arrMSub notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
    
    for (NSDictionary *dicSub in arrMSub) {
        
        NSString *customClassCollectionView=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        
        NSMutableArray *collectionViewCells=[NSMutableArray array];
        
        //继续获取这个TableView的TableViewCell
        NSMutableArray *arrMSubNew=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:dicSub withArrM:arrMSubNew notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
        for (NSDictionary *dicSubNew in arrMSubNew) {
            
            NSString *customClassCollectionViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSubNew];
            
            if ([collectionViewCells containsObject:customClassCollectionViewCell]==NO) {
                [collectionViewCells addObject:customClassCollectionViewCell];
            }
        }
        
        if ([[dicM allKeys] containsObject:customClassCollectionView]==NO) {
            [dicM setValue:collectionViewCells forKey:customClassCollectionView];
        }
    }
    return dicM;
}

/**获取某个ViewController所有的collectionViewCell数组(里面存放的是字典) 不包括嵌套*/
+ (NSArray *)getCollectionViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    //先找到collectionView
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"collectionView" withDic:tempDic withArrM:arrMSub notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
    
    for (NSDictionary *dicSub in arrMSub) {
        
        NSString *customClassCollectionView=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        
        NSMutableArray *collectionViewCells=[NSMutableArray array];
        
        //继续获取这个TableView的TableViewCell
        NSMutableArray *arrMSubNew=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:dicSub withArrM:arrMSubNew notContain:@[@"tableView",@"collectionView"] withSuccess:NO];
        for (NSDictionary *dicSubNew in arrMSubNew) {
            
            NSString *customClassCollectionViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSubNew];
            
            if ([collectionViewCells containsObject:customClassCollectionViewCell]==NO) {
                [collectionViewCells addObject:customClassCollectionViewCell];
                [arrM addObject:dicSubNew];
            }
        }
    }
    return arrM;
}

/**递归获取某个ViewController所有的tableViewCell*/
//+ (NSArray *)getAllCollectionViewCellNamesWithConditionDic:(NSDictionary *)tempDic andXMLHandel:(ReadXML *)xml toArrM:(NSMutableArray *)arrM{
//    if (arrM==nil) {
//        arrM=[NSMutableArray array];
//    }
//    
//    NSMutableArray *arrMSub=[NSMutableArray array];
//    [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:tempDic withArrM:arrMSub];
//    
//    for (NSDictionary *dicSub in arrMSub) {
//        NSString *customClassCollectionViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
//        if ([arrM containsObject:customClassCollectionViewCell]==NO) {
//            [arrM addObject:customClassCollectionViewCell];
//        }
//        
//        NSArray *childArr=[xml childDic:dicSub];
//        if (childArr!=nil) {
//            for (id obj in childArr) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
////                    [self getAllCollectionViewCellNamesWithConditionDic:obj andXMLHandel:xml toArrM:arrM];
//                }
//            }
//        }
//    }
//    
//    return arrM;
//}

/**获取所有View的CustomClass与对应的id */
//+ (NSDictionary *)getAllViewCustomAndIdWithAllViewControllerArrM:(NSArray *)arrM andXMLHandel:(ReadXML *)xml{
//    
//    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
//    
//    for (NSDictionary *dic in arrM) {
//        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
//
//        NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:tempDic];
//        for (NSDictionary *subDic in [xml childDic:mySubDic]) {
//            if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]]) {
//                [dicM setValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic] forKey:[xml dicNodeValueWithKey:@"id" ForDic:subDic]];
//            }
//        }
//        
//        NSMutableArray *arrMSub=[NSMutableArray array];
//        [xml getTargetNodeArrWithName:@"tableViewCell" withDic:tempDic withArrM:arrMSub];
//        for (NSDictionary *dicSub in arrMSub) {
//            NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"tableViewCellContentView",@"subviews"] withIndex:0 withDic:dicSub];
//            
//            for (NSDictionary *subDicTemp in [xml childDic:mySubDic]) {
//                if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]]) {
//                    [dicM setValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp] forKey:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
//                }
//            }
//        }
//        
//        [arrMSub removeAllObjects];
//        [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:tempDic withArrM:arrMSub];
//        for (NSDictionary *dicSub in arrMSub) {
//            
//            NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:dicSub];
//            
//            for (NSDictionary *subDicTemp in [xml childDic:mySubDic]) {
//                
//                if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]]) {
//                    [dicM setValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp] forKey:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
//                }
//            }
//        }
//    }
//    return dicM;
//}

/**获取所有View的CustomClass与对应的id */
+ (NSDictionary *)getAllViewCustomAndIdWithAllViewControllerArrM:(NSArray *)arrM andXMLHandel:(ReadXML *)xml{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        
        
        NSMutableArray *allDic=[NSMutableArray array];
        [xml getDicArrFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:tempDic addToArrM:allDic];
        
        for (NSDictionary *subDic in allDic) {
            [self getAllViewCustomAndIdWithConditionDic:subDic andXMLHandel:xml toDicM:dicM];
        }
    }
    
    return dicM;
}
/**获取所有View的CustomClass与对应的id */
+ (NSDictionary *)getAllViewCustomAndIdWithAllViewArrM_XIB:(NSArray *)arrM andXMLHandel:(ReadXML *)xml{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        
        
        NSMutableArray *allDic=[NSMutableArray array];
        [xml getDicArrFormPathArr:@[@"subviews"] withIndex:0 withDic:tempDic addToArrM:allDic];
        
        for (NSDictionary *subDic in allDic) {
            [self getAllViewCustomAndIdWithConditionDic:subDic andXMLHandel:xml toDicM:dicM];
        }
    }
    
    return dicM;
}
/**嵌套获取所有View的CustomClass与对应的id*/
+ (void)getAllViewCustomAndIdWithConditionDic:(NSDictionary *)tempDic andXMLHandel:(ReadXML *)xml toDicM:(NSMutableDictionary *)dicM{
    
    if (dicM==nil) {
        dicM=[NSMutableDictionary dictionary];
    }
    
    for (NSDictionary *subDic in [xml childDic:tempDic]) {
        if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]]) {
            NSString *idStr=[xml dicNodeValueWithKey:@"id" ForDic:subDic];
            NSString *custom=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
            [dicM setValue:custom forKey:idStr];
        }
        //对每一个子view进行获取
        NSMutableArray *allDic=[NSMutableArray array];
        [xml getDicArrFormPathArr:@[@"subviews"] withIndex:0 withDic:subDic addToArrM:allDic];
        for (NSDictionary *subDic in allDic) {
            [self getAllViewCustomAndIdWithConditionDic:subDic andXMLHandel:xml toDicM:dicM];
        }
    }
}

/**获取所有View的CustomClass与对应的控件真名*/
+ (NSDictionary *)getAllViewCustomAndNameWithAllViewControllerArrM:(NSArray *)arrM andXMLHandel:(ReadXML *)xml{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        
        
        NSMutableArray *allDic=[NSMutableArray array];
        [xml getDicArrFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:tempDic addToArrM:allDic];
        
        for (NSDictionary *subDic in allDic) {
            [self getAllViewCustomAndNameWithConditionDic:subDic andXMLHandel:xml toDicM:dicM];
        }
    }
    
    return dicM;
}
/**获取所有View的CustomClass与对应的控件真名*/
+ (NSDictionary *)getAllViewCustomAndNameWithAllViewArrM_XIB:(NSArray *)arrM andXMLHandel:(ReadXML *)xml{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        
        
        NSMutableArray *allDic=[NSMutableArray array];
        [xml getDicArrFormPathArr:@[@"subviews"] withIndex:0 withDic:tempDic addToArrM:allDic];
        
        for (NSDictionary *subDic in allDic) {
            [self getAllViewCustomAndNameWithConditionDic:subDic andXMLHandel:xml toDicM:dicM];
        }
    }
    
    return dicM;
}
/**嵌套获取所有View的CustomClass与对应的控件真名*/
+ (void)getAllViewCustomAndNameWithConditionDic:(NSDictionary *)tempDic andXMLHandel:(ReadXML *)xml toDicM:(NSMutableDictionary *)dicM{
    
    if (dicM==nil) {
        dicM=[NSMutableDictionary dictionary];
    }
    
    for (NSDictionary *subDic in [xml childDic:tempDic]) {
        if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]]) {
            NSString *idStr=[xml dicNodeValueWithKey:@"id" ForDic:subDic];
            NSString *name=[xml dicNodeName:subDic];
            [dicM setValue:name forKey:idStr];
        }
        //对每一个子view进行获取
        NSMutableArray *allDic=[NSMutableArray array];
        [xml getDicArrFormPathArr:@[@"subviews"] withIndex:0 withDic:subDic addToArrM:allDic];
        for (NSDictionary *subDic in allDic) {
            [self getAllViewCustomAndNameWithConditionDic:subDic andXMLHandel:xml toDicM:dicM];
        }
    }
}

/**获取某个ViewController 的 view.subviews 不包括view.subviews的子View*/
+ (NSArray *)getViewControllerSubViewsWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableArray *ArrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:tempDic];
    
    for (NSDictionary *subDic in [xml childDic:mySubDic]) {
        if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]]) {
            [ArrM addObject:[xml dicNodeValueWithKey:@"id" ForDic:subDic]];
        }
    }
    return ArrM;
}

/**获取某个ViewController 的 view.subviews 包括view.subviews的子View  不包括tableViewCell 和collectionViewCell的子view*/
+ (NSArray *)getAllViewControllerSubViewsWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableArray *ArrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    
    NSMutableArray *allDic=[NSMutableArray array];
    [xml getDicArrFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:tempDic addToArrM:allDic];
    
    for (NSDictionary *subDic in allDic) {
        [self getAllViewControllerSubViewsWithConditionDic:subDic andXMLHandel:xml toArrM:ArrM];
    }
    
    return ArrM;
}
/**获取某个tableViewCell 和collectionViewCell 的 view.subviews 包括view.subviews的子View  不包括tableViewCell 和collectionViewCell的子view*/
+ (NSArray *)getAllCellSubViewsWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableArray *ArrM=[NSMutableArray array];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    
    NSMutableArray *allDic=[NSMutableArray array];
    [xml getDicArrFormPathArr:@[@"subviews"] withIndex:0 withDic:tempDic addToArrM:allDic];
    
    for (NSDictionary *subDic in allDic) {
        [self getAllViewControllerSubViewsWithConditionDic:subDic andXMLHandel:xml toArrM:ArrM];
    }
    
    return ArrM;
}

/**嵌套获取某个ViewController 的 view.subviews 包括view.subviews的子View*/
+ (NSArray *)getAllViewControllerSubViewsWithConditionDic:(NSDictionary *)tempDic andXMLHandel:(ReadXML *)xml toArrM:(NSMutableArray *)arrM{
    
    if (arrM==nil) {
        arrM=[NSMutableArray array];
    }
    
    for (NSDictionary *subDic in [xml childDic:tempDic]) {
        if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]]) {
            NSString *idStr=[xml dicNodeValueWithKey:@"id" ForDic:subDic];
            if ([arrM containsObject:idStr]==NO) {
                [arrM addObject:idStr];
            }
        }
        if ([[xml dicNodeName:subDic] isEqualToString:@"tableView"]==NO&&[[xml dicNodeName:subDic] isEqualToString:@"collectionView"]==NO) {
            //对每一个子view进行获取
            NSMutableArray *allDic=[NSMutableArray array];
            [xml getDicArrFormPathArr:@[@"subviews"] withIndex:0 withDic:subDic addToArrM:allDic];
            for (NSDictionary *subDic in allDic) {
                [self getAllViewControllerSubViewsWithConditionDic:subDic andXMLHandel:xml toArrM:arrM];
            }
        }
    }
    
    return arrM;
}


/**获取所有ViewController 的 TableViewCell.subviews  格式TableViewCell,id */
+ (NSDictionary *)getTableViewCellSubViewsIdWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"tableViewCell" withDic:tempDic withArrM:arrMSub];
    
    for (NSDictionary *dicSub in arrMSub) {
        NSString *customClassTableViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"tableViewCellContentView",@"subviews"] withIndex:0 withDic:dicSub];
        
        NSMutableArray *subArr=[NSMutableArray array];
        for (NSDictionary *subDicTemp in [xml childDic:mySubDic]) {
            if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]]) {
                [subArr addObject:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
            }
        }
        [dicM setValue:subArr forKey:customClassTableViewCell];
    }
    return dicM;
}

/**获取所有ViewController 的 CollectionViewCell.subviews  格式 CollectionViewCell,id */
+ (NSDictionary *)getCollectionViewCellSubViewsIdWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSMutableArray *arrMSub=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:tempDic withArrM:arrMSub];
    
    for (NSDictionary *dicSub in arrMSub) {
        NSString *customClassCollectionViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
        NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:dicSub];
        
        NSMutableArray *subArr=[NSMutableArray array];
        for (NSDictionary *subDicTemp in [xml childDic:mySubDic]) {
            
            if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]]) {
                
                [subArr addObject:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
            }
        }
        [dicM setValue:subArr forKey:customClassCollectionViewCell];
    }
    return dicM;
}

+ (void)getViewAllCanotUseConstraintWithControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml withViewIdStr:(NSString *)viewIdStr withCanoyUseConstraintArrM:(NSMutableArray *)CanoyUseConstraintArrM{
    if (CanoyUseConstraintArrM==nil) {
        CanoyUseConstraintArrM=[NSMutableArray array];
    }
    
    //找到具体控件的位置
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSMutableArray *allConstraints=[NSMutableArray array];
    //找到对应的节点 根据CustomClass找到的节点 如果CustomClass,就找id  因为有一个特殊的view 就是self.view
    [xml getTargetNodeArrWithKeyName:@"customClass" andKeyValue:viewIdStr withDic:tempDic withArrM:allConstraints];
    
    //开始抽取其中的约束值
    for (NSDictionary *dicConstraint in allConstraints) {//其实就只有一个,因为custom唯一
        
        NSMutableArray *arrMSub=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"variation" withDic:dicConstraint withArrM:arrMSub notContain:@[@"subviews"] withSuccess:NO];
        
        for (NSDictionary *dicSub in arrMSub) {//其实还是只有一个,因为每一个控件里面只有一个constraints
            NSMutableArray *ViewConstraints=[NSMutableArray array];
            [xml getTargetNodeArrWithName:@"exclude" withDic:dicSub withArrM:ViewConstraints notContain:nil withSuccess:NO];
            
            for (NSDictionary *unUseDic in ViewConstraints) {
                if ([xml dicNodeValueWithKey:@"reference" ForDic:unUseDic].length>0) {
                    [CanoyUseConstraintArrM addObject:[xml dicNodeValueWithKey:@"reference" ForDic:unUseDic]];
                }
            }
        }
    }
}

/**获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束*/
+ (void)getViewAllConstraintWithControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml withViewIdStr:(NSString *)viewIdStr withSelfConstraintDicM:(NSMutableDictionary *)selfConstraintDicM withOtherConstraintDicM:(NSMutableDictionary *)otherConstraintDicM{
    
    if (selfConstraintDicM==nil) {
        selfConstraintDicM=[NSMutableDictionary dictionary];
    }
    
    if (otherConstraintDicM==nil) {
        otherConstraintDicM=[NSMutableDictionary dictionary];
    }
    
    //首先获取所有约束,其实也不难,找到这个控件的位置,就可以找到对应的约束
    
    //在获取到约束之前,需要获取不可用的储备的约束
    
    NSMutableArray *CanoyUseConstraintArrM=[NSMutableArray array];
    [self getViewAllCanotUseConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:viewIdStr withCanoyUseConstraintArrM:CanoyUseConstraintArrM];
    
    //找到具体控件的位置
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    
    NSMutableArray *allConstraints=[NSMutableArray array];
    //找到对应的节点 根据CustomClass找到的节点 如果CustomClass,就找id  因为有一个特殊的view 就是self.view
    [xml getTargetNodeArrWithKeyName:@"customClass" andKeyValue:viewIdStr withDic:tempDic withArrM:allConstraints];
    
    //开始抽取其中的约束值
    for (NSDictionary *dicConstraint in allConstraints) {//其实就只有一个,因为custom唯一
        
        NSMutableArray *arrMSub=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"constraints" withDic:dicConstraint withArrM:arrMSub notContain:@[@"subviews"] withSuccess:NO];
        
        for (NSDictionary *dicSub in arrMSub) {//其实还是只有一个,因为每一个控件里面只有一个constraints
            NSMutableArray *ViewConstraints=[NSMutableArray array];
            [xml getTargetNodeArrWithName:@"constraint" withDic:dicSub withArrM:ViewConstraints notContain:nil withSuccess:NO];
            
            //开始挑选出自身的所有约束
            //开始挑选出关联对象的所有约束
            NSMutableArray *selfConstraints=[NSMutableArray array];
            NSMutableArray *otherConstraints=[NSMutableArray array];
            for (NSDictionary *checkDic in ViewConstraints) {
                if ([CanoyUseConstraintArrM containsObject:[xml dicNodeValueWithKey:@"id" ForDic:checkDic]]) {
                    continue;
                }
                
                if ([xml dicNodeValueWithKey:@"firstItem" ForDic:checkDic].length>0||[xml dicNodeValueWithKey:@"secondItem" ForDic:checkDic].length>0) {
                    if(viewIdStr.length>0&&[[xml dicNodeValueWithKey:@"firstItem" ForDic:checkDic] isEqualToString:viewIdStr]){
                        [selfConstraints addObject:checkDic];
                    }else
                        [otherConstraints addObject:checkDic];
                }else{
                    [selfConstraints addObject:checkDic];
                }
            }
            
            [selfConstraintDicM setValue:selfConstraints forKey:viewIdStr];
            [otherConstraintDicM setValue:otherConstraints forKey:viewIdStr];
            
        }
    }
}

/**重新调整控件的约束*/
+ (void)reAdjustViewAllConstraintWithNewSelfConstraintDicM:(NSMutableDictionary *)newSelfConstraintDicM withNewOtherConstraintDicM:(NSMutableDictionary *)newOtherConstraintDicM withXMLHandel:(ReadXML *)xml{
    
    for (NSString *view in newOtherConstraintDicM) {
        NSMutableArray *arrTemp=newOtherConstraintDicM[view];
        if (arrTemp.count>0) {
            for (NSInteger i=0; i<arrTemp.count; i++) {
                NSDictionary *subDic=arrTemp[i];
                NSString *firstItem=[xml dicNodeValueWithKey:@"firstItem" ForDic:subDic];
                if (firstItem.length>0&&[self isSystemIdStr:firstItem]==NO&&[firstItem isEqualToString:view]==NO) {
                    if ([self changeConstraintToDic:newSelfConstraintDicM withConstraint:subDic withViewName:firstItem]) {
                        [arrTemp removeObject:subDic];
                        i--;
                    }
                }
            }
        }
    }
}

+ (void)reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:(NSMutableDictionary *)newSelfConstraintDicM withNewOtherConstraintDicM:(NSMutableDictionary *)newOtherConstraintDicM withXMLHandel:(ReadXML *)xml{
    
    for (NSString *view in newOtherConstraintDicM) {
        NSMutableArray *arrTemp=newOtherConstraintDicM[view];
        if (arrTemp.count>0) {
            for (NSInteger i=0; i<arrTemp.count; i++) {
                NSDictionary *subDic=arrTemp[i];
                NSString *firstItem=[xml dicNodeValueWithKey:@"firstItem" ForDic:subDic];
                if (firstItem.length==0||[self isSystemIdStr:firstItem]==YES) {
                    NSString *secondItem=[xml dicNodeValueWithKey:@"secondItem" ForDic:subDic];
                    if (secondItem.length>0&&[self isSystemIdStr:secondItem]==NO&&[secondItem isEqualToString:view]==NO) {
                        if ([self changeConstraintToDic:newSelfConstraintDicM withConstraint:subDic withViewName:secondItem]) {
                            [arrTemp removeObject:subDic];
                            i--;
                        }
                    }
                }
            }
        }
    }
}

+ (void)reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:(NSMutableDictionary *)newSelfConstraintDicM withNewOtherConstraintDicM:(NSMutableDictionary *)newOtherConstraintDicM withXMLHandel:(ReadXML *)xml{
    
    for (NSString *view in newOtherConstraintDicM) {
        NSMutableArray *arrTemp=newOtherConstraintDicM[view];
        if (arrTemp.count>0) {
            for (NSInteger i=0; i<arrTemp.count; i++) {
                NSDictionary *subDic=arrTemp[i];
                NSString *firstItem=[xml dicNodeValueWithKey:@"firstItem" ForDic:subDic];
                if (firstItem.length==0||[self isSystemIdStr:firstItem]==YES) {
                    NSString *secondItem=[xml dicNodeValueWithKey:@"secondItem" ForDic:subDic];
                    if (secondItem.length>0&&[self isSystemIdStr:secondItem]==NO&&[secondItem isEqualToString:view]) {
                        if ([self changeConstraintToDic:newSelfConstraintDicM withConstraint:subDic withViewName:secondItem]) {
                            [arrTemp removeObject:subDic];
                            i--;
                        }
                    }
                }
            }
        }
    }
}

+ (BOOL)changeConstraintToDic:(NSMutableDictionary *)dic withConstraint:(NSDictionary *)constraintDic withViewName:(NSString *)viewName{
    
    NSArray *keys=[dic allKeys];
    for (NSInteger i=0; i<keys.count; i++) {
        NSString *key=keys[i];
        if ([key isEqualToString:viewName]) {
            NSMutableArray *arrM=dic[key];
            [arrM addObject:constraintDic];
            return YES;
        }
    }
    //发现没有这个属性
    [dic setValue:[NSMutableArray arrayWithObject:constraintDic] forKey:viewName];
    return YES;
}
/**判断是不是系统自动打上的标识符*/
+ (BOOL)isSystemIdStr:(NSString *)idStr{
    if (idStr.length==10) {
        unichar ch1,ch2;
        ch1=[idStr characterAtIndex:3];
        ch2=[idStr characterAtIndex:6];
        if (ch1=='-'&&ch2=='-') {
            return YES;
        }
    }
    return NO;
}

/**建立一个父子和兄弟关系的链表*/
+ (void)createRelationShipWithControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml WithViews:(NSMutableArray *)views withRelationShipDic:(NSMutableDictionary *)relationShipDicM isCell:(BOOL)isCell{
    if (relationShipDicM==nil) {
        relationShipDicM=[NSMutableDictionary dictionary];
    }
    
    NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
    //以self.view为最大的父亲 找到的子view 不包括嵌套
    NSMutableArray *arrMSubViews=[NSMutableArray array];
    
    [xml getTargetNodeArrWithName:@"subviews" withDic:tempDic withArrM:arrMSubViews notContain:@[@"subviews"] withSuccess:NO];
    
    NSMutableArray *subViewNames=[NSMutableArray array];
    
    for (NSDictionary *subViewDic in arrMSubViews) {//其实就只有一个,因为subviews只有一个
        
        NSArray *subViews=[xml childDic:subViewDic];
        
        for (NSDictionary *subDic in subViews) {
            NSString *dicName=[xml dicNodeName:subDic];
            if ([self isView:dicName].length>0) {
                
                NSString *customClass=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
                
                if (customClass.length>0&&[views containsObject:customClass]) {
                    [views removeObject:customClass];
                    [subViewNames addObject:customClass];
                    
                    [self recursiveCreateRelationShipWithDic:subDic andXMLHandel:xml WithViews:views withRelationShipDic:relationShipDicM withFatherViewName:customClass];
                }
            }
        }
        
    }
    
    if (subViewNames.count>0) {
        if (isCell) {
            [relationShipDicM setValue:subViewNames forKey:@"self.contentView"];
        }else
            [relationShipDicM setValue:subViewNames forKey:@"self.view"];
    }
}
/**嵌套建立一个父子和兄弟关系的链表*/
+ (void)recursiveCreateRelationShipWithDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml WithViews:(NSMutableArray *)views withRelationShipDic:(NSMutableDictionary *)relationShipDicM withFatherViewName:(NSString *)fatherViewName{
    
    //以self.view为最大的父亲 找到的子view 不包括嵌套
    NSMutableArray *arrMSubViews=[NSMutableArray array];
    
    [xml getTargetNodeArrWithName:@"subviews" withDic:dic withArrM:arrMSubViews notContain:@[@"subviews"] withSuccess:NO];
    
    NSMutableArray *subViewNames=[NSMutableArray array];
    
    for (NSDictionary *subViewDic in arrMSubViews) {//其实就只有一个,因为subviews只有一个
        
        NSArray *subViews=[xml childDic:subViewDic];
        
        for (NSDictionary *subDic in subViews) {
            NSString *dicName=[xml dicNodeName:subDic];
            if ([self isView:dicName].length>0) {
                
                NSString *customClass=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
                
                if (customClass.length>0&&[views containsObject:customClass]) {
                    [views removeObject:customClass];
                    [subViewNames addObject:customClass];
                    
                    [self recursiveCreateRelationShipWithDic:subDic andXMLHandel:xml WithViews:views withRelationShipDic:relationShipDicM withFatherViewName:customClass];
                }
            }
        }
        
    }
    
    if (subViewNames.count>0) {
        [relationShipDicM setValue:subViewNames forKey:fatherViewName];
    }
}

/**获取所有ViewController 的 self.view.subviews  格式 ViewController,CustomClass,id */
+ (NSDictionary *)getViewControllerSubViewsIdAndViewNameWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml withCustomClassDicM:(NSMutableArray *)CustomClassArrM{
    
    if (CustomClassArrM==nil) {
        CustomClassArrM=[NSMutableArray array];
    }
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    [xml getTargetNodeArrWithName:@"viewController" withDic:MyDic withArrM:arrM];
    
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        NSString *customClassViewController=[xml dicNodeValueWithKey:@"customClass" ForDic:dic];
        
        NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:tempDic];
        
        for (NSDictionary *subDic in [xml childDic:mySubDic]) {
            [dicM setValue:[customClassViewController stringByAppendingFormat:@"--%@",[xml dicNodeName:subDic]] forKey:[xml dicNodeValueWithKey:@"id" ForDic:subDic]];
            if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]]) {
                NSMutableArray *subArr=[NSMutableArray array];
                [subArr addObject:customClassViewController];
                [subArr addObject:[xml dicNodeValueWithKey:@"customClass" ForDic:subDic]];
                [subArr addObject:[xml dicNodeValueWithKey:@"id" ForDic:subDic]];
                [CustomClassArrM addObject:subArr];
//                NSLog(@"%@----%@:%@",subArr[0],subArr[1],subArr[2]);
            }
        }
    }
    return dicM;
}

/**获取所有ViewController 的 TableViewCell.subviews  格式 ViewController,TableViewCell,CustomClass,id */
+ (NSDictionary *)getTableViewCellSubViewsIdAndViewNameWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml withCustomClassDicM:(NSMutableArray *)CustomClassArrM{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    NSMutableArray *arrM=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"viewController" withDic:MyDic withArrM:arrM];
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        
        NSString *customClassViewController=[xml dicNodeValueWithKey:@"customClass" ForDic:dic];
        
        NSMutableArray *arrMSub=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"tableViewCell" withDic:tempDic withArrM:arrMSub];
        
        for (NSDictionary *dicSub in arrMSub) {
            NSString *customClassTableViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
            NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"tableViewCellContentView",@"subviews"] withIndex:0 withDic:dicSub];
            
            for (NSDictionary *subDicTemp in [xml childDic:mySubDic]) {
                [dicM setValue:[customClassViewController stringByAppendingFormat:@"--%@--%@",customClassTableViewCell,[xml dicNodeName:subDicTemp]] forKey:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
                if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]]) {
                    NSMutableArray *subArr=[NSMutableArray array];
                    [subArr addObject:customClassViewController];
                    [subArr addObject:customClassTableViewCell];
                    [subArr addObject:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]];
                    [subArr addObject:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
                    [CustomClassArrM addObject:subArr];
//                    NSLog(@"%@  %@  %@  %@",subArr[0],subArr[1],subArr[2],subArr[3]);
                }
            }
        }
    }
    return dicM;
}

/**获取所有ViewController 的 CollectionViewCell.subviews  格式 ViewController,CollectionViewCell,CustomClass,id */
+ (NSDictionary *)getCollectionViewCellSubViewsIdAndViewNameWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml withCustomClassDicM:(NSMutableArray *)CustomClassArrM{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    NSMutableArray *arrM=[NSMutableArray array];
    [xml getTargetNodeArrWithName:@"viewController" withDic:MyDic withArrM:arrM];
    for (NSDictionary *dic in arrM) {
        NSDictionary *tempDic=[xml getDicWithCondition:@{@"customClass":[xml dicNodeValueWithKey:@"customClass" ForDic:dic]} withDic:dic];
        
        NSString *customClassViewController=[xml dicNodeValueWithKey:@"customClass" ForDic:dic];
        
        NSMutableArray *arrMSub=[NSMutableArray array];
        [xml getTargetNodeArrWithName:@"collectionViewCell" withDic:tempDic withArrM:arrMSub];
        
        for (NSDictionary *dicSub in arrMSub) {
            NSString *customClassCollectionViewCell=[xml dicNodeValueWithKey:@"customClass" ForDic:dicSub];
            NSDictionary *mySubDic=[xml getDicFormPathArr:@[@"view",@"subviews"] withIndex:0 withDic:dicSub];
            
            for (NSDictionary *subDicTemp in [xml childDic:mySubDic]) {
                [dicM setValue:[customClassViewController stringByAppendingFormat:@"--%@--%@",customClassCollectionViewCell,[xml dicNodeName:subDicTemp]] forKey:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
                if ([xml checkNodeValue:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]]) {
                    NSMutableArray *subArr=[NSMutableArray array];
                    [subArr addObject:customClassViewController];
                    [subArr addObject:customClassCollectionViewCell];
                    [subArr addObject:[xml dicNodeValueWithKey:@"customClass" ForDic:subDicTemp]];
                    [subArr addObject:[xml dicNodeValueWithKey:@"id" ForDic:subDicTemp]];
                    [CustomClassArrM addObject:subArr];
//                    NSLog(@"%@  %@  %@  %@",subArr[0],subArr[1],subArr[2],subArr[3]);
                }
            }
        }
    }
    return dicM;
}

+ (NSString *)isView:(NSString *)text{
    
    NSMutableArray *viewsArr=[NSMutableArray array];
    [viewsArr addObject:@"label"];
    [viewsArr addObject:@"button"];
    [viewsArr addObject:@"imageView"];
    [viewsArr addObject:@"tableView"];
    [viewsArr addObject:@"tableViewCell"];
    [viewsArr addObject:@"collectionView"];
    [viewsArr addObject:@"collectionViewCell"];
    [viewsArr addObject:@"view"];
    [viewsArr addObject:@"segmentedControl"];
    [viewsArr addObject:@"textField"];
    [viewsArr addObject:@"slider"];
    [viewsArr addObject:@"switch"];
    [viewsArr addObject:@"activityIndicatorView"];
    [viewsArr addObject:@"progressView"];
    [viewsArr addObject:@"pageControl"];
    [viewsArr addObject:@"stepper"];
    [viewsArr addObject:@"textView"];
    [viewsArr addObject:@"scrollView"];
    [viewsArr addObject:@"datePicker"];
    [viewsArr addObject:@"pickerView"];
    [viewsArr addObject:@"mapView"];
    [viewsArr addObject:@"searchBar"];
    [viewsArr addObject:@"webView"];
    NSString *newStr;
    
    text=[ZHNSString removeSpaceBeforeAndAfterWithString:text];
    for (NSString *str in viewsArr) {
        if ([text hasPrefix:str]) {
            newStr=str;
            return newStr;
        }
    }
    
    return @"";
}
@end