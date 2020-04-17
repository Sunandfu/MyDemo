//
//Created by ESJsonFormatForMac on 19/08/13.
//

#import "CouponDetailModel.h"
@implementation CouponDetailModel

@end

@implementation CouponDetailModelData

+ (NSDictionary *)objectClassInArray{
    return @{@"vouchers" : [CouponDetailModelVouchers class]};
}

@end


@implementation CouponDetailModelVouchers

@end


