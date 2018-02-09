//
//  TextFileShowList.h
//  TextFileShowList
//
//  Created by 赵楠 on 16/4/26.
//  Copyright © 2016年 ZhaoNan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFileShowList : UITableView
@property (nonatomic,assign)CGFloat cellTextFont;
@property (nonatomic,assign)CGFloat cellOfHight;

+ (TextFileShowList *)listWithTextField:(UITextField *)enterTextFile;
- (TextFileShowList *)initWithTextField:(UITextField *)enterTextFile;
/*
 [self.view addSubview:[TextFileShowList listWithTextField:tf]];
 */
@end
