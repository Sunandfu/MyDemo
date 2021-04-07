//
//Created by ESJsonFormatForMac on 20/07/13.
//

#import <Foundation/Foundation.h>

@class SFJsonBookModelDirect,SFJsonBookModelRows;
@interface SFJsonBookModel : NSObject

@property (nonatomic, copy) NSString *keyWord;

@property (nonatomic, strong) SFJsonBookModelDirect *direct;

@property (nonatomic, strong) NSArray *vecTopic;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, copy) NSString *checkquery;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger ret;

@end
@interface SFJsonBookModelDirect : NSObject

@property (nonatomic, copy) NSString *spushname;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, assign) NSInteger sumPrice;

@property (nonatomic, assign) NSInteger authorid;

@property (nonatomic, copy) NSString *subject;

@property (nonatomic, assign) NSInteger lastupdatetime;

@property (nonatomic, assign) NSInteger isfinish;

@property (nonatomic, assign) NSInteger bookprice;

@property (nonatomic, assign) NSInteger filesize;

@property (nonatomic, copy) NSString *resourcename;

@property (nonatomic, copy) NSString *lastserialuniq;

@property (nonatomic, assign) NSInteger subscript;

@property (nonatomic, assign) NSInteger ischarge;

@property (nonatomic, assign) NSInteger freeserialnum;

@property (nonatomic, copy) NSString *subtypeid;

@property (nonatomic, assign) NSInteger saletype;

@property (nonatomic, assign) NSInteger lastserialid;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *resourceid;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, assign) NSInteger serialnum;

@property (nonatomic, copy) NSString *cpid;

@property (nonatomic, assign) NSInteger star;

@property (nonatomic, assign) NSInteger sourcesize;

@property (nonatomic, copy) NSString *cpname;

@property (nonatomic, assign) NSInteger supporttype;

@property (nonatomic, copy) NSString *catalogurl;

@property (nonatomic, copy) NSString *lastserialname;

@property (nonatomic, copy) NSString *subjectid;

@property (nonatomic, copy) NSString *subtype;

@property (nonatomic, copy) NSString *picurl;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, assign) NSInteger letterprice;

@property (nonatomic, assign) NSInteger vip;

@end

@interface SFJsonBookModelRows : NSObject

@property (nonatomic, copy) NSString *spushname;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, assign) NSInteger sumPrice;

@property (nonatomic, assign) NSInteger authorid;

@property (nonatomic, copy) NSString *subject;

@property (nonatomic, assign) NSInteger lastupdatetime;

@property (nonatomic, assign) NSInteger isfinish;

@property (nonatomic, assign) NSInteger bookprice;

@property (nonatomic, assign) NSInteger filesize;

@property (nonatomic, copy) NSString *resourcename;

@property (nonatomic, copy) NSString *lastserialuniq;

@property (nonatomic, assign) NSInteger subscript;

@property (nonatomic, assign) NSInteger ischarge;

@property (nonatomic, assign) NSInteger freeserialnum;

@property (nonatomic, copy) NSString *subtypeid;

@property (nonatomic, assign) NSInteger saletype;

@property (nonatomic, assign) NSInteger lastserialid;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *resourceid;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, assign) NSInteger serialnum;

@property (nonatomic, copy) NSString *cpid;

@property (nonatomic, assign) NSInteger star;

@property (nonatomic, assign) NSInteger sourcesize;

@property (nonatomic, copy) NSString *cpname;

@property (nonatomic, assign) NSInteger supporttype;

@property (nonatomic, copy) NSString *catalogurl;

@property (nonatomic, copy) NSString *lastserialname;

@property (nonatomic, copy) NSString *subjectid;

@property (nonatomic, copy) NSString *subtype;

@property (nonatomic, copy) NSString *picurl;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, assign) NSInteger letterprice;

@property (nonatomic, assign) NSInteger vip;

@end

