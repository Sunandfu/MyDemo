//
//  UIApplication+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Category)
/// "沙盒Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// "沙盒Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// "沙盒Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

/// Application's Bundle Name (show in SpringBoard).
@property (nonatomic, readonly) NSString *appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
@property (nonatomic, readonly) NSString *appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nonatomic, readonly) NSString *appVersion;

/// Application's Build number. e.g. "123"
@property (nonatomic, readonly) NSString *appBuildVersion;


@end
