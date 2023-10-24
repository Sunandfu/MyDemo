//
//  DrapAndDropViewController.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/28.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragAndDropViewController.h"
#import "DragView.h"
#import "DropView.h"
#import "DragAndDropManger.h"

@interface DragAndDropViewController ()
@property (weak, nonatomic) IBOutlet DragView *drapView;
@property (weak, nonatomic) IBOutlet DropView *dropView;

@property (nonatomic, strong) UIDragInteraction *dragInteraction;
@property (nonatomic, strong) DragAndDropManger *dragAndDropManger;

@property (nonatomic, strong) UIDropInteraction *dropInteraction;
@end

@implementation DragAndDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDragAndDrop];
}

- (void)setupDragAndDrop
{
    self.drapView.interactions = @[self.dragInteraction];
    self.dropView.interactions = @[self.dropInteraction];
}

#pragma mark - getter


- (UIDragInteraction *)dragInteraction
{
    if (!_dragInteraction) {
        _dragInteraction = [[UIDragInteraction alloc] initWithDelegate:self.dragAndDropManger];
    }

    return _dragInteraction;
}

- (UIDropInteraction *)dropInteraction
{
    if (!_dropInteraction) {
        _dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self.dragAndDropManger];
    }
    return _dropInteraction;
}
- (DragAndDropManger *)dragAndDropManger
{
    if (!_dragAndDropManger) {
        _dragAndDropManger = [[DragAndDropManger alloc] init];
        _dragAndDropManger.dragView = self.drapView;
        _dragAndDropManger.dropView = self.dropView;
    }

    return _dragAndDropManger;
}



@end
