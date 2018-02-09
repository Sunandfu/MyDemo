# GetWiFiIPAddressAndSSID
获取设备连接的Wifi的IP地址和Wifi名称

# PhotoShoot
![image](https://github.com/Zws-China/GetWiFiIPAddressAndSSID/blob/master/GetIP/GetIP/hhhh.jpeg)


# How To Use

```ruby
UILabel *SSID = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 300, 40)];
SSID.text = [NSString stringWithFormat:@"当前连接Wifi名称: %@",[WSGetWifi getSSIDInfo][@"SSID"]];
SSID.textColor = [UIColor whiteColor];
[self.view addSubview:SSID];


UILabel *ip = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 300, 40)];
ip.text = [NSString stringWithFormat:@"当前Wifi的IP地址: %@",[WSGetWifi getWiFiIPAddress]];
ip.textColor = [UIColor whiteColor];
[self.view addSubview:ip];


```
