//
//Created by ESJsonFormatForMac on 19/03/22.
//

#import <Foundation/Foundation.h>

@class SFMviewModelAdinfos;
@interface SFMviewModel : NSObject

@property (nonatomic, strong) NSArray *adInfos;

@property (nonatomic, copy) NSString *requestId;

@property (nonatomic, copy) NSString *ret;

@end
@interface SFMviewModelAdinfos : NSObject

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

