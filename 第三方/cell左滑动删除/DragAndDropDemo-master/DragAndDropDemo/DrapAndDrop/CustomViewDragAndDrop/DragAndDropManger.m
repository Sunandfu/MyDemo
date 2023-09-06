//
//  DragAndDropManger.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/28.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragAndDropManger.h"
#import "DragView.h"
#import "DropView.h"

@implementation DragAndDropManger



#pragma mark - UIDragInteractionDelegate
/* 必须实现的代理方法*/
- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session
{
    id <NSItemProviderWriting> object = [(DragView *)self.dragView dragText];

    NSItemProvider *provider = [[NSItemProvider alloc] initWithObject:object];
    UIDragItem *textItem = [[UIDragItem alloc] initWithItemProvider:provider];
    return @[textItem];
}

/* Provide a preview to display while lifting the drag item.
 * Return nil to indicate that this item is not visible and should have no lift animation.
 * If not implemented, a UITargetedDragPreview initialized with interaction.view will be used.
 */
//返回nil则没有拖拽预览图和拖拽动画，也可以实现该代理自定义预览图
//- (nullable UITargetedDragPreview *)dragInteraction:(UIDragInteraction *)interaction previewForLiftingItem:(UIDragItem *)item session:(id<UIDragSession>)session
//{
//    return nil;
//}

/* Called when the lift animation is about to start.
 * Use the animator to animate your own changes alongside the system animation,
 * or to be called when the lift animation completes.
 */
- (void)dragInteraction:(UIDragInteraction *)interaction willAnimateLiftWithAnimator:(id<UIDragAnimating>)animator session:(id<UIDragSession>)session
{
    NSLog(@"drag willAnimateLiftWithAnimator");
}

/* Drag session lifecycle. */

/* Called when the the items are in their fully lifted appearance,
 * and the user has started to drag the items away.
 */
- (void)dragInteraction:(UIDragInteraction *)interaction sessionWillBegin:(id<UIDragSession>)session
{
    NSLog(@"drag sessionWillBegin");
}

/* Return whether this drag allows the "move" drop operation to happen.
 * This only applies to drops inside the same app. Drops in other apps are always copies.
 *
 * If true, then a UIDropInteraction's delegate's -dropInteraction:sessionDidUpdate:
 * may choose to return UIDropOperationMove, and that operation will be provided to
 * -dragInteraction:session:willEndWithOperation: and -dragInteraction:session:didEndWithOperation:.
 *
 * If not implemented, defaults to true.
 */
//数据是否允许移动，这一般发生在同一app内，如果是跨app的拖拽则都是copy操作
- (BOOL)dragInteraction:(UIDragInteraction *)interaction sessionAllowsMoveOperation:(id<UIDragSession>)session
{
    NSLog(@"drag sessionAllowsMoveOperation");
    return YES;
}

/* Return whether this drag is restricted to only this application.
 *
 * If true, then the drag will be restricted. Only this application will be
 * able to see the drag, and other applications will not.
 * If the user drops it on another application, the drag will be cancelled.
 *
 * If false, then the drag is not restricted. Other applications may see the drag,
 * and the user may drop it onto them.
 *
 * If not implemented, defaults to false.
 *
 * Note that this method is called only on devices that support dragging across applications.
 */
//是否允许跨app拖拽，默认允许。返回YES表示不允许跨App拖拽，返回NO反之。
- (BOOL)dragInteraction:(UIDragInteraction *)interaction sessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session
{
    NSLog(@"drag sessionIsRestrictedToDraggingApplication");
    return NO;
}

/* Return whether this drag's items' previews should be shown in their full
 * original size while over the source view. For instance, if you are reordering
 * items, you may want them not to shrink like they otherwise would.
 *
 * If not implemented, defaults to false.
 */
//拖拽的预览图是否是和source view一样大小，默认NO
- (BOOL)dragInteraction:(UIDragInteraction *)interaction prefersFullSizePreviewsForSession:(id<UIDragSession>)session
{
    NSLog(@"drag prefersFullSizePreviewsForSession");
    return NO;
}

