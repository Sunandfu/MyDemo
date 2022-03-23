//
//  HFPermissionChecker.m
//  HFPermissionChecker
//
//  Created by hui hong on 2019/1/24.
//  Copyright © 2019 hui hong. All rights reserved.
//

#import "HFPermissionChecker.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>

@interface HFPermissionChecker ()<CLLocationManagerDelegate>

@property (nonatomic, assign) HFPermissionCheckerType permissionType;
@property (nonatomic, copy) HFPermissionCheckerCompleteBlock completeBlock;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HFPermissionChecker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.permissionType = HFPermissionCheckerTypeNone;
    }
    return self;
}

#pragma mark - public methods

+ (void)permissionChecker:(HFPermissionCheckerType)permissionType
            completeBlock:(HFPermissionCheckerCompleteBlock)completeBlock {
    [HFPermissionChecker sharedInstance].permissionType = permissionType;
    [HFPermissionChecker sharedInstance].completeBlock = completeBlock;
    [[HFPermissionChecker sharedInstance] handlePermission:permissionType];
}

#pragma mark - private methods

+ (instancetype)sharedInstance {
    static HFPermissionChecker *checker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checker = [HFPermissionChecker new];
    });
    return checker;
}

- (void)handlePermission:(HFPermissionCheckerType)permissionType {
    if ((permissionType & HFPermissionCheckerTypeNone) == HFPermissionCheckerTypeNone) {
    }
    if ((permissionType & HFPermissionCheckerTypeNotification) == HFPermissionCheckerTypeNotification) {
        [self handleNotification];
    }
    if ((permissionType & HFPermissionCheckerTypeLocation) == HFPermissionCheckerTypeLocation) {
        [self handleLocation];
    }
    if ((permissionType & HFPermissionCheckerTypeMicrophone) == HFPermissionCheckerTypeMicrophone) {
        [self handleMicrophone];
    }
    if ((permissionType & HFPermissionCheckerTypeCamera) == HFPermissionCheckerTypeCamera) {
        [self handleCamera];
    }
    if ((permissionType & HFPermissionCheckerTypePhoto) == HFPermissionCheckerTypePhoto) {
        [self handlePhoto];
    }
    if ((permissionType & HFPermissionCheckerTypeContacts) == HFPermissionCheckerTypeContacts) {
        [self handleContacts];
    }
    if ((permissionType & HFPermissionCheckerTypeCalendar) == HFPermissionCheckerTypeCalendar) {
        [self handleCalendarAndReminder:HFPermissionCheckerTypeCalendar];
    }
    if ((permissionType & HFPermissionCheckerTypeReminder) == HFPermissionCheckerTypeReminder) {
        [self handleCalendarAndReminder:HFPermissionCheckerTypeReminder];
    }
}

- (void)handleNotification {
    Class uncenter = NSClassFromString(@"UNUserNotificationCenter");
    Class setting = NSClassFromString(@"UIUserNotificationSettings");
    __block BOOL isAllowed = NO;
    __block HFPermissionStatus status = HFPermissionStatusNone;
    if (uncenter) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (UNAuthorizationStatusAuthorized == settings.authorizationStatus) {
                isAllowed = YES;
                status = HFPermissionStatusAuthorized;
            } else if (UNAuthorizationStatusDenied == settings.authorizationStatus) {
                status = HFPermissionStatusDenied;
            } else if (UNAuthorizationStatusNotDetermined == settings.authorizationStatus) {
            }
            if (self.completeBlock) {
                self.completeBlock(isAllowed, status, HFPermissionCheckerTypeNotification);
            }
        }];
    } else if (setting) {
        NSInteger types = [UIApplication sharedApplication].currentUserNotificationSettings.types;
        if (types != UIUserNotificationTypeNone) {
            isAllowed = YES;
            status = HFPermissionStatusAuthorized;
        } else {
            status = HFPermissionStatusDenied;
        }
        if (self.completeBlock) {
            self.completeBlock(isAllowed, status, HFPermissionCheckerTypeNotification);
        }
    } else {
        NSInteger types = [UIApplication sharedApplication].enabledRemoteNotificationTypes;
        if (types != UIRemoteNotificationTypeNone) {
            isAllowed = YES;
            status = HFPermissionStatusAuthorized;
        } else {
            status = HFPermissionStatusDenied;
        }
        if (self.completeBlock) {
            self.completeBlock(isAllowed, status, HFPermissionCheckerTypeNotification);
        }
    }
}

