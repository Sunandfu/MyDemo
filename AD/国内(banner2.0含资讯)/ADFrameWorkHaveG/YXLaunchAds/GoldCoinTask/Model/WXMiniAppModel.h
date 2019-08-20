//
//Created by ESJsonFormatForMac on 19/08/08.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WXMiniAppModelShare,WXMiniAppModelApp,WXMiniAppModelData;
@interface WXMiniAppModel : NSObject

@property (nonatomic, copy) NSString *cpah5_url;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger appMiniSharePyqType;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger appMiniSharePyq;

@property (nonatomic, copy) NSString *alappkey;

@property (nonatomic, copy) NSString *appIconUrl;

@property (nonatomic, assign) NSInteger appAsoDisplayType;

@property (nonatomic, copy) NSString *minih5_url;

@property (nonatomic, assign) NSInteger appAsoTab;

@property (nonatomic, assign) NSInteger appAsoFocus;

@property (nonatomic, strong) WXMiniAppModelShare *share;

@property (nonatomic, copy) NSString *appSdkversion;

@property (nonatomic, copy) NSString *api_host;

@property (nonatomic, copy) NSString *appName;

@property (nonatomic, assign) NSInteger appAsoNew;

@property (nonatomic, copy) NSString *cplh5_url;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) WXMiniAppModelApp *app;

@end
@interface WXMiniAppModelShare : NSObject

@property (nonatomic, assign) NSInteger dayIncome;

@property (nonatomic, copy) NSString *ruleImg;

@property (nonatomic, assign) NSInteger allIncome;

@property (nonatomic, copy) NSString *wechat_share_id;

@end

@interface WXMiniAppModelApp : NSObject

@property (nonatomic, copy) NSString *exdw;

@property (nonatomic, copy) NSString *exchange;

@end

@interface WXMiniAppModelData : NSObject

@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, copy) NSString *Desc;

@property (nonatomic, assign) CGFloat uprice;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *miniappId;

@property (nonatomic, copy) NSString *jumpurl;

@property (nonatomic, copy) NSString *qrcode;

@property (nonatomic, copy) NSString *miniProgramId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger is_auto_rank;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger priority;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *wxid;

@property (nonatomic, copy) NSString *targetid;

@property (nonatomic, copy) NSString *guide;

@property (nonatomic, copy) NSString *mycode;

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *task_img;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) NSString *complete_pre;

@property (nonatomic, copy) NSString *adqrcode;

@property (nonatomic, assign) NSInteger jumptype;

@property (nonatomic, copy) NSString *exdw;

@end

