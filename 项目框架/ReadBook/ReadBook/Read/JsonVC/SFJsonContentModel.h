//
//Created by ESJsonFormatForMac on 20/07/13.
//

#import <Foundation/Foundation.h>

@class SFJsonContentModelData;
@interface SFJsonContentModel : NSObject

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, strong) SFJsonContentModelData *data;

@end
@interface SFJsonContentModelData : NSObject

@property (nonatomic, copy) NSString *serialUrl;

@property (nonatomic, copy) NSString *serialName;

@property (nonatomic, copy) NSString *rawID;

@property (nonatomic, assign) NSInteger isFree;

@property (nonatomic, copy) NSString *other;

@property (nonatomic, copy) NSString *site;

@property (nonatomic, assign) NSInteger serialUniqId;

@property (nonatomic, assign) BOOL adNumValid;

@property (nonatomic, assign) NSInteger updateTime;

@property (nonatomic, assign) NSInteger fetchAdNum;

@property (nonatomic, strong) NSArray *backSerial;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *serialUniqID;

@property (nonatomic, copy) NSString *resourceID;

@property (nonatomic, assign) NSInteger midAdIdx;

@property (nonatomic, assign) BOOL isUnLock;

@property (nonatomic, assign) NSInteger contentLen;

@property (nonatomic, assign) NSInteger contentType;

@property (nonatomic, copy) NSString *resourceName;

@property (nonatomic, copy) NSString *contentUniqID;

@property (nonatomic, copy) NSString *_proto_struct_name_;

@property (nonatomic, assign) NSInteger serialID;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *oldSerialUniqID;

@property (nonatomic, assign) NSInteger oriSerialID;

@property (nonatomic, strong) NSArray *content;

@property (nonatomic, assign) NSInteger resourceTypeID;

@end
