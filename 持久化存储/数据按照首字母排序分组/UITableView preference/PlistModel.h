//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

@interface PlistModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *bfirstletter;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic,  copy) NSString *url;

@property (nonatomic,  copy) NSString *pinyin;



@property (nonatomic, copy) NSString *CityID;

@property (nonatomic, copy) NSString *EngName;

@property (nonatomic, copy) NSString *CityFullName;

@property (nonatomic, copy) NSString *CityLevel;

@property (nonatomic, copy) NSString *CityName;

@property (nonatomic, copy) NSString *Initial;

@property (nonatomic, copy) NSString *ParentID;

@end