- (void)handleLocation {
    BOOL isAllowed = NO;
    HFPermissionStatus status = HFPermissionStatusNone;
    if ([CLLocationManager locationServicesEnabled]
        && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
            isAllowed = YES;
            status = HFPermissionStatusAuthorized;
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            status = HFPermissionStatusRestricted;
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            status = HFPermissionStatusDenied;
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            if (self.locationManager) {
                if (self.completeBlock) {
                    self.completeBlock(isAllowed, status, HFPermissionCheckerTypeLocation);
                }
                return;
            }
            // 弹授权弹框
            CLLocationManager *manager = [[CLLocationManager alloc] init];
            manager.delegate = self;
            self.locationManager = manager;
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestAlwaysAuthorization];
            }
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
            }
            return;
        }
    if (self.completeBlock) {
        self.completeBlock(isAllowed, status, HFPermissionCheckerTypeLocation);
    }
}

- (void)handleMicrophone {
    BOOL isAllowed = NO;
    __block HFPermissionStatus status = HFPermissionStatusNone;
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    if (permission == AVAudioSessionRecordPermissionGranted) {
        isAllowed = YES;
        status = HFPermissionStatusAuthorized;
    } else if (permission == AVAudioSessionRecordPermissionDenied) {
        status = HFPermissionStatusDenied;
    } else if (permission == AVAudioSessionRecordPermissionUndetermined) {
        // 弹授权弹框
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            status = granted ? HFPermissionStatusAuthorized : HFPermissionStatusDenied;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completeBlock) {
                    self.completeBlock(granted, status, HFPermissionCheckerTypeMicrophone);
                }
            });
        }];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(isAllowed, status, HFPermissionCheckerTypeMicrophone);
    }
}

- (void)handleCamera {
    BOOL isAllowed = NO;
    HFPermissionStatus hfstatus = HFPermissionStatusNone;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (AVAuthorizationStatusAuthorized == status) {
        isAllowed = YES;
        hfstatus = HFPermissionStatusAuthorized;
    } else if (AVAuthorizationStatusDenied == status) {
        hfstatus = HFPermissionStatusDenied;
    } else if (AVAuthorizationStatusRestricted == status) {
        hfstatus = HFPermissionStatusRestricted;
    } else if (AVAuthorizationStatusNotDetermined == status) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completeBlock) {
                    self.completeBlock(granted, (granted?HFPermissionStatusAuthorized:HFPermissionStatusDenied), HFPermissionCheckerTypeCamera);
                }
            });
        }];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(isAllowed, hfstatus, HFPermissionCheckerTypeCamera);
    }
}

- (void)handlePhoto {
    __block BOOL isAllowed = NO;
    __block HFPermissionStatus hfstatus = HFPermissionStatusNone;
    Class photo = NSClassFromString(@"PHPhotoLibrary");
    NSInteger status = -1;
    if (photo) {
        status = [PHPhotoLibrary authorizationStatus];
        if (PHAuthorizationStatusAuthorized == status) {
            isAllowed = YES;
            hfstatus = HFPermissionStatusAuthorized;
        } else if (PHAuthorizationStatusDenied == status) {
            hfstatus = HFPermissionStatusDenied;
        } else if (PHAuthorizationStatusRestricted == status) {
            hfstatus = HFPermissionStatusRestricted;
        } else if (PHAuthorizationStatusNotDetermined == status) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isAllowed = (PHAuthorizationStatusAuthorized == status);
                    if (PHAuthorizationStatusAuthorized == status) {
                        hfstatus = HFPermissionStatusAuthorized;
                    } else if (PHAuthorizationStatusDenied == status) {
                        hfstatus = HFPermissionStatusDenied;
                    }
                    if (self.completeBlock) {
                        self.completeBlock(isAllowed, hfstatus, HFPermissionCheckerTypePhoto);
                    }
                });
            }];
            return;
        }
    } else {
        status = [ALAssetsLibrary authorizationStatus];
        if (AVAuthorizationStatusAuthorized == status) {
            isAllowed = YES;
            hfstatus = HFPermissionStatusAuthorized;
        } else if (AVAuthorizationStatusDenied == status) {
            hfstatus = HFPermissionStatusDenied;
        } else if (AVAuthorizationStatusRestricted == status) {
            hfstatus = HFPermissionStatusRestricted;
        } else if (AVAuthorizationStatusNotDetermined == status) {
            ALAssetsLibrary *assertLibrary = [ALAssetsLibrary new];
            [assertLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (*stop) {
                    if (self.completeBlock) {
                        self.completeBlock(YES, HFPermissionStatusAuthorized, HFPermissionCheckerTypePhoto);
                    }
                }
            } failureBlock:^(NSError *error) {
                if (error) {
                    if (self.completeBlock) {
                        self.completeBlock(NO, HFPermissionStatusDenied, HFPermissionCheckerTypePhoto);
                    }
                }
            }];
            return;
        }
    }
    if (self.completeBlock) {
        self.completeBlock(isAllowed, hfstatus, HFPermissionCheckerTypePhoto);
    }
}