/* Called when the drag has moved (because the user's touch moved).
 * Use -[UIDragSession locationInView:] to get its new location.
 */
- (void)dragInteraction:(UIDragInteraction *)interaction sessionDidMove:(id<UIDragSession>)session
{
    NSLog(@"drag sessionDidMove");
}

/* Called when the user is done dragging, and the drag will finish.
 *
 * If the operation is UIDropOperationCancel or UIDropOperationForbidden,
 * the delegate should prepare its views to show an appropriate appearance
 * before the cancel animation starts.
 */
- (void)dragInteraction:(UIDragInteraction *)interaction session:(id<UIDragSession>)session willEndWithOperation:(UIDropOperation)operation
{
    NSLog(@"drag willEndWithOperation");
}

/* Called when the user is done dragging and all related animations are
 * completed. The app should now return to its normal appearance.
 *
 * If the operation is UIDropOperationCopy or UIDropOperationMove,
 * then data transfer will begin, and -dragInteraction:sessionDidTransferItems: will be called later.
 */
- (void)dragInteraction:(UIDragInteraction *)interaction session:(id<UIDragSession>)session didEndWithOperation:(UIDropOperation)operation
{
    NSLog(@"drag didEndWithOperation");
}

/* Called after a drop happened and the handler of the drop has received
 * all of the data that it requested. You may now clean up any extra information
 * relating to those items or their item providers.
 */
- (void)dragInteraction:(UIDragInteraction *)interaction sessionDidTransferItems:(id<UIDragSession>)session
{
    NSLog(@"drag sessionDidTransferItems");
}


//拖拽过程中，还可以添加拖拽item，通过该代理实现
- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForAddingToSession:(id<UIDragSession>)session withTouchAtPoint:(CGPoint)point
{
    return nil;
}


//自定义dragSession，一般不需要实现该代理
- (nullable id<UIDragSession>)dragInteraction:(UIDragInteraction *)interaction sessionForAddingItems:(NSArray<id<UIDragSession>> *)sessions withTouchAtPoint:(CGPoint)point
{
    return nil;
}

- (void)dragInteraction:(UIDragInteraction *)interaction session:(id<UIDragSession>)session willAddItems:(NSArray<UIDragItem *> *)items forInteraction:(UIDragInteraction *)addingInteraction
{
    NSLog(@"drag willAddItems");
}

//取消拖拽的预览图，不实现的话系统会提供默认的
//- (nullable UITargetedDragPreview *)dragInteraction:(UIDragInteraction *)interaction previewForCancellingItem:(UIDragItem *)item withDefault:(UITargetedDragPreview *)defaultPreview;

//取消拖拽的动画即将开始
- (void)dragInteraction:(UIDragInteraction *)interaction item:(UIDragItem *)item willAnimateCancelWithAnimator:(id<UIDragAnimating>)animator
{
    NSLog(@"drag willAnimateCancelWithAnimator");
}


#pragma mark - UIDropInteractionDelegate
//是否可以处理某种数据类型，这也是一种数据类型安全检查
- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session
{
    BOOL canHandle = [session canLoadObjectsOfClass:NSString.class];

    NSLog(@"drop canHandle: %d", canHandle);
    return canHandle;
}
//拖拽进入dropview时候回调
- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnter:(id<UIDropSession>)session
{
    NSLog(@"drop sessionDidEnter");
}
//对拖拽数据的操作类型：取消、禁止、拷贝、移动
- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session
{
    NSLog(@"drop sessionDidUpdate");
    
    return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy];
}
//加载拖拽数据
- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session
{
    NSLog(@"drop performDrop");
    //completion在主线程回调
    [session loadObjectsOfClass:NSString.class completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        //NSLog(@"load object is in main thrend: %d", [NSThread currentThread].isMainThread);
        NSString *str = [NSString string];
        for (id source in objects) {
            if ([source isKindOfClass:[NSString class]]) {
                str = [str stringByAppendingString:source];
            }
        }

        [(DropView *)self.dropView configText:str];
    }];
}
@end
