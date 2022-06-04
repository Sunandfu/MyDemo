//
//  Auto Model File
//  From shortcut code for ESJsonFormatForMac
//
//  Created by Lurich on 22/04/19.
//  Copyright © 2022年 Lurich. All rights reserved.
//

#import "SFSqliteModel.h"

@implementation SFSqliteModel

- (NSInteger)ID{
    return _scriptId.hash;
}
- (NSString *)scriptClass{
    switch (_scriptClass.intValue) {
        case 1:
            return @"S级";
            break;
        case 2:
            return @"A级";
            break;
        case 3:
            return @"B级";
            break;
        case 4:
            return @"C级";
            break;
            
        default:
            return _scriptClass;
            break;
    }
}
- (NSString *)scriptForm{
    switch (_scriptForm.intValue) {
        case 1:
            return @"文字";
            break;
        case 2:
            return @"声漫";
            break;
        case 3:
            return @"视频";
            break;
            
        default:
            return _scriptForm;
            break;
    }
}
- (NSString *)scriptLevel{
    switch (_scriptLevel.intValue) {
        case 1:
            return @"简单";
            break;
        case 2:
            return @"中等";
            break;
        case 3:
            return @"困难";
            break;
            
        default:
            return _scriptLevel;
            break;
    }
}
- (NSString *)scriptTheme{
    switch (_scriptTheme.intValue) {
        case 1:
            return @"古装";
            break;
        case 2:
            return @"都市";
            break;
        case 3:
            return @"科幻";
            break;
        case 4:
            return @"现实";
            break;
        case 5:
            return @"校园";
            break;
        case 6:
            return @"奇幻";
            break;
            
        default:
            return _scriptTheme;
            break;
    }
}
- (NSString *)scriptType{
    switch (_scriptType.intValue) {
        case 1:
            return @"恐怖";
            break;
        case 2:
            return @"还原";
            break;
        case 3:
            return @"情感";
            break;
        case 4:
            return @"硬核";
            break;
        case 5:
            return @"欢乐";
            break;
        case 6:
            return @"阵营";
            break;
        case 7:
            return @"推理";
            break;
        case 8:
            return @"机制";
            break;
            
        default:
            return _scriptType;
            break;
    }
}

@end

