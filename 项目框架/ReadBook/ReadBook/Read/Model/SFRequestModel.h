//
//  SFRequestModel.h
//  ReadBook
//
//  Created by lurich on 2020/5/26.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFRequestModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isCustom;
@property (nonatomic, copy) NSString *wwwReq;
@property (nonatomic, copy) NSString *wapReq;
@property (nonatomic, copy) NSString *list;
@property (nonatomic, copy) NSString *search;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *aclick;
@property (nonatomic, copy) NSString *auther;
@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *synopsisDetail;
@property (nonatomic, copy) NSString *requestType;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
