//
//  SFModel.h
//  SFModel 
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<SFModel/SFModel.h>)
FOUNDATION_EXPORT double SFModelVersionNumber;
FOUNDATION_EXPORT const unsigned char SFModelVersionString[];
#import <SFModel/NSObject+SFModel.h>
#import <SFModel/SFClassInfo.h>
#else
#import "NSObject+SFModel.h"
#import "SFClassInfo.h"
#endif
