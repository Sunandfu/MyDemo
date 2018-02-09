#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface ReadXML : NSObject
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign)int cur;//解析XML到数组时需要用到的遍历数组的全局游标
@property (nonatomic,assign)int arr_cur;//保存到树形结构时需要用到的遍历数组的全局游标
@property (nonatomic,strong)TreeNode *TNode;

- (void)initWithXMLFilePath:(NSString *)filePath;
- (void)initWithXMLString:(NSString *)str;
- (BOOL)XML_TO_Plist:(NSString *)path1 :(NSString*)path2;
- (TreeNode *)rootElement;
- (TreeNode *)getIdForPath:(TreeNode *)T :(NSArray *)arr :(int)n;
- (NSArray *)nodesForAbsoluteAddressXPath:(NSString *)xpath;
- (NSArray *)nodesForRelativeAddressWithTreeNode:(TreeNode *)T XPath:(NSString *)xpath;

//获取某个节点的所有孩子节点
- (NSArray *)children:(TreeNode *)T;
//取出某个节点的孩子节点
- (NSArray *)elementsForName:(TreeNode *)T :(NSString *)name;
//取出某个节点属性值
- (NSString *)attributeForName:(TreeNode *)T :(NSString *)name;
//取出某个节点的Value值
- (NSString *)stringValue:(TreeNode *)T;
//获取某个节点的孩子个数
- (NSUInteger)childCount:(TreeNode *)T;


/**将树转换成字典*/
- (NSDictionary *)TreeToDict:(TreeNode *)T;
- (NSInteger)countOfTargetNodeWithName:(NSString *)name withDic:(NSDictionary *)dic withCount:(NSInteger)count;
- (void)getTargetNodeArrWithName:(NSString *)name withDic:(NSDictionary *)dic withtargetKey:(NSString *)key withArrM:(NSMutableArray *)ArrM;
/**获取某个路径链表下的第一个节点*/
- (NSDictionary *)getDicFormPathArr:(NSArray *)paths withIndex:(NSInteger)index withDic:(NSDictionary *)dic;
/**获取某个路径链表下的所有节点*/
- (NSDictionary *)getDicArrFormPathArr:(NSArray *)paths withIndex:(NSInteger)index withDic:(NSDictionary *)dic addToArrM:(NSMutableArray *)arrM;
- (NSDictionary *)getDicWithCondition:(NSDictionary *)condition withDic:(NSDictionary *)dic;
- (void)getTargetNodeArrWithName:(NSString *)name withDic:(NSDictionary *)dic withArrM:(NSMutableArray *)ArrM;
/**获取指定路径下目标节点数组(也就是说,所有目标节点) 查询根据,不是具体的路径,而是某个节点中的属性值*/
- (void)getTargetNodeArrWithKeyName:(NSString *)keyName andKeyValue:(NSString *)keyValue withDic:(NSDictionary *)dic withArrM:(NSMutableArray *)ArrM;
/**获取指定路径下目标节点数组(中间不包括,某些节点)(也就是说,所有目标节点)*/
- (void)getTargetNodeArrWithName:(NSString *)name withDic:(NSDictionary *)dic withArrM:(NSMutableArray *)ArrM notContain:(NSArray *)path withSuccess:(BOOL)success;

/**获取子节点*/
- (NSArray *)childDic:(NSDictionary *)dic;
/**获取当前节点的名字*/
- (NSString *)dicNodeName:(NSDictionary *)dic;
/**获取当前节点指定的值*/
- (NSString *)dicNodeValueWithKey:(NSString *)key ForDic:(NSDictionary *)dic;
- (BOOL)checkNodeValue:(id)value;
@end