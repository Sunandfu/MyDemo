//版本更新
- (void)versionUpdate{
    
    //获得当前发布的版本
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 耗时的操作---获取某个应用在AppStore上的信息，更改id就行
        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=1087640100"] encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *version = [[[dic objectForKey:@"results"]firstObject]objectForKey:@"version"];
        
        NSString *updateInfo = [[[dic objectForKey:@"results"]firstObject]objectForKey:@"releaseNotes"];
        
        //获得当前版本
        NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            if ( version &&![version isEqualToString:currentVersion]) {
                //有新版本
                NSString *message = [NSString stringWithFormat:@"有新版本发布啦!\n%@",updateInfo];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"前往更新", nil];
                [alertView show];
            }else{
                //已是最高版本
                NSLog(@"已经是最高版本");
            }
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *url = @"https://itunes.apple.com/cn/app/jian-kang+/id1087640100?mt=8&uo=4";
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}