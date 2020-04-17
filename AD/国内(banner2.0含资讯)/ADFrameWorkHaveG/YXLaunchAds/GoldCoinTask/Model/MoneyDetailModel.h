//
//Created by ESJsonFormatForMac on 19/08/13.
//

#import <Foundation/Foundation.h>

@class MoneyDetailModelData,MoneyDetailModelRecords;
@interface MoneyDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MoneyDetailModelData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface MoneyDetailModelData : NSObject

@property (nonatomic, assign) NSInteger has_more;

@property (nonatomic, assign) NSInteger income_all;

@property (nonatomic, strong) NSArray *records;

@property (nonatomic, assign) NSInteger income_today;

@property (nonatomic, copy) NSString *tips;

@end

@interface MoneyDetailModelRecords : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *Desc;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger type;

@end

