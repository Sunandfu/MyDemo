#import <UIKit/UIKit.h>

@interface GetSBCellModel : NSObject
@property (nonatomic,copy)NSString *iconImageName;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)BOOL noFile;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *filePath;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,copy)NSString *autoWidthText;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end
