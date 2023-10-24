#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "OpenIMSDK.h"
#import "CallbackProxy.h"
#import "SendMessageCallbackProxy.h"
#import "UploadFileCallbackProxy.h"
#import "OIMCallbacker+Closure.h"
#import "OIMCallbacker.h"
#import "OIMGCDMulticastDelegate.h"
#import "OIMManager+Connection.h"
#import "OIMManager+Conversation.h"
#import "OIMManager+Friend.h"
#import "OIMManager+Group.h"
#import "OIMManager+Login.h"
#import "OIMManager+Message.h"
#import "OIMManager+User.h"
#import "OIMManager.h"
#import "OIMAtElem.h"
#import "OIMAttachedInfoElem.h"
#import "OIMConversationInfo.h"
#import "OIMCustomElem.h"
#import "OIMDepartmentInfo.h"
#import "OIMFaceElem.h"
#import "OIMFileElem.h"
#import "OIMFriendApplication.h"
#import "OIMFullUserInfo.h"
#import "OIMGroupApplicationInfo.h"
#import "OIMGroupInfo.h"
#import "OIMGroupMemberInfo.h"
#import "OIMLocationElem.h"
#import "OIMMergeElem.h"
#import "OIMMessageElem.h"
#import "OIMMessageInfo.h"
#import "OIMNotificationElem.h"
#import "OIMPictureElem.h"
#import "OIMQuoteElem.h"
#import "OIMSearchParam.h"
#import "OIMSearchResultInfo.h"
#import "OIMSignalingInfo.h"
#import "OIMSimpleRequstInfo.h"
#import "OIMSimpleResultInfo.h"
#import "OIMSoundElem.h"
#import "OIMUserInfo.h"
#import "OIMVideoElem.h"
#import "OIMDefine.h"
#import "Reachability.h"

FOUNDATION_EXPORT double OpenIMSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char OpenIMSDKVersionString[];

