//
//  DragAndDropTableViewController+Drop.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/31.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragAndDropTableViewController+Drop.h"


@implementation DragAndDropTableViewController (Drop)

// Called when the user initiates the drop.
// Use the drop coordinator to access the items in the drop and the final destination index path and proposal for the drop,
// as well as specify how you wish to animate each item to its final position.
// If your implementation of this method does nothing, default drop animations will be supplied and the table view will
// revert back to its initial state before the drop session entered.
/** 必须实现的方法 获取数据*/
- (void)tableView:(UITableView *)tableView performDropWithCoordinator:(id<UITableViewDropCoordinator>)coordinator
{
    //文档说明该属性有可能为nil
    NSIndexPath *desIndexPath = coordinator.destinationIndexPath;
    NSLog(@"desIndexPath: %@", desIndexPath);
    if (desIndexPath == nil) {
        //从列表的最后一个section，构建一个最后的indexpath
        NSInteger section = [tableView numberOfSections] - 1;
        NSInteger row = [tableView numberOfRowsInSection:section];
        desIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    [coordinator.session loadObjectsOfClass:NSString.class completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        NSMutableArray <NSIndexPath *>* insertPath = [NSMutableArray array];

        [objects enumerateObjectsUsingBlock:^(__kindof id<NSItemProviderReading>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *tempPath = [NSIndexPath indexPathForRow:desIndexPath.row + idx inSection:desIndexPath.section];
            [insertPath addObject:tempPath];
            [self.dataManager addData:obj ForIndexPath:tempPath];
        }];

        if (insertPath.count) {
            [tableView insertRowsAtIndexPaths:insertPath withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}



// If NO is returned no further delegate methods will be called for this drop session.
// If not implemented, a default value of YES is assumed.
- (BOOL)tableView:(UITableView *)tableView canHandleDropSession:(id<UIDropSession>)session
{
    BOOL canHandle = [session canLoadObjectsOfClass:NSString.class];
    NSLog(@"drop canHandle: %@", @(canHandle));
    return canHandle;
}

// Called when the drop session begins tracking in the table view's coordinate space.
- (void)tableView:(UITableView *)tableView dropSessionDidEnter:(id<UIDropSession>)session
{

}

// Called frequently while the drop session being tracked inside the table view's coordinate space.
// When the drop is at the end of a section, the destination index path passed will be for a row that does not yet exist (equal
// to the number of rows in that section), where an inserted row would append to the end of the section.
// The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
// Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
// You may perform your own hit testing via -[session locationInView:]
- (UITableViewDropProposal *)tableView:(UITableView *)tableView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(nullable NSIndexPath *)destinationIndexPath
{
    if (tableView.hasActiveDrag) {
        //一次仅支持拖拽一个数据，超过一个取消
        if (session.items.count > 1) {
            return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationCancel];
        }else {
            return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UITableViewDropIntentInsertAtDestinationIndexPath];
        }
    }else {
        //跨app拖拽，必须是copy才可以实现拖拽成功
        return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UITableViewDropIntentInsertAtDestinationIndexPath];
    }
}

// Called when the drop session is no longer being tracked inside the table view's coordinate space.
- (void)tableView:(UITableView *)tableView dropSessionDidExit:(id<UIDropSession>)session
{

}

// Called when the drop session completed, regardless of outcome. Useful for performing any cleanup.
- (void)tableView:(UITableView *)tableView dropSessionDidEnd:(id<UIDropSession>)session
{

}

// Allows customization of the preview used when dropping to a newly inserted row.
// If not implemented or if nil is returned, the entire cell will be used for the preview.

//- (nullable UIDragPreviewParameters *)tableView:(UITableView *)tableView dropPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
@end
