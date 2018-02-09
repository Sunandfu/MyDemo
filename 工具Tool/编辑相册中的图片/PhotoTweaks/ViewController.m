//
//  ViewController.m
//  PhotoTweaks
//
//  Created by 小富 on 16/6/2.
//  Copyright © 2016年 Tu You. All rights reserved.
//

#import "ViewController.h"
#import "PhotoTweaksViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoTweaksViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = NO;
    [picker pushViewController:photoTweaksViewController animated:YES];
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    self.photoImage.image = croppedImage;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBarHidden = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
