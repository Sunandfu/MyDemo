//延迟调用，2秒以后让self执行runLater:这个方法，参数就是sender
[self performSelector:@selector(runLater:) withObject:sender afterDelay:2];
//启动时间器，让self每隔0.01秒执行一次timeRun   //需要设置全局变量NSTimer *_timer;
_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
[[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//关闭时间器
[_timer invalidate];
/**
 例子
 - (void)btnClick:(UIButton *)sender
 {
 sender.selected = !sender.selected;
 if (sender.selected) {
 _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
 //启动时间器，让self每隔0.01秒执行一次timeRun
 } else {
 [_timer invalidate];
 //关闭时间器
 }
 }

 - (void)timeRun
 {
 int row = arc4random_uniform(8)+1;//产生随机数
 int num = arc4random_uniform(11)+1;
 UILabel *label = (UILabel *)[self.view viewWithTag:1];//通过tag找view
 label.text = [NSString stringWithFormat:@"第%d行 第%02d位",row,num];
 }

 */
//定时器
//定时器
self.timeout=TIMETEST; //倒计时时间
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
dispatch_source_set_event_handler(_timer, ^{
    
});
dispatch_resume(_timer);

//声明定时器  每秒执行60次
CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
[link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

//动画展示
//当前的透明度
CGFloat currentAlpha = self.circleImageView.alpha;

// 1.先实现隐藏和显示
//hidden alpha
if (currentAlpha == 1) {//隐藏
    self.circleImageView.alpha = 0;
}else{//显示
    
    self.circleImageView.alpha = 1;
}

// 2再添加动画 //透明度、缩放、旋转效果
// 2.1创建组动画
CAAnimationGroup *group = [CAAnimationGroup animation];

// 2.1 透明度动画
#warning 这里设置的透明度是图层opacity
CABasicAnimation *opacityAni = [CABasicAnimation animation];
opacityAni.keyPath = @"opacity";


// 2.2 缩放动画
CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animation];
scaleAni.keyPath = @"transform.scale";

// 2.3 旋转动画
CABasicAnimation *rotationAni = [CABasicAnimation animation];
rotationAni.keyPath = @"transform.rotation";

// 如果是要隐藏，透明度是由“显示“到”看不见“
if (currentAlpha == 1) {//隐藏
    opacityAni.fromValue = @1;
    opacityAni.toValue = @0;
    
    scaleAni.values = @[@1,@1.2,@0];
    
    //旋转的时候从原来的位置 逆时针 旋转45度
    rotationAni.fromValue = @0;
    rotationAni.toValue = @(-M_PI_4);
}else{
    //显示
    opacityAni.fromValue = @0;
    opacityAni.toValue = @1;
    
    scaleAni.values = @[@0,@1.2,@1];
    
    //显示的时，旋转是从 -M_PI_4开始
    rotationAni.fromValue = @(-M_PI_4);
    rotationAni.toValue = @0;
    
}

group.animations = @[opacityAni,scaleAni,rotationAni];
group.duration = 1.0;
[self.circleImageView.layer addAnimation:group forKey:nil];
//图标抖动动画
CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];

CGFloat angle = M_PI_4 * 0.1;
keyAnim.keyPath = @"transform.rotation";

keyAnim.values = @[@(-angle),@(angle),@(-angle)];
keyAnim.repeatCount = MAXFLOAT;
keyAnim.duration = 0.2;
[self.iconView.layer addAnimation:keyAnim forKey:@"shake"];











