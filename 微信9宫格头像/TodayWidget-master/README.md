# TodayWidget
通知中心视图，下拉通知中心显示的内容

详细demo请看GitHub：[https://github.com/Zws-China/TodayWidget](https://github.com/Zws-China/TodayWidget)

# PhotoShoot
![这里写图片描述](http://img.blog.csdn.net/20170517150323267?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcXFfMjY1OTgwNzc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
![这里写图片描述](http://img.blog.csdn.net/20170517150406190?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcXFfMjY1OTgwNzc=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


# How To Use

```ruby
这个Demo是类似于Clips的widget，完整代码我已经上传到了github点这里,Demo里面注释比较详细.
1.创建Extension
　点击“File”->”New”->”Target”


（１）UI布局：系统默认，widget的View的x坐标是和Containing App的图标坐标的bottom相对应的(参照搜狐视频效果)，如果你想靠到左边去“越界”，要实现NCWidgetProviding代理方法- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets，这个defaultMarginInsets打印出来是{0, 47, 39, 0}，注意看x左边是0.
    - (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
        return UIEdgeInsetsZero;
    }


（２）View高度问题：有的时候运行程序，view显示不出来，这个时候你可能需要[self setPreferredContentSize:(CGSize)];。不仅如此，Demo中的widget是放置了个UITableView，设置它与View的AutoLayout，结果是没起作用。。。tableView的高度是随着Cell的减少而减少，但是View的高度缺固定在最初值。因此加上这句代码来限制

    // 调整高度,根据数组的值来确定Cell的个数，从而确定视图的高度
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 200));


 (3)点击todayWidget事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];

    NewsModel *model = [modelArray objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"iOSWidgetApp://action=openNewsID=%@",model.newsID];

    [self.extensionContext openURL:[NSURL URLWithString:string] completionHandler:nil];
}

- (void)moreAction {
    [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=openAPP"] completionHandler:nil];
}

 (4)处理点击事件  在AppDelegate.m中添加
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url);

    NSString* prefix = @"iOSWidgetApp://action=";
    if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
    NSString* action = [[url absoluteString] substringFromIndex:prefix.length];
    if ([action isEqualToString:@"openAPP"]) {
        //打开APP，不用处理
    }
    else if([action containsString:@"openNewsID="]) {

        NSString *IDString = [action substringFromIndex:@"openNewsID=".length];

        NewsDetailController *newsCtrl = [[NewsDetailController alloc]init];
        newsCtrl.newsID = IDString;
        UINavigationController *NAV = (UINavigationController*)self.window.rootViewController;
        [NAV pushViewController:newsCtrl animated:YES];
    }
}

    return  YES;
}



（5）喜欢的点个星。 (*^__^*)



```



