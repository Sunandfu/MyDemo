/*
 
 File: YXReachability.m
 Abstract: Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 
 Version: 2.0.4ddg
 */

/*
 Significant additions made by Andrew W. Donoho, August 11, 2009.
 This is a derived work of Apple's YXReachability v2.0 class.
 
 The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>

 Extensions Copyright (C) 2009 Donoho Design Group, LLC. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Andrew W. Donoho nor Donoho Design Group, L.L.C.
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY DONOHO DESIGN GROUP, L.L.C. "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */


/*
 
 Apple's Original License on YXReachability v2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.

 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
*/

/*
 Each YXReachability object now has a copy of the key used to store it in a dictionary.
 This allows each observer to quickly determine if the event is important to them.
*/

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "YXReachability.h"

NSString *const kInternetConnection  = @"InternetConnection";
NSString *const kLocalWiFiConnection = @"LocalWiFiConnection";
NSString *const kYXReachabilityChangedNotification = @"NetworkYXReachabilityChangedNotification";

#define CLASS_DEBUG 1 // Turn on logYXReachabilityFlags. Must also have a project wide defined DEBUG.

#if (defined DEBUG && defined CLASS_DEBUG)
#define logYXReachabilityFlags(flags) (logYXReachabilityFlags_(__PRETTY_FUNCTION__, __LINE__, flags))

static NSString *YXReachabilityFlags_(SCNetworkReachabilityFlags flags) {
	
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.
    return [NSString stringWithFormat:@"YXReachability Flags: %c%c %c%c%c%c%c%c%c",
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
			
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#else
	// Compile out the v3.0 features for v2.2.1 deployment.
    return [NSString stringWithFormat:@"YXReachability Flags: %c%c %c%c%c%c%c%c",
			(flags & kSCNetworkYXReachabilityFlagsIsWWAN)               ? 'W' : '-',
			(flags & kSCNetworkYXReachabilityFlagsReachable)            ? 'R' : '-',
			
			(flags & kSCNetworkYXReachabilityFlagsConnectionRequired)   ? 'c' : '-',
			(flags & kSCNetworkYXReachabilityFlagsTransientConnection)  ? 't' : '-',
			(flags & kSCNetworkYXReachabilityFlagsInterventionRequired) ? 'i' : '-',
			// v3 kSCNetworkYXReachabilityFlagsConnectionOnTraffic == v2 kSCNetworkYXReachabilityFlagsConnectionAutomatic
			(flags & kSCNetworkYXReachabilityFlagsConnectionAutomatic)  ? 'C' : '-',
			// (flags & kSCNetworkYXReachabilityFlagsConnectionOnDemand)   ? 'D' : '-', // No v2 equivalent.
			(flags & kSCNetworkYXReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
			(flags & kSCNetworkYXReachabilityFlagsIsDirect)             ? 'd' : '-'];
#endif
	
} // YXReachabilityFlags_()

static void logYXReachabilityFlags_(const char *name, int line, SCNetworkReachabilityFlags flags) {
	
    NSLog(@"%s (%d) \n\t%@", name, line, YXReachabilityFlags_(flags));
	
} // logYXReachabilityFlags_()

#define logNetworkStatus(status) (logNetworkStatus_(__PRETTY_FUNCTION__, __LINE__, status))

static void logNetworkStatus_(const char *name, int line, NetworkStatus status) {
	
	NSString *statusString = nil;
	
	switch (status) {
		case kNotReachable:
			statusString = @"Not Reachable";
			break;
		case kReachableViaWWAN:
			statusString = @"Reachable via WWAN";
			break;
		case kReachableViaWiFi:
			statusString = @"Reachable via WiFi";
			break;
	}
	
	NSLog(@"%s (%d) \n\tNetwork Status: %@", name, line, statusString);
	
} // logNetworkStatus_()

#else
#define logYXReachabilityFlags(flags)
#define logNetworkStatus(status)
#endif

@interface YXReachability (private)

- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags;

@end

@implementation YXReachability

@synthesize key = key_;

// Preclude direct access to ivars.
+ (BOOL) accessInstanceVariablesDirectly {
	
	return NO;

} // accessInstanceVariablesDirectly


- (void) dealloc {
	
	[self stopNotifier];
	if(YXReachabilityRef) {
		
		CFRelease(YXReachabilityRef); YXReachabilityRef = NULL;
		
	}
	
	self.key = nil;
	
	[super dealloc];
	
} // dealloc


- (YXReachability *) initWithYXReachabilityRef: (SCNetworkReachabilityRef) ref
{
    self = [super init];
	if (self != nil) 
    {
		YXReachabilityRef = ref;
	}
	
	return self;
	
} // initWithYXReachabilityRef:


#if (defined DEBUG && defined CLASS_DEBUG)
- (NSString *) description {
	
	NSAssert(YXReachabilityRef, @"-description called with NULL YXReachabilityRef");
	
    SCNetworkReachabilityFlags flags = 0;
	
    SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags);
	
	return [NSString stringWithFormat: @"%@\n\t%@", self.key, YXReachabilityFlags_(flags)];
	
} // description
#endif


#pragma mark -
#pragma mark Notification Management Methods


//Start listening for YXReachability notifications on the current run loop
static void YXReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {

	#pragma unused (target, flags)
	NSCAssert(info, @"info was NULL in YXReachabilityCallback");
	NSCAssert([(NSObject*) info isKindOfClass: [YXReachability class]], @"info was the wrong class in YXReachabilityCallback");
	
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someone uses the Reachablity object in a different thread.
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	// Post a notification to notify the client that the network YXReachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: kYXReachabilityChangedNotification 
														object: (YXReachability *) info];
	
	[pool release];

} // YXReachabilityCallback()


