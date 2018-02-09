//
//  ViewController.m
//  照片截取
//
//  Created by 李超 on 16/6/13.
//  Copyright © 2016年 ptgx. All rights reserved.
//

#import "ViewController.h"
#import "UIKit/UIKit.h"
#import "PTImageCropVC.h"

@interface ViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (IBAction)buttonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"方式" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                
                picker.sourceType = sourceType;
                
                [self presentViewController:picker animated:YES completion:nil];
            }
            break;
        }
        case 1:
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    PTImageCropVC* cropVC = [[PTImageCropVC alloc] initWithImage:image withCropScale:0 complentBlock:^(UIImage* image) {
        
        [self.showImage setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    } cancelBlock:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:cropVC animated:YES completion:nil];
}
@end
