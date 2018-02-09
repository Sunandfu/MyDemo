//
//  SFDevice.m
//  wuxiangundongview
//
//  Created by 小富 on 16/4/20.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "SFDevice.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <objc/runtime.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation SFDevice

+ (NSString *)Device_CurrentLanguage
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+ (NSString *)Device_Model
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].model;
#else
    return nil;
#endif
}

+ (NSString *)Device_UUID
{
    return nil;
}

+ (NSString *)Device_LocalHost
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString *)Device_MachineModel
{
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

+ (NSString *)Device_MachineModelName
{
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self Device_MachineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch",
                              @"Watch1,2" : @"Apple Watch",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,3" : @"iPhone SE",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

+ (NSString *)Device_SystemUptime
{
    NSInteger ti = (NSInteger)[[NSProcessInfo processInfo] systemUptime];
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    
    //    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - ti)];
}

#pragma mark -
#pragma mark - Network Information
+ (NSString *)Device_MacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL) {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    //NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString *)Device_IpAddressWIFI
{
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}
+ (NSString *)Device_IpAddressCell
{
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

#pragma mark -
#pragma mark - Disk Space
+ (unsigned long)Device_DiskSpace
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
+ (unsigned long)Device_DiskSpaceFree
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
+ (unsigned long)Device_DiskSpaceUsed
{
    int64_t total = [self Device_DiskSpace];
    int64_t free = [self Device_DiskSpaceFree];
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

#pragma mark -
#pragma mark - Memory Information
+ (unsigned long)Device_MemoryTotal
{
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}
+ (unsigned long)Device_MemoryUsed
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}
+ (unsigned long)Device_MemoryFree
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}
+ (unsigned long)Device_MemoryActive
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}
+ (unsigned long)Device_MemoryInactive
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}
+ (unsigned long)Device_MemoryWired
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}
+ (unsigned long)Device_MemoryPurgable
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

#pragma mark -
#pragma mark - CPU Information
+ (NSUInteger)Device_CpuCount
{
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (NSArray *)Device_CpuUsagePerProcessor
{
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}
+ (float)Device_CpuUsage
{
    float cpu = 0;
    NSArray *cpus = [self Device_CpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}
+ (NSString *)Device_SystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)canMakePhoneCalls
{
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
+ (BOOL)isiTV NS_ENUM_AVAILABLE_IOS(9_0)
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV);
}

+ (BOOL)isiPad NS_ENUM_AVAILABLE_IOS(3_2)
{
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

+ (BOOL)isiPhone NS_ENUM_AVAILABLE_IOS(3_2)
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isRtina NS_ENUM_AVAILABLE_IOS(4_0)
{
    return ([[UIScreen mainScreen] scale] >= 2.0);
}
+ (BOOL)isRequiresPhoneOS
{
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
}
+ (BOOL)isScreenSizeEqualToSize:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
    {
        return YES;
    }
#endif
    return NO;
}





#pragma mark -
+ (NSString *)APP_Version
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)APP_BuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)APP_BundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)APP_Identifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)APP_BundleSeedID
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

+ (NSString *)APP_SchemaWithName:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    return nil;
#else
    return nil;
#endif
}

+ (NSString *)APP_Schema
{
    return [self APP_SchemaWithName:nil];
}

+ (NSURL *)APP_DocumentsURL
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)APP_DocumentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)APP_CachesURL
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)APP_CachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)APP_LibraryURL
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)APP_LibraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (unsigned long)APP_MemoryUsage
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kern = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kern != KERN_SUCCESS) return -1;
    return info.resident_size;
}

+ (float)APP_CpuUsage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

@end
