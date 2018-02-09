#import "ZHStroyBoardFileManager.h"
#import "ZHWordWrap.h"

static NSMutableDictionary *ZHStroyBoardFileDicM;
static NSMutableDictionary *ZHStroyBoardContextDicM;
static NSString *MainDirectory;
@implementation ZHStroyBoardFileManager
+ (NSMutableDictionary *)defalutFileDicM{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardFileDicM==nil) {
            ZHStroyBoardFileDicM=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardFileDicM;
}
+ (NSMutableDictionary *)defalutContextDicM{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardContextDicM==nil) {
            ZHStroyBoardContextDicM=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardContextDicM;
}

+ (NSMutableString *)get_H_ContextByIdentity:(NSString *)identity{
    if ([identity hasSuffix:@".h"]==NO) {
        identity=[identity stringByAppendingString:@".h"];
    }
    NSString *filePath=[self defalutFileDicM][identity];
    id obj=[self defalutContextDicM][filePath];
    if ([obj isKindOfClass:[NSMutableString class]]) {
        return (NSMutableString *)obj;
    }
    NSLog(@"出现严重错误,字典保存的不是可变字符串");
    return nil;
}

+ (NSMutableString *)get_M_ContextByIdentity:(NSString *)identity{
    if ([identity hasSuffix:@".m"]==NO) {
        identity=[identity stringByAppendingString:@".m"];
    }
    NSString *filePath=[self defalutFileDicM][identity];
    id obj=[self defalutContextDicM][filePath];
    if ([obj isKindOfClass:[NSMutableString class]]) {
        return (NSMutableString *)obj;
    }
    NSLog(@"出现严重错误,字典保存的不是可变字符串");
    return nil;
}

+ (NSString *)getCurDateString{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    return [formatter stringFromDate:[NSDate date]];
}


