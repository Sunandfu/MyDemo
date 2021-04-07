//
//Created by ESJsonFormatForMac on 20/07/13.
//

#import "SFJsonCatelogModel.h"
@implementation SFJsonCatelogModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"rows" : [SFJsonCatelogModelRows class]};
}

@end

@implementation SFJsonCatelogModelRows

@end


