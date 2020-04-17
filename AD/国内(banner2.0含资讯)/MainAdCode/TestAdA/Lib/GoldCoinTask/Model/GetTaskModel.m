//
//Created by ESJsonFormatForMac on 19/08/12.
//

#import "GetTaskModel.h"
@implementation GetTaskModel

@end

@implementation GetTaskModelData

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [GetTaskTypeModelData class]};
}

@end


@implementation GetTaskModelAsset

@end


@implementation GetTaskTypeModelData

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [GetTaskDataModel class]};
}

@end


@implementation GetTaskDataModel

@end


