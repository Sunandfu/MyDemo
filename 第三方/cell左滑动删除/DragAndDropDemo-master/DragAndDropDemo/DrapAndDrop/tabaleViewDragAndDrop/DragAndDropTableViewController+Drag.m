//
//  DragAndDropTableViewController+Drag.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/31.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragAndDropTableViewController+Drag.h"



@implementation DragAndDropTableViewController (Drag)

/* 必须实现的代理方法，拖动的数据构建 */
- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"drag itemsForBeginningDragSession");

    //我们可以控制触发位置，像支付宝设置里的支付设置顺序调整，只能长按右边才响应拖拽
    CGPoint locationPoint = [session locationInView:tableView];
    BOOL canResponse = locationPoint.x > CGRectGetMaxX(tableView.frame) - 50;
    if (!canResponse){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"canMove"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return nil;
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"canMove"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    //return nil;//如果只是对本app内cell数据移动，直接返回nil即可


    NSString *dragObject = [self.dataManager cellDataForIndexPath:indexPath];
    if (dragObject.length == 0) return nil;

    NSItemProvider *provider = [[NSItemProvider alloc] initWithObject:dragObject];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:provider];
    return @[item];
}



// Called to request items to add to an existing drag session in response to the add item gesture.
// You can use the provided point (in the table view's coordinate space) to do additional hit testing if desired.
// If not implemented, or if an empty array is returned, no items will be added to the drag and the gesture
// will be handled normally.
/* 拖拽过程中，还需要添加拖拽数据的，在该代理中实现*/
//- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point;

// Allows customization of the preview used for the row when it is lifted or if the drag cancels.
// If not implemented or if nil is returned, the entire cell will be used for the preview.
/* 自定义拖拽预览，不实现的话，系统会添加默认的预览图 */
//- (nullable UIDragPreviewParameters *)tableView:(UITableView *)tableView dragPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath;

// Called after the lift animation has completed to signal the start of a drag session.
// This call will always be balanced with a corresponding call to -tableView:dragSessionDidEnd:
- (void)tableView:(UITableView *)tableView dragSessionWillBegin:(id<UIDragSession>)session
{
    NSLog(@"drag dragSessionWillBegin");
}

// Called to signal the end of the drag session.
- (void)tableView:(UITableView *)tableView dragSessionDidEnd:(id<UIDragSession>)session
{
    NSLog(@"drag dragSessionDidEnd");
}

// Controls whether move operations are allowed for the drag session.
// If not implemented, defaults to YES.
//- (BOOL)tableView:(UITableView *)tableView dragSessionAllowsMoveOperation:(id<UIDragSession>)session;

// Controls whether the drag session is restricted to the source application.
// If not implemented, defaults to NO.
/** 是否允许跨app拖拽，YES:不允许 NO：允许*/
//- (BOOL)tableView:(UITableView *)tableView dragSessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session;
@end
