- (void)countDown
{
    __block int timeout = 60; //倒计时时间
    [self.timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.timeBtn setTitleColor:XJCustomColorRGB(0, 182, 120) forState:UIControlStateNormal];
                [self.timeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            __block NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if ([strTime intValue] <= 0)
                {
                    strTime = @"60";
                }
                
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@秒重发验证码", strTime] forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
