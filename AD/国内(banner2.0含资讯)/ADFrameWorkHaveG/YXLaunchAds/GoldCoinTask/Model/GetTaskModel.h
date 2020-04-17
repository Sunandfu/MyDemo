//
//Created by ESJsonFormatForMac on 19/08/12.
//

#import <Foundation/Foundation.h>

@class GetTaskModelData,GetTaskModelAsset,GetTaskTypeModelData,GetTaskDataModel;
@interface GetTaskModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) GetTaskModelData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface GetTaskModelData : NSObject

@property (nonatomic, copy) NSString *announcement;

@property (nonatomic, assign) NSInteger announcementHeight;

@property (nonatomic, strong) GetTaskModelAsset *asset;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger rate;

@end

@interface GetTaskModelAsset : NSObject

@property (nonatomic, assign) NSInteger balance;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger use_count;

@property (nonatomic, assign) NSInteger voucher_num;

@end

@interface GetTaskTypeModelData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger sort;

@end

@interface GetTaskDataModel : NSObject

@property (nonatomic, copy) NSString *reward;

@property (nonatomic, assign) NSInteger max_completion_num;

@property (nonatomic, copy) NSString *location_id;

@property (nonatomic, assign) NSInteger is_show_completions;

@property (nonatomic, copy) NSString *Desc;

@property (nonatomic, assign) NSInteger DescHeight;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger completion_num;

@property (nonatomic, assign) NSInteger execute_way;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sdk_code;

@property (nonatomic, copy) NSString *media_id;

@property (nonatomic, copy) NSString *app_id;

@property (nonatomic, copy) NSString *secret;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger infinite;

@end

