//
//  ContactsEntity+CoreDataProperties.h
//  通讯录
//
//  Created by 卢鹏肖 on 16/4/21.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ContactsEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactsEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *namePinYin;
@property (nullable, nonatomic, retain) NSString *phoneNum;
@property (nullable, nonatomic, retain) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END
