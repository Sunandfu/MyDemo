#import <Foundation/Foundation.h>

@interface propertyNode : NSObject
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *value;
@property (nonatomic,strong) propertyNode *next;
@end