//
//Created by ESJsonFormatForMac on 19/03/25.
//

#import <Foundation/Foundation.h>

@class SFConfigModelAdinfos,SFConfigModelAdvertiser,SFConfigModelAdplaces;
@interface SFConfigModel : NSObject

@property (nonatomic, assign) NSInteger adCount;

@property (nonatomic, strong) NSArray *advertiser;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, strong) NSArray *adInfos;

@property (nonatomic, copy) NSString *ret;

@end
@interface SFConfigModelAdinfos : NSObject

@property (nonatomic, assign) NSInteger ac_type;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, assign) NSInteger ad_type;

@property (nonatomic, strong) NSArray *impress_notice_urls;

@property (nonatomic, copy) NSString *click_url;

@property (nonatomic, assign) NSInteger creative_type;

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *adid;

@property (nonatomic, strong) NSArray *click_notice_urls;

@end

@interface SFConfigModelAdvertiser : NSObject

@property (nonatomic, strong) NSArray *adplaces;

@property (nonatomic, assign) NSInteger frequencyDay;

@property (nonatomic, assign) NSInteger advertiserId;

@property (nonatomic, assign) NSInteger frequencyHour;

@property (nonatomic, assign) NSInteger priority;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger frequencyMin;

@property (nonatomic, copy) NSString *isNative;

@property (nonatomic, assign) NSInteger isChina;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL targetCountry;

@end

@interface SFConfigModelAdplaces : NSObject

@property (nonatomic, copy) NSString *apiKey;

@property (nonatomic, assign) NSInteger advertiserId;

@property (nonatomic, assign) NSInteger virtualLimit;

@property (nonatomic, copy) NSString *adPlaceId;

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *packageName;

@property (nonatomic, assign) NSInteger realLimit;

@property (nonatomic, copy) NSString *version;

@end