- (void)handleContacts {
    BOOL isAllowed = NO;
    HFPermissionStatus hfstatus = HFPermissionStatusNone;
    Class contact = NSClassFromString(@"CNContactStore");
    NSInteger status = -1;
    if (contact) {
        status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (CNAuthorizationStatusAuthorized == status) {
            isAllowed = YES;
            hfstatus = HFPermissionStatusAuthorized;
        } else if (CNAuthorizationStatusDenied == status) {
            hfstatus = HFPermissionStatusDenied;
        } else if (CNAuthorizationStatusRestricted == status) {
            hfstatus = HFPermissionStatusRestricted;
        } else if (CNAuthorizationStatusNotDetermined == status) {
            CNContactStore *store = [CNContactStore new];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.completeBlock) {
                        self.completeBlock(granted, (granted?HFPermissionStatusAuthorized:HFPermissionStatusDenied), HFPermissionCheckerTypeContacts);
                    }
                });
            }];
            return;
        }
    } else {
        status = ABAddressBookGetAuthorizationStatus();
        if (kABAuthorizationStatusAuthorized == status) {
            isAllowed = YES;
            hfstatus = HFPermissionStatusAuthorized;
        } else if (kABAuthorizationStatusDenied == status) {
            hfstatus = HFPermissionStatusDenied;
        } else if (kABAuthorizationStatusRestricted == status) {
            hfstatus = HFPermissionStatusRestricted;
        } else if (kABAuthorizationStatusNotDetermined == status) {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.completeBlock) {
                        self.completeBlock(granted, (granted?HFPermissionStatusAuthorized:HFPermissionStatusDenied), HFPermissionCheckerTypeContacts);
                    }
                });
            });
            return;
        }
    }
    if (self.completeBlock) {
        self.completeBlock(isAllowed, hfstatus, HFPermissionCheckerTypeContacts);
    }
}

- (void)handleCalendarAndReminder:(HFPermissionCheckerType)permissionType {
    HFPermissionStatus hfstatus = HFPermissionStatusNone;
    BOOL isAllowed = NO;
    EKEntityType entityType = (HFPermissionCheckerTypeCalendar == permissionType) ? EKEntityTypeEvent : EKEntityTypeReminder;
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:entityType];
    if (EKAuthorizationStatusAuthorized == status) {
        isAllowed = YES;
        hfstatus = HFPermissionStatusAuthorized;
    } else if (EKAuthorizationStatusDenied == status) {
        hfstatus = HFPermissionStatusDenied;
    } else if (EKAuthorizationStatusRestricted == status) {
        hfstatus = HFPermissionStatusRestricted;
    } else if (EKAuthorizationStatusNotDetermined == status) {
        EKEventStore *store = [EKEventStore new];
        [store requestAccessToEntityType:entityType completion:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completeBlock) {
                    self.completeBlock(granted, (granted?HFPermissionStatusAuthorized:HFPermissionStatusDenied), HFPermissionCheckerTypeCalendar);
                }
            });
        }];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(isAllowed, hfstatus, HFPermissionCheckerTypeCalendar);
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self handleLocation];
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
}

@end
