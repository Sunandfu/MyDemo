# CityPicker
选择城市，一句代表搞定选择城市框、

# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/cityPicker.gif)


# How To Use

```ruby
#import "WSCityPicker.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)


WSCityPicker *wsPk = [[WSCityPicker alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
[self.view addSubview:wsPk];


[wsPk setBlock:^void(NSString *provinceStr,NSString *cityStr,NSString *districtStr){

    [btn setTitle:[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,districtStr] forState:UIControlStateNormal];
}];



```