# WSRollView
滚动背景，支持本地图片与网络图片，根据图片的宽高比自动识别左右滚动或上下滚动。支持gif图片滚动



# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/wsroll.gif)
![image](https://github.com/Zws-China/.../blob/master/wsroll2.gif)
![image](https://github.com/Zws-China/.../blob/master/wsroll3.gif)


# How To Use

```ruby
WSRollView *wsRoll = [[WSRollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
wsRoll.backgroundColor = [UIColor whiteColor];
wsRoll.timeInterval = 0.01; //移动一次需要的时间
wsRoll.rollSpace = 0.5; //每次移动的像素距离
wsRoll.image = [UIImage imageNamed:@"111.jpg"];//本地图片
//wsRoll.rollImageURL = @"http://jiangsu.china.com.cn/uploadfile/2016/0122/1453449251090847.jpg"; //网络图片地址
[wsRoll startRoll]; //开始滚动
[self.view addSubview:wsRoll];




```

