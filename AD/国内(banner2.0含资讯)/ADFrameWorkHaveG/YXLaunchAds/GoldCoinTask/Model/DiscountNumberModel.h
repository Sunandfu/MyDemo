//
//Created by ESJsonFormatForMac on 19/08/13.
//

#import <Foundation/Foundation.h>

@class DiscountNumberModelData,DiscountNumberModelRecords;
@interface DiscountNumberModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) DiscountNumberModelData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface DiscountNumberModelData : NSObject

@property (nonatomic, assign) NSInteger has_more;

@property (nonatomic, strong) NSArray *records;

@end

@interface DiscountNumberModelRecords : NSObject

@property (nonatomic, copy) NSString *use_time;

@property (nonatomic, assign) NSInteger cost;

@property (nonatomic, assign) NSInteger voucher_value;

@property (nonatomic, copy) NSString *expire_time;

@property (nonatomic, copy) NSString *voucher_desc;

@property (nonatomic, copy) NSString *voucher_name;

@property (nonatomic, copy) NSString *gettime;

@property (nonatomic, copy) NSString *voucher_code;

@end

