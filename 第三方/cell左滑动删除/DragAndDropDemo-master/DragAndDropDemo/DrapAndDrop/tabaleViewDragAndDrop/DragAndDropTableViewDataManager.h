//
//  DragAndDropTableViewDataManager.h
//  CardScrlDemo
//
//  Created by lotus on 2019/12/31.
//  Copyright © 2019 lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DragAndDropTableViewDataManager : NSObject

- (void)setupDataSource;

//u should call setupDataSource method befor invoke below methods.
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSString *)cellDataForIndexPath:(NSIndexPath *)indexPath;
- (void)moveFromIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)addData:(NSString *)data ForIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
