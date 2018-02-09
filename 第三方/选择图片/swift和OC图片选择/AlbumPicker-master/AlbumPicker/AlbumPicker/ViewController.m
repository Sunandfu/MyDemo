//
//  ViewController.m
//  AlbumPicker
//
//  Created by okwei on 15/7/23.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "ViewController.h"
#import "LSYNavigationController.h"
#import "LSYAlbumCatalog.h"

@interface ViewController ()<LSYAlbumCatalogDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
 
}
- (IBAction)enterAlbum:(id)sender {
    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    albumCatalog.delegate = self;
    LSYNavigationController *navigation = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    albumCatalog.maximumNumberOfSelectionMedia = 9;
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}
-(void)AlbumDidFinishPick:(NSArray *)assets
{
    for (ALAsset *asset in assets) {
        if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
            UIImage * img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        } else if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypeVideo"]){
            NSURL *url = asset.defaultRepresentation.url;
        }
    }
//    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    dispatch_queue_t queue = dispatch_queue_create("uploadImg", NULL);
//    dispatch_async(queue, ^{
//        for (ALAsset *asset in assets) {
//            if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
//                //执行要上传图片的操作...
//                void (^uploadImg) (BOOL isFinish) = ^(BOOL isFinish){
//                  //上传完成后回调
//                    dispatch_semaphore_signal(sem);
//                };
//            }
//            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//        }
//    });
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
