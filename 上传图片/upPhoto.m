#pragma mark -更换头像
-(void)changeHeader_icon:(UIButton *)button{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:@"照相机",@"相册", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self getPhotosFromCamera];
    }else if(buttonIndex == 2) {
        [self getPhoteFromAlbum];
    }
}
//从照相机里获取照片
-(void)getPhotosFromCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType source=UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=source;
        
        UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
        //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
        UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
        UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
        [overLayView addSubview:bgImageView];
        picker.cameraOverlayView=overLayView;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceRear|UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
        
        //跳转到相机
        [self presentViewController:picker animated:NO completion:^{
            
        }];
        
    }else{
        NSLog(@"设备无摄像头");
    }
}
//从相册中获取照片
-(void)getPhoteFromAlbum{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    
    
    //跳转到相册
    [self presentViewController:pickerImage animated:NO completion:^{
        
    }];
}
#pragma mark -UIImagePickerControllerDelegate
- (void) imagePickerController: (UIImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSDictionary *) info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    //NSLog(@"%@",info);
    //保存原始图片
    //NSMutableArray *mAry=[[NSMutableArray alloc]init];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[mAry addObject:image];
    [self saveImage:image withName:@"currentImage.png"];
    [self sendHeaderImage];
    
    
}
//上传照片
-(void)sendHeaderImage{
    
    NSString *headerUrl=[NSString stringWithFormat:PersonalHeaderImageUrl,HGHostSeverPOST];
    
    //参数   除了时间 其他的参数对应的值都要变成UTF8编码
    NSDictionary *dict=@{@"userid":self.userId};
    AFHTTPRequestOperationManager *manager2 = [[AFHTTPRequestOperationManager alloc] init];
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    //单张图片图片和文字的上传
    [manager2 POST:headerUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.imageData!=nil) {   // 图片数据不为空才传递
            [formData appendPartWithFileData:self.imageData name:self.imageName fileName:self.filePath mimeType:@"png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"%@",dict);
        if ([dict[@"ret"] isEqualToString:@"0"]) {
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[userDefault objectForKey:@"user"]];
            [userDefault removeObjectForKey:@"user"];
            [userDefault synchronize];
            //[dic removeObjectForKey:@"headerIcon"];
            //[dic setObject:dict[@"imgurl"] forKey:@"headerIcon"];
            if ([dic[@"headerIcon"] isEqualToString:@""]==YES) {
                [dic setObject:dict[@"imgurl"] forKey:@"headerIcon"];
            }else{
                [dic setValue:dict[@"imgurl"]  forKey:@"headerIcon"];
            }
            [userDefault setObject:dic forKey:@"user"];
            [userDefault synchronize];
            self.originalHeaderImageUrl=dict[@"imgurl"];
            
            NSIndexSet *indexPath=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    self.imageName=imageName;
    self.imageData = UIImageJPEGRepresentation(currentImage,0.5);
    // 获取沙盒目录
    self.filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [self.imageData writeToFile:self.filePath atomically:NO];
    //将选择的图片显示出来
    //[button setImage:[UIImage imageWithContentsOfFile:self.filePath] forState:UIControlStateNormal];
    
    //将图片保存到disk
    UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil);
}