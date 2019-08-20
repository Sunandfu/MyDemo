//
//Created by ESJsonFormatForMac on 19/08/12.
//

#import <Foundation/Foundation.h>

@class GetFeedTaskModelData;
@interface GetFeedTaskModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface GetFeedTaskModelData : NSObject

@property (nonatomic, copy) NSString *complete_url;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *Desc;

@property (nonatomic, copy) NSString *scroll_time;

@property (nonatomic, copy) NSString *cost_time;

@end