+ (void)creatFileDirectory{
    NSString *fileDirectory=[self getCurDateString];
    fileDirectory = [fileDirectory stringByAppendingString:@"代码生成"];
    NSString *directory=NSHomeDirectory();
    if ([directory rangeOfString:@"/Library"].location!=NSNotFound) {
        directory=[directory substringToIndex:[directory rangeOfString:@"/Library"].location];
    }
    directory=[directory stringByAppendingPathComponent:@"Desktop"];
    directory=[directory stringByAppendingPathComponent:fileDirectory];
    [[NSFileManager defaultManager]createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    MainDirectory=directory;
}


+(void)done{
    //开始保存text到指定路径
    
    for (NSString *filePath in [self defalutContextDicM]) {
        NSMutableString *context=[self defalutContextDicM][filePath];
        context=[NSMutableString stringWithString:[[ZHWordWrap new] wordWrapText:context]];
        [context writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
//    NSLog(@"%@",[self defalutContextDicM]);
//    NSLog(@"%@",[self defalutFileDicM]);
    
    MainDirectory=nil;
    [ZHStroyBoardContextDicM removeAllObjects];
    [ZHStroyBoardFileDicM removeAllObjects];
}

+ (void)creat_m_h_file:(NSString *)fileName isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    if (MainDirectory.length<=0) {
        [self creat_MVC_WithViewControllerName:viewController];
    }
    NSString *directory=MainDirectory;
    directory=[directory stringByAppendingPathComponent:viewController];
    
    if (isModel) {
        [self creatOriginalModel_h:fileName isTableView:isTableView isCollectionView:isCollectionView forViewController:viewController];
        [self creatOriginalModel_m:fileName isTableView:isTableView isCollectionView:isCollectionView forViewController:viewController];
    }else if (isView){
        [self creatOriginalView_h:fileName isTableView:isTableView isCollectionView:isCollectionView forViewController:viewController];
        [self creatOriginalView_m:fileName isTableView:isTableView isCollectionView:isCollectionView forViewController:viewController];
    }else if (isController){
        [self creatOriginalViewController_h:fileName isTableView:isTableView isCollectionView:isCollectionView forViewController:viewController];
        [self creatOriginalViewController_m:fileName isTableView:isTableView isCollectionView:isCollectionView forViewController:viewController];
    }
}
+ (void)creat_m_h_file_XIB:(NSString *)fileName forView:(NSString *)view{
    if (MainDirectory.length<=0) {
        [self creat_V_WithViewName_XIB:view];
    }
    NSString *directory=MainDirectory;
    directory=[directory stringByAppendingPathComponent:view];
    
    [self creatOriginalView_h:fileName isTableView:NO isCollectionView:NO forViewController:view];
    [self creatOriginalView_m:fileName isTableView:NO isCollectionView:NO forViewController:view];
}
+ (void)creat_MVC_WithViewControllerName:(NSString *)ViewController{
    if (MainDirectory.length<=0) {
        [self creatFileDirectory];
    }
    NSString *directory=MainDirectory;
    directory=[directory stringByAppendingPathComponent:ViewController];
    [[NSFileManager defaultManager]createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    
    [[NSFileManager defaultManager]createDirectoryAtPath:[directory stringByAppendingPathComponent:@"model"] withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager]createDirectoryAtPath:[directory stringByAppendingPathComponent:@"view"] withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager]createDirectoryAtPath:[directory stringByAppendingPathComponent:@"controller"] withIntermediateDirectories:YES attributes:nil error:nil];
}
+ (void)creat_V_WithViewName_XIB:(NSString *)View{
    if (MainDirectory.length<=0) {
        [self creatFileDirectory];
    }
    NSString *directory=MainDirectory;
    directory=[directory stringByAppendingPathComponent:View];
    [[NSFileManager defaultManager]createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
}
+ (void)creatOriginalViewController_h:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n"] ToStrM:text];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@ : UIViewController\n",name],@"@end"] ToStrM:text];
    
    [self creatFileWithViewController:viewController name:name text:text isM:NO isModel:NO isView:NO isController:YES];
}
+ (void)creatOriginalViewController_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"@end\n",[NSString stringWithFormat:@"@implementation %@\n",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (void)viewDidLoad{\n\
                                   [super viewDidLoad];\n\
                                   [self addSubViews];\n\
                                   }\n\
                                   \n\
                                   - (void)didReceiveMemoryWarning {\n\
                                   [super didReceiveMemoryWarning];\n\
                                   }\n\
                                   @end"] ToStrM:text];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:NO isView:NO isController:YES];
}
+ (void)creatOriginalModel_h:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    
    if ([[name lowercaseString]hasSuffix:@"model"]==NO) {
        name=[name stringByAppendingString:@"Model"];
    }
    
    NSMutableString *text=[NSMutableString string];
    [text appendString:@"#import <UIKit/UIKit.h>\n"];
    if (isTableView) {
        name=[self getAdapterTableViewCellModelName:name];
        name=[name stringByAppendingString:@"TableViewCellModel"];
        [text appendFormat:@"@interface %@ : NSObject\n",name];
    }else if(isCollectionView){
        name=[self getAdapterCollectionViewCellModelName:name];
        name=[name stringByAppendingString:@"CollectionViewCellModel"];
        [text appendFormat:@"@interface %@ : NSObject\n",name];
    }else{
        [text appendFormat:@"@interface %@Model : NSObject\n",name];
    }
    
    [text appendString:@"@property (nonatomic,copy)NSString *iconImageName;\n\
    @property (nonatomic,assign)BOOL isSelect;\n\
    @property (nonatomic,assign)BOOL shouldShowImage;\n\
    @property (nonatomic,copy)NSString *name;\n\
    @property (nonatomic,copy)NSString *title;\n\
    @property (nonatomic,assign)CGFloat width;\n\
    @property (nonatomic,copy)NSString *autoWidthText;\n\
    @property (nonatomic,strong)NSMutableArray *dataArr;\n\
     @end"];
    
    [self creatFileWithViewController:viewController name:name text:text isM:NO isModel:YES isView:NO isController:NO];
}
+ (void)creatOriginalModel_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    
    if (isTableView) {
        name=[self getAdapterTableViewCellModelName:name];
        name=[name stringByAppendingString:@"TableViewCellModel"];
        [text appendFormat:@"#import \"%@.h\"\n\n",name];
        [text appendFormat:@"@implementation %@\n\n",name];
    }else if(isCollectionView){
        name=[self getAdapterCollectionViewCellModelName:name];
        name=[name stringByAppendingString:@"CollectionViewCellModel"];
        [text appendFormat:@"#import \"%@.h\"\n\n",name];
        [text appendFormat:@"@implementation %@\n\n",name];
    }else{
        [text appendFormat:@"#import \"%@Model.h\"\n\n",name];
        [text appendFormat:@"#implementation \"%@Model\n\n",name];
    }
    
    [text appendString:@"- (NSMutableArray *)dataArr{\n\
    if (!_dataArr) {\n\
    _dataArr=[NSMutableArray array];\n\
    }\n\
    return _dataArr;\n\
    }\n\
    - (void)setAutoWidthText:(NSString *)autoWidthText{\n\
    _autoWidthText=autoWidthText;\n\
    self.width=[autoWidthText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;\n\
    }\n\
    \n\
     @end"];
    
    name=[name stringByAppendingString:@"Model"];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:YES isView:NO isController:NO];
}
+ (void)creatOriginalView_h:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    if (isTableView) {
        name=[self getAdapterTableViewCellName:name];
        name=[name stringByAppendingString:@"TableViewCell"];
        [self creatOriginalTableViewCell_h:name forViewController:viewController];
    }else if (isCollectionView){
        name=[self getAdapterCollectionViewCellName:name];
        name=[name stringByAppendingString:@"CollectionViewCell"];
        [self creatOriginalCollectionViewCell_h:name forViewController:viewController];
    }else{
        [self creatOriginalView_h:name forView:viewController];
    }
}
+ (void)creatOriginalView_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    if (isTableView) {
        name=[self getAdapterTableViewCellName:name];
        name=[name stringByAppendingString:@"TableViewCell"];
        [self creatOriginalTableViewCell_m:name forViewController:viewController];
    }else if (isCollectionView){
        name=[self getAdapterCollectionViewCellName:name];
        name=[name stringByAppendingString:@"CollectionViewCell"];
        [self creatOriginalCollectionViewCell_m:name forViewController:viewController];
    }else{
        [self creatOriginalView_m:name forView:viewController];
    }
}
+ (void)creatOriginalTableViewCell_h:(NSString *)name forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];

    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n"] ToStrM:text];
    
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@ : UITableViewCell\n",name],@"@end"] ToStrM:text];
    
    [self creatFileWithViewController:viewController name:name text:text isM:NO isModel:NO isView:YES isController:NO];
}
+ (void)creatOriginalTableViewCell_m:(NSString *)name forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"@end",[NSString stringWithFormat:@"@implementation %@",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{\n\
                                   if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {\n\
                                   [self addSubViews];\n\
                                   }\n\
                                   return self;\n\
                                   }\n\
                                   \n\
                                   - (void)awakeFromNib {\n\
                                   [super awakeFromNib];\n\
                                   [self addSubViews];\n\
                                   }\n\
                                   \n\
                                   - (void)setSelected:(BOOL)selected animated:(BOOL)animated {\n\
                                   [super setSelected:selected animated:animated];\n\
                                   }\n\
                                   \n\
                                   @end"] ToStrM:text];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:NO isView:YES isController:NO];
}
+ (void)creatOriginalCollectionViewCell_h:(NSString *)name forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    
    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n"] ToStrM:text];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@ : UICollectionViewCell\n",name],@"@end"] ToStrM:text];
    
    [self creatFileWithViewController:viewController name:name text:text isM:NO isModel:NO isView:YES isController:NO];
}
+ (void)creatOriginalCollectionViewCell_m:(NSString *)name forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"@end",[NSString stringWithFormat:@"@implementation %@\n",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (instancetype)initWithFrame:(CGRect)frame{\n\
                                   if (self=[super initWithFrame:frame]) {\n\
                                   [self addSubViews];\n\
                                   }\n\
                                   return self;\n\
                                   }\n",@"@end"] ToStrM:text];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:NO isView:YES isController:NO];
}

