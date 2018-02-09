#import <Foundation/Foundation.h>
#import "ReadXML.h"
#import "ZHNSString.h"
@interface ZHStoryboardXMLManager : NSObject
/**获取所有的ViewController*/
+ (NSArray *)getAllViewControllerWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml;

/**获取XIB所有的View*/
+ (NSArray *)getAllViewWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController所有的tableViewCell*/
+ (NSArray *)getAllTableViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController所有的tableViewCell*/
+ (NSDictionary *)getAllTableViewAndTableViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController所有的tableViewCell (里面存放的是字典) 不包括嵌套*/
+ (NSArray *)getTableViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController所有的collectionViewCell*/
+ (NSArray *)getAllCollectionViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController所有的collectionViewCell*/
+ (NSMutableDictionary *)getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController所有的collectionViewCell数组(里面存放的是字典) 不包括嵌套*/
+ (NSArray *)getCollectionViewCellNamesWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取ViewController所有的打上了标志符的名字,也就是对应.m的文件名*/
+ (NSArray *)getViewControllerCountNamesWithAllViewControllerArrM:(NSArray *)arrM;

/**获取所有View的CustomClass与对应的id */
+ (NSDictionary *)getAllViewCustomAndIdWithAllViewControllerArrM:(NSArray *)arrM andXMLHandel:(ReadXML *)xml;
+ (NSDictionary *)getAllViewCustomAndIdWithAllViewArrM_XIB:(NSArray *)arrM andXMLHandel:(ReadXML *)xml;

/**获取所有View的CustomClass与对应的控件真名*/
+ (NSDictionary *)getAllViewCustomAndNameWithAllViewControllerArrM:(NSArray *)arrM andXMLHandel:(ReadXML *)xml;
+ (NSDictionary *)getAllViewCustomAndNameWithAllViewArrM_XIB:(NSArray *)arrM andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController 的 view.subviews 不包括view.subviews的子View*/
+ (NSArray *)getViewControllerSubViewsWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个ViewController 的 view.subviews 包括view.subviews的子View*/
+ (NSArray *)getAllViewControllerSubViewsWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取某个tableViewCell 和collectionViewCell 的 view.subviews 包括view.subviews的子View  不包括tableViewCell 和collectionViewCell的子view*/
+ (NSArray *)getAllCellSubViewsWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取所有ViewController 的 TableViewCell.subviews  格式TableViewCell,id */
+ (NSDictionary *)getTableViewCellSubViewsIdWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取所有ViewController 的 CollectionViewCell.subviews  格式 CollectionViewCell,id */
+ (NSDictionary *)getCollectionViewCellSubViewsIdWithViewControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml;

/**获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束*/
+ (void)getViewAllConstraintWithControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml withViewIdStr:(NSString *)viewIdStr withSelfConstraintDicM:(NSMutableDictionary *)selfConstraintDicM withOtherConstraintDicM:(NSMutableDictionary *)otherConstraintDicM;

/**重新调整控件的约束*/
+ (void)reAdjustViewAllConstraintWithNewSelfConstraintDicM:(NSMutableDictionary *)newSelfConstraintDicM withNewOtherConstraintDicM:(NSMutableDictionary *)newOtherConstraintDicM withXMLHandel:(ReadXML *)xml;
+ (void)reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:(NSMutableDictionary *)newSelfConstraintDicM withNewOtherConstraintDicM:(NSMutableDictionary *)newOtherConstraintDicM withXMLHandel:(ReadXML *)xml;
+ (void)reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:(NSMutableDictionary *)newSelfConstraintDicM withNewOtherConstraintDicM:(NSMutableDictionary *)newOtherConstraintDicM withXMLHandel:(ReadXML *)xml;

/**建立一个父子和兄弟关系的链表*/
+ (void)createRelationShipWithControllerDic:(NSDictionary *)dic andXMLHandel:(ReadXML *)xml WithViews:(NSMutableArray *)views withRelationShipDic:(NSMutableDictionary *)relationShipDicM isCell:(BOOL)isCell;




/**获取所有ViewController 的 self.view.subviews  格式 ViewController,CustomClass,id */
+ (NSDictionary *)getViewControllerSubViewsIdAndViewNameWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml withCustomClassDicM:(NSMutableArray *)CustomClassArrM;

/**获取所有ViewController 的 TableViewCell.subviews  格式 ViewController,TableViewCell,CustomClass,id */
+ (NSDictionary *)getTableViewCellSubViewsIdAndViewNameWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml withCustomClassDicM:(NSMutableArray *)CustomClassArrM;

/**获取所有ViewController 的 CollectionViewCell.subviews  格式 ViewController,CollectionViewCell,CustomClass,id */
+ (NSDictionary *)getCollectionViewCellSubViewsIdAndViewNameWithDic:(NSDictionary *)MyDic andXMLHandel:(ReadXML *)xml withCustomClassDicM:(NSMutableArray *)CustomClassArrM;
@end