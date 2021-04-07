//
//Created by ESJsonFormatForMac on 20/07/13.
//

#import "SFJsonBookModel.h"
@implementation SFJsonBookModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"rows" : [SFJsonBookModelRows class]};
}

@end

@implementation SFJsonBookModelDirect

@end


@implementation SFJsonBookModelRows

@end


