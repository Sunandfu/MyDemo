//
//Created by ESJsonFormatForMac on 19/08/13.
//

#import <Foundation/Foundation.h>

@class CouponDetailModelData,CouponDetailModelVouchers;
@interface CouponDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CouponDetailModelData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface CouponDetailModelData : NSObject

@property (nonatomic, strong) NSArray *vouchers;

@property (nonatomic, copy) NSString *tips;

@end

@interface CouponDetailModelVouchers : NSObject

@property (nonatomic, assign) NSInteger cost;

@property (nonatomic, assign) NSInteger voucher_value;

@property (nonatomic, copy) NSString *expire_time;

@property (nonatomic, copy) NSString *voucher_desc;

@property (nonatomic, copy) NSString *voucher_name;

@property (nonatomic, copy) NSString *gettime;

@property (nonatomic, copy) NSString *voucher_code;

@end

