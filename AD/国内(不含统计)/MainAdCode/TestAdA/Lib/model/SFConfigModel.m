//
//Created by ESJsonFormatForMac on 19/03/25.
//

#import "SFConfigModel.h"
@implementation SFConfigModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"adInfos" : [SFConfigModelAdinfos class], @"advertiser" : [SFConfigModelAdvertiser class]};
}


@end

@implementation SFConfigModelAdinfos


@end


@implementation SFConfigModelAdvertiser

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"adplaces" : [SFConfigModelAdplaces class]};
}


@end


@implementation SFConfigModelAdplaces


@end