- (BOOL) startNotifier {
	
    SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
	
    if(SCNetworkReachabilitySetCallback(YXReachabilityRef, YXReachabilityCallback, &context)) {
		
        if(SCNetworkReachabilityScheduleWithRunLoop(YXReachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {

			return YES;
			
		}
		
	}
	
	return NO;

} // startNotifier


- (void) stopNotifier {
	
	if(YXReachabilityRef) {
		
        SCNetworkReachabilityUnscheduleFromRunLoop(YXReachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

	}

} // stopNotifier


- (BOOL) isEqual: (YXReachability *) r {
	
	return [r.key isEqualToString: self.key];
	
} // isEqual:


#pragma mark -
#pragma mark YXReachability Allocation Methods


+ (YXReachability *) YXReachabilityWithHostName: (NSString *) hostName {
	
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	
	if (ref) {
		
		YXReachability *r = [[[self alloc] initWithYXReachabilityRef: ref] autorelease];
		
		r.key = hostName;

		return r;
		
	}
	
	return nil;
	
} // YXReachabilityWithHostName


+ (NSString *) makeAddressKey: (in_addr_t) addr {
	// addr is assumed to be in network byte order.
	
	static const int       highShift    = 24;
	static const int       highMidShift = 16;
	static const int       lowMidShift  =  8;
	static const in_addr_t mask         = 0x000000ff;
	
	addr = ntohl(addr);
	
	return [NSString stringWithFormat: @"%d.%d.%d.%d", 
			(addr >> highShift)    & mask, 
			(addr >> highMidShift) & mask, 
			(addr >> lowMidShift)  & mask, 
			 addr                  & mask];
	
} // makeAddressKey:


+ (YXReachability *) YXReachabilityWithAddress: (const struct sockaddr_in *) hostAddress {
	
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);

	if (ref) {
		
		YXReachability *r = [[[self alloc] initWithYXReachabilityRef: ref] autorelease];
		
		r.key = [self makeAddressKey: hostAddress->sin_addr.s_addr];
		
		return r;
		
	}
	
	return nil;

} // YXReachabilityWithAddress


+ (YXReachability *) YXReachabilityForInternetConnection {
	
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;

	YXReachability *r = [self YXReachabilityWithAddress: &zeroAddress];

	r.key = kInternetConnection;
	
	return r;

} // YXReachabilityForInternetConnection


+ (YXReachability *) YXReachabilityForLocalWiFi {
	
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

	YXReachability *r = [self YXReachabilityWithAddress: &localWifiAddress];

	r.key = kLocalWiFiConnection;

	return r;

} // YXReachabilityForLocalWiFi


#pragma mark -
#pragma mark Network Flag Handling Methods


#if USE_DDG_EXTENSIONS
//
// iPhone condition codes as reported by a 3GS running iPhone OS v3.0.
// Airplane Mode turned on:  YXReachability Flag Status: -- -------
// WWAN Active:              YXReachability Flag Status: WR -t-----
// WWAN Connection required: YXReachability Flag Status: WR ct-----
//         WiFi turned on:   YXReachability Flag Status: -R ------- Reachable.
// Local   WiFi turned on:   YXReachability Flag Status: -R xxxxxxd Reachable.
//         WiFi turned on:   YXReachability Flag Status: -R ct----- Connection down. (Non-intuitive, empirically determined answer.)
const SCNetworkReachabilityFlags kConnectionDown =  kSCNetworkReachabilityFlagsConnectionRequired |
kSCNetworkReachabilityFlagsTransientConnection;
//         WiFi turned on:   YXReachability Flag Status: -R ct-i--- Reachable but it will require user intervention (e.g. enter a WiFi password).
//         WiFi turned on:   YXReachability Flag Status: -R -t----- Reachable via VPN.
//
// In the below method, an 'x' in the flag status means I don't care about its value.
//
// This method differs from Apple's by testing explicitly for empirically observed values.
// This gives me more confidence in it's correct behavior. Apple's code covers more cases 
// than mine. My code covers the cases that occur.
//
- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags {
	
    if (flags & kSCNetworkReachabilityFlagsReachable) {
		
		// Local WiFi -- Test derived from Apple's code: -localWiFiStatusForFlags:.
		if (self.key == kLocalWiFiConnection) {

			// YXReachability Flag Status: xR xxxxxxd Reachable.
			return (flags & kSCNetworkReachabilityFlagsIsDirect) ? kReachableViaWiFi : kNotReachable;

		}
		
		// Observed WWAN Values:
		// WWAN Active:              YXReachability Flag Status: WR -t-----
		// WWAN Connection required: YXReachability Flag Status: WR ct-----
		//
		// Test Value: YXReachability Flag Status: WR xxxxxxx
		if (flags & kSCNetworkReachabilityFlagsIsWWAN) { return kReachableViaWWAN; }
		
		// Clear moot bits.
		flags &= ~kSCNetworkReachabilityFlagsReachable;
		flags &= ~kSCNetworkReachabilityFlagsIsDirect;
		flags &= ~kSCNetworkReachabilityFlagsIsLocalAddress; // kInternetConnection is local.
		
		// YXReachability Flag Status: -R ct---xx Connection down.
		if (flags == kConnectionDown) { return kNotReachable; }
		
		// YXReachability Flag Status: -R -t---xx Reachable. WiFi + VPN(is up) (Thank you Ling Wang)
		if (flags & kSCNetworkReachabilityFlagsTransientConnection)  { return kReachableViaWiFi; }
			
		// YXReachability Flag Status: -R -----xx Reachable.
		if (flags == 0) { return kReachableViaWiFi; }
		
		// Apple's code tests for dynamic connection types here. I don't. 
		// If a connection is required, regardless of whether it is on demand or not, it is a WiFi connection.
		// If you care whether a connection needs to be brought up,   use -isConnectionRequired.
		// If you care about whether user intervention is necessary,  use -isInterventionRequired.
		// If you care about dynamically establishing the connection, use -isConnectionIsOnDemand.

		// YXReachability Flag Status: -R cxxxxxx Reachable.
		if (flags & kSCNetworkReachabilityFlagsConnectionRequired) { return kReachableViaWiFi; }
		
		// Required by the compiler. Should never get here. Default to not connected.
#if (defined DEBUG && defined CLASS_DEBUG)
		NSAssert1(NO, @"Uncaught YXReachability test. Flags: %@", YXReachabilityFlags_(flags));
#endif
		return kNotReachable;

		}
	
	// YXReachability Flag Status: x- xxxxxxx
	return kNotReachable;
	
} // networkStatusForFlags:


- (NetworkStatus) currentYXReachabilityStatus {
	
	NSAssert(YXReachabilityRef, @"currentYXReachabilityStatus called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
//		logYXReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		return status;
		
	}
	
	return kNotReachable;
	
} // currentYXReachabilityStatus


- (BOOL) isReachable {
	
	NSAssert(YXReachabilityRef, @"isReachable called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
//		logYXReachabilityFlags(flags);

		status = [self networkStatusForFlags: flags];

//		logNetworkStatus(status);
		
		return (kNotReachable != status);
		
	}
	
	return NO;
	
} // isReachable


- (BOOL) isConnectionRequired {
	
	NSAssert(YXReachabilityRef, @"isConnectionRequired called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);

	}
	
	return NO;
	
} // isConnectionRequired


- (BOOL) connectionRequired {
	
	return [self isConnectionRequired];
	
} // connectionRequired
#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000)
static const SCNetworkReachabilityFlags kOnDemandConnection = kSCNetworkReachabilityFlagsConnectionOnTraffic |
                                                              kSCNetworkReachabilityFlagsConnectionOnDemand;
#else
static const SCNetworkYXReachabilityFlags kOnDemandConnection = kSCNetworkYXReachabilityFlagsConnectionAutomatic;
#endif

- (BOOL) isConnectionOnDemand {
	
	NSAssert(YXReachabilityRef, @"isConnectionIsOnDemand called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kOnDemandConnection));
		
	}
	
	return NO;
	
} // isConnectionOnDemand


- (BOOL) isInterventionRequired {
	
	NSAssert(YXReachabilityRef, @"isInterventionRequired called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kSCNetworkReachabilityFlagsInterventionRequired));
		
	}
	
	return NO;
	
} // isInterventionRequired


- (BOOL) isReachableViaWWAN {
	
	NSAssert(YXReachabilityRef, @"isReachableViaWWAN called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		return  (kReachableViaWWAN == status);
			
	}
	
	return NO;
	
} // isReachableViaWWAN


- (BOOL) isReachableViaWiFi {
	
	NSAssert(YXReachabilityRef, @"isReachableViaWiFi called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		return  (kReachableViaWiFi == status);
		
	}
	
	return NO;
	
} // isReachableViaWiFi


- (SCNetworkReachabilityFlags) YXReachabilityFlags {
	
	NSAssert(YXReachabilityRef, @"YXReachabilityFlags called with NULL YXReachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	
	if (SCNetworkReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		return flags;
		
	}
	
	return 0;
	
} // YXReachabilityFlags


#pragma mark -
#pragma mark Apple's Network Flag Handling Methods


#if !USE_DDG_EXTENSIONS
/*
 *
 *  Apple's Network Status testing code.
 *  The only changes that have been made are to use the new logYXReachabilityFlags macro and
 *  test for local WiFi via the key instead of Apple's boolean. Also, Apple's code was for v3.0 only
 *  iPhone OS. v2.2.1 and earlier conditional compiling is turned on. Hence, to mirror Apple's behavior,
 *  set your Base SDK to v3.0 or higher.
 *
 */

- (NetworkStatus) localWiFiStatusForFlags: (SCNetworkYXReachabilityFlags) flags
{
	logYXReachabilityFlags(flags);
	
	BOOL retVal = NotReachable;
	if((flags & kSCNetworkYXReachabilityFlagsReachable) && (flags & kSCNetworkYXReachabilityFlagsIsDirect))
	{
		retVal = ReachableViaWiFi;	
	}
	return retVal;
}


- (NetworkStatus) networkStatusForFlags: (SCNetworkYXReachabilityFlags) flags
{
	logYXReachabilityFlags(flags);
	if (!(flags & kSCNetworkYXReachabilityFlagsReachable))
	{
		// if target host is not reachable
		return NotReachable;
	}
	
	BOOL retVal = NotReachable;
	
	if (!(flags & kSCNetworkYXReachabilityFlagsConnectionRequired))
	{
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = ReachableViaWiFi;
	}
	
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.	
	if ((flags & kSCNetworkYXReachabilityFlagsConnectionOnDemand) ||
		(flags & kSCNetworkYXReachabilityFlagsConnectionOnTraffic))
#else
	if (flags & kSCNetworkYXReachabilityFlagsConnectionAutomatic)
#endif
		{
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs
			
			if (!(flags & kSCNetworkYXReachabilityFlagsInterventionRequired))
			{
				// ... and no [user] intervention is needed
				retVal = ReachableViaWiFi;
			}
		}
	
	if (flags & kSCNetworkYXReachabilityFlagsIsWWAN)
	{
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = ReachableViaWWAN;
	}
	return retVal;
}


- (NetworkStatus) currentYXReachabilityStatus
{
	NSAssert(YXReachabilityRef, @"currentYXReachabilityStatus called with NULL YXReachabilityRef");
	
	NetworkStatus retVal = NotReachable;
	SCNetworkYXReachabilityFlags flags;
	if (SCNetworkYXReachabilityGetFlags(YXReachabilityRef, &flags))
	{
		if(self.key == kLocalWiFiConnection)
		{
			retVal = [self localWiFiStatusForFlags: flags];
		}
		else
		{
			retVal = [self networkStatusForFlags: flags];
		}
	}
	return retVal;
}


- (BOOL) isReachable {
	
	NSAssert(YXReachabilityRef, @"isReachable called with NULL YXReachabilityRef");
	
	SCNetworkYXReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if (SCNetworkYXReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		if(self.key == kLocalWiFiConnection) {
			
			status = [self localWiFiStatusForFlags: flags];
			
		} else {
			
			status = [self networkStatusForFlags: flags];
			
		}
		
		return (kNotReachable != status);
		
	}
	
	return NO;
	
} // isReachable


- (BOOL) isConnectionRequired {
	
	return [self connectionRequired];
	
} // isConnectionRequired


- (BOOL) connectionRequired {
	
	NSAssert(YXReachabilityRef, @"connectionRequired called with NULL YXReachabilityRef");
	
	SCNetworkYXReachabilityFlags flags;
	
	if (SCNetworkYXReachabilityGetFlags(YXReachabilityRef, &flags)) {
		
		logYXReachabilityFlags(flags);
		
		return (flags & kSCNetworkYXReachabilityFlagsConnectionRequired);
		
	}
	
	return NO;
	
} // connectionRequired
#endif

@end
