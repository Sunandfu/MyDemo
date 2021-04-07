//
//Created by ESJsonFormatForMac on 20/07/13.
//

#import <Foundation/Foundation.h>

@class SFJsonCatelogModelRows;
@interface SFJsonCatelogModel : NSObject

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, copy) NSString *bookId;

@end
@interface SFJsonCatelogModelRows : NSObject

@property (nonatomic, copy) NSString *serialUniqID;

@property (nonatomic, assign) NSInteger isFree;

@property (nonatomic, copy) NSString *serialID;

@property (nonatomic, copy) NSString *serialName;

@end

