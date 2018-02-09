#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZHAddCodeType) {
    ZHAddCodeType_Implementation=0,
    ZHAddCodeType_end_last=1,
    ZHAddCodeType_Interface=2,
    ZHAddCodeType_Import=3,
    ZHAddCodeType_InsertFunction=4,
    ZHAddCodeType_Delegate
};

@interface ZHStoryboardTextManager : NSObject
/**为View打上所有标识符(默认顺序) 包括(为所有view的id打上标识符,对应的标识符就是CustomClass)*/
+ (NSString *)addCustomClassToAllViews:(NSString *)text;
/**判断是否是特殊控件*/
+ (BOOL)isTableViewOrCollectionView:(NSString *)text;
/**获取所有view的个数*/
+ (NSInteger)getAllViewCount;

+ (BOOL)isTableView:(NSString *)text;
+ (BOOL)isCollectionView:(NSString *)text;
+ (NSInteger)getTableViewCount:(NSArray *)views;
+ (NSInteger)getCollectionViewCount:(NSArray *)views;

+ (NSArray *)getTableView:(NSArray *)views;
+ (NSArray *)getCollectionView:(NSArray *)views;

+ (BOOL)hasSuffixNumber:(NSString *)text;
+ (NSString *)removeSuffixNumber:(NSString *)text;

/**获取属性Code*/
+ (NSString *)getPropertyWithViewName:(NSString *)viewName withViewCategory:(NSString *)viewCategory;

/**获取创建某个view的代码*/
+ (NSString *)getCreateViewCodeWithViewName:(NSString *)viewName withViewCategoryName:(NSString *)viewCategoryName addToFatherView:(NSString *)fatherView withDoneArrM:(NSMutableArray *)doneArrM;

+ (NSString *)getFatherView:(NSString *)view inViewRelationShipDic:(NSDictionary *)viewRelationShipDic;

/**创建约束代码*/
+ (NSString *)getCreatConstraintCodeWithViewName:(NSString *)viewName withConstraintDic:(NSDictionary *)constraintDic isCell:(BOOL)isCell withDoneArrM:(NSMutableArray *)doneArrM  withCustomAndNameDic:(NSDictionary *)customAndNameDic addToFatherView:(NSString *)fatherView;

+ (void)addCodeText:(NSString *)code andInsertType:(ZHAddCodeType)insertType toStrM:(NSMutableString *)strM insertFunction:(NSString *)insertFunction;

/**添加代理*/
+ (void)addDelegateTableViewToText:(NSMutableString *)text;
+ (void)addDelegateCollectionViewToText:(NSMutableString *)text;

+ (void)addDelegateFunctionToText:(NSMutableString *)text withTableViews:(NSDictionary *)tableViewsDic isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView;
+ (void)addDelegateFunctionToText:(NSMutableString *)text withCollectionViews:(NSDictionary *)collectionViewsDic isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView;

+ (void)done;

@end