+ (void)creatOriginalView_h:(NSString *)name forView:(NSString *)view{
    NSMutableString *text=[NSMutableString string];
    
    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n"] ToStrM:text];
    
    if ([name hasSuffix:@"TableViewCell"]) {
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@ : UITableViewCell\n",name],@"@end"] ToStrM:text];
    }else if([name hasSuffix:@"CollectionViewCell"]){
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@ : UICollectionViewCell\n",name],@"@end"] ToStrM:text];
    }else
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@ : UIView\n",name],@"@end"] ToStrM:text];
    
    [self creatFileWithViewController_XIB:view name:name text:text isM:NO isModel:NO isView:YES isController:NO];
}
+ (void)creatOriginalView_m:(NSString *)name forView:(NSString *)view{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"@end",[NSString stringWithFormat:@"@implementation %@\n",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (void)awakeFromNib {\n\
                                   [super awakeFromNib];\n\
                                   [self addSubViews];\n\
                                   }\n\n- (instancetype)initWithFrame:(CGRect)frame{\n\
                                   if (self=[super initWithFrame:frame]) {\n\
                                   [self addSubViews];\n\
                                   }\n\
                                   return self;\n\
                                   }\n",@"@end"] ToStrM:text];
    [self creatFileWithViewController_XIB:view name:name text:text isM:YES isModel:NO isView:YES isController:NO];
}

#pragma mark 辅助函数
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM{
    if (strM==nil) {
        strM=[NSMutableString string];
    }
    
    for (NSString  *str in values) {
        [strM appendFormat:@"%@\n",str];
    }
}
+ (void)creatFileWithViewController:(NSString *)viewController name:(NSString *)name text:(NSString *)text isM:(BOOL)isM isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController{
    NSString *directory=MainDirectory;
    directory=[directory stringByAppendingPathComponent:viewController];
    if (isModel) {
        directory=[directory stringByAppendingPathComponent:@"model"];
    }else if (isView){
        directory=[directory stringByAppendingPathComponent:@"view"];
    }else if (isController){
        directory=[directory stringByAppendingPathComponent:@"controller"];
    }
    directory=[directory stringByAppendingPathComponent:name];
    NSString *h_m;
    if (isM==NO) {
        h_m=@".h";
    }else{
        h_m=@".m";
    }
    
    directory=[directory stringByAppendingString:h_m];
    
    //最开始的做法,比较消耗性能
//    [[NSFileManager defaultManager]createFileAtPath:directory contents:nil attributes:nil];
//    [text writeToFile:directory atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [[ZHWordWrap new]wordWrap:directory];
//    [[self defalutContextDicM] setValue:[NSString stringWithContentsOfFile:directory encoding:NSUTF8StringEncoding error:nil] forKey:directory];
    
    //后面就做成不用创建文件,到最后一次性创建文件
//    text=[[ZHWordWrap new]wordWrapText:text];//为了便于ZHAddCode好寻找位置,这里先对其进行代码缩进处理
    [[self defalutContextDicM] setValue:[NSMutableString stringWithString:text] forKey:directory];

    [[self defalutFileDicM] setValue:directory forKey:[viewController stringByAppendingString:[name stringByAppendingString:h_m]]];
    
}

+ (void)creatFileWithViewController_XIB:(NSString *)view name:(NSString *)name text:(NSString *)text isM:(BOOL)isM isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController{
    NSString *directory=MainDirectory;
    directory=[directory stringByAppendingPathComponent:view];
    directory=[directory stringByAppendingPathComponent:name];
    NSString *h_m;
    if (isM==NO) {
        h_m=@".h";
    }else{
        h_m=@".m";
    }
    
    directory=[directory stringByAppendingString:h_m];
    [[self defalutContextDicM] setValue:[NSMutableString stringWithString:text] forKey:directory];
    
    [[self defalutFileDicM] setValue:directory forKey:[view stringByAppendingString:[name stringByAppendingString:h_m]]];
}

+ (NSString *)getAdapterTableViewCellName:(NSString *)name{
    
    if ([[name lowercaseString] hasSuffix:@"tableviewcell"]) {
        name=[name substringToIndex:name.length-@"tableviewcell".length];
    }
    else if ([[name lowercaseString] hasSuffix:@"cell"]) {
        name=[name substringToIndex:name.length-@"cell".length];
    }
    return name;
}
+ (NSString *)getAdapterTableViewCellModelName:(NSString *)name{
    if ([[name lowercaseString] hasSuffix:@"tableviewcellmodel"]) {
        name=[name substringToIndex:name.length-@"tableviewcellmodel".length];
    }
    if ([[name lowercaseString] hasSuffix:@"tabelviewcellmodel"]) {
        name=[name substringToIndex:name.length-@"tabelviewcellmodel".length];
    }
    if ([[name lowercaseString] hasSuffix:@"tableviewcell"]) {
        name=[name substringToIndex:name.length-@"tableviewcell".length];
    }
    if ([[name lowercaseString] hasSuffix:@"cellmodel"]) {
        name=[name substringToIndex:name.length-@"cellmodel".length];
    }
    if ([[name lowercaseString] hasSuffix:@"model"]) {
        name=[name substringToIndex:name.length-@"model".length];
    }
    return name;
}

+ (NSString *)getAdapterCollectionViewCellName:(NSString *)name{
    
    if ([[name lowercaseString] hasSuffix:@"collectionviewcell"]) {
        name=[name substringToIndex:name.length-@"collectionviewcell".length];
    }
    else if ([[name lowercaseString] hasSuffix:@"cell"]) {
        name=[name substringToIndex:name.length-@"cell".length];
    }
    return name;
}
+ (NSString *)getAdapterCollectionViewCellModelName:(NSString *)name{
    
    if ([[name lowercaseString] hasSuffix:@"collectionviewcellmodel"]) {
        name=[name substringToIndex:name.length-@"collectionviewcellmodel".length];
    }
    if ([[name lowercaseString] hasSuffix:@"collectionviewcell"]) {
        name=[name substringToIndex:name.length-@"collectionviewcell".length];
    }
    else if ([[name lowercaseString] hasSuffix:@"cellmodel"]) {
        name=[name substringToIndex:name.length-@"cellmodel".length];
    }
    else if ([[name lowercaseString] hasSuffix:@"model"]) {
        name=[name substringToIndex:name.length-@"model".length];
    }
    return name;
}
@end