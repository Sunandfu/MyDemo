**s2s请求文档**

### 1.1 广告请求接口

Domain:http://www.yunqingugm.com:8081/

method:post

url:/yd3/mview

param:?uid={uid}&mid={mid}

data:
param | type | nullAble | description
---|---|---|---
version |str|必选|服务版本号,现为2.0
uid|str|必选|一次请求的唯一标识,接入方使用uuid随机数生成,sdk使用请求配置获取
c_type|int|必选| 1：api(server-to-server) 2：sdk  3:wap
mid|str|必选|媒体位ID
os|str|必选|操作系统 iOS系统="IOS",安卓系统="ANDROID"
osv|str|必选|操作系统版本
remoteip|str|必选|ipv4地址
ua|str|必选|User Agent
adCount|int|必选|广告个数,一般填写为1
adplaceWidth|int|必选|广告位宽度
adplaceHeight|int|必选|广告位宽度
ts|int|必选|当前设备时间戳
|
idfa|str|可选|iOS必选
imsi|str|可选|移动标识
imei|str|可选|安卓必选
androidid|str|可选|安卓必选
osl|str|可选|安卓必选,安卓API版本
|
devicetype|int|可选|设备类型 // 1=手机;2=平板
width|int|可选|手机屏幕宽度
height|int|可选|手机屏幕高度
make|str|可选|手机厂商
brand|str|可选|手机品牌
model|str|可选|手机型号
density|int|可选|屏幕密度
orientation|int|可选|屏幕方向 0=位置;1=竖屏;2=横屏
postion|int|可选|1=顶端可见；2=底端可见；3=弹框；4=全屏
operator|int|可选|运营商: 0-未知;1-中国移动;2-中国电信;3-中国联通,4-其他运营商
networktype|int|必选|手机网络类型	0-未知；1-WiFi；2-蜂窝数据网络未知；3-2g;4-3g;5-4g
dpi|int|可选|像素
|
appid|str|可选|app包名
appname|str|可选|app名称
appver|str|可选|app版本
|
geo_type|int|可选|1=全球卫星定位系统坐标系;2=国家测绘局坐标系;3=百度坐标系
geo_latitude|double|可选|纬度
geo_longitude|double|可选|经度
geo_time|int|可选|精确到秒
|
last_ad_ids|str|可选|最近展示的广告ID
language|str|可选|语言,默认为"zh"
image|object|可选|图片尺寸

image具体定义
名称|类型|是否可选|描述
---|---|---|---
width|int|必选|图片宽度
height|int|必选|图片高度


请求示例:
{
    "version": "2.0",
    "appver": "1.0",
    "c_type": "2",
    "mid": "fzd_android_icon",
    "uid": "173c755c95fe4d99922771345a06e2b7",
    "os": "ANDROID",
    "mac": "02:00:00:00:00:00",
    "osv": "8.1.0",
    "osl": "27",
    "language": "zh",
    "networktype": "1",
    "make": "Google",
    "brand": "google",
    "model": "Pixel",
    "devicetype": 1,
    "imei": "352531081100750",
    "androidid": "283823d0e5fa4cd7",
    "idfa": "",
    "adCount": 1,
    "last_ad_ids": "",
    "dpi": 420,
    "width": 1080,
    "height": 1794,
    "orientation": 1,
    "appid": "com.xcloudtech.locate",
    "appname": "ydsdk",
    "ts": 1536121025470,
    "image": {
        "width": "100",
        "height": "100"
    }
}
### 1.2 广告应答接口
应答接口中返回信息
名称 | 类型 | 是否可选 |描述
---|---|---|---
requestId | str | 必选 | 请求传递的唯一标识
ret|int|必选|返回结果标识:0=成功;-1=失败
adInfo|object|可选|ret=0时必选

adinfo对象定义说明:
adid|str|必选|广告唯一标识,下载类必填
---|---|---|---
click_url|str|必选|点击地址
creative_type|int|必选|创意类型:1=图片；2=图文；3=文字；4=html
ad_type|int|必选|广告类型: 1=横幅;2=插屏; 7=开屏; 3=信息流; 4=icon;
ac_type|int|必选|响应类型1=下载app; 2=打开网页; 3=未知; 4=广电通宏替换;5=广点通追加url; 6=唤起app; 7=唤起小程序
click_position|int|必选|是否追加点击坐标:1=追加; 2=不追加点击坐标;
impress_notice_urls|array|必选|展示 上报曝光url
click_notice_urls|array|必选|点击上报url
title|str|可选|图文,文字类型必选
description|str|可选|描述
htmlStr|str|可选|返回的html链接,html类型必选
img_url|str|可选|广告图片url 图片,图文必选
wxAppId|str|可选|微信开放平台的应用appId ac_type=7必填
miniProgramOriginId|str|可选|小程序原始ID  ac_type = 7必填
app_package |str|可选|应用包名
app_size|string|可选|应用大小
logo_icon|str|可选|应用logo
before_impress_notice_urls|array|可选|返回广告后，展示广告前的上曝url
download_start_notice_urls|array|可选|下载开始上报,ac_type=1必选
download_notice_urls|array|可选|下载完成上报,ac_type=1必选
install_start_notice_urls|array|可选|安装开始上报
install_notice_urls|array|可选|安装完成上报,ac_type=1必选
open_notice_urls|array|可选|安装完成后打开应用上报
replaceImgUrl|str|可选|替换图片url 
width|int|可选|广告宽度
height|int|可选|广告高度
reqDownloadUrl|str|可选|特殊下载请求地址
返回结果示例:

{
    "adInfo": {
        "ac_type": 2,
        "ad_type": 4,
        "click_notice_urls": [
            "http://www.yunqingugm.com:8082/log/newMclick?advId=5&advtp=4&sid=H4sIAAAAAAAAAAXBxwEAIAgEsJVoAvek6P4jmSSVm12pw7xeHUUWvRq600%2BJFo10YHLq3M0JYyWg%0AXxsuRNeS4cfXpSAf8hewNVAAAAA%3D&pid=173c755c95fe4d99922771345a06e2b7&mid=fzd_android_icon&os=ANDROID&osv=8.1.0&ip=219.143.81.151&make=Google&model=Pixel&country=CHN&province=110000&city=null&isDd=0&ctype=1&ua=PostmanRuntime%2F7.3.0&rf=0&clickId=__CLICK_ID__"
        ],
        "click_url": "http://139.199.129.166:8085/mclick?host=http%3A%2F%2Fsle.semzyzh.com%3A8070%2Fdc%2Fredirect%3Fm%3Defe93778&adId=1172&userId=17&bid=2c1f8300b8e64feb85db5597eb753132&cn=1&mId=1286&pid=zhike1&ip=219.143.81.151&ua=PostmanRuntime%2F7.3.0&country=CHN&province=110000&city=null&isp=&carriers=&device=Google&devicetype=1&browser=&os=Android&osver=8.1.0&conType=0&invType=2&invSelId=null&invSel=null&invAppId=zhike1&invApp=null&sId=352531081100750",
        "creative_type": 1,
        "height": 128,
        "img_url": "http://creative.jdkic.com/img/96ddf56808114b07b7a6cc65d61c1c24.png",
        "impress_notice_urls": [
            "http://139.199.129.166:8085/winnotice?pri=0&adId=1172&userId=17&bid=2c1f8300b8e64feb85db5597eb753132&cn=1&mId=1286&pid=zhike1&ip=219.143.81.151&ua=PostmanRuntime%2F7.3.0&country=CHN&province=110000&city=null&isp=&carriers=&device=Google&devicetype=1&browser=&os=Android&osver=8.1.0&conType=0&invType=2&invSelId=null&invSel=null&invAppId=zhike1&invApp=null&sId=352531081100750",
            "http://www.yunqingugm.com:8082/log/newMimpr?advId=5&advtp=4&sid=H4sIAAAAAAAAAAXBxwEAIAgEsJVoAvek6P4jmSSVm12pw7xeHUUWvRq600%2BJFo10YHLq3M0JYyWg%0AXxsuRNeS4cfXpSAf8hewNVAAAAA%3D&pid=173c755c95fe4d99922771345a06e2b7&mid=fzd_android_icon&os=ANDROID&osv=8.1.0&ip=219.143.81.151&make=Google&model=Pixel&country=CHN&province=110000&city=null&isDd=0&ctype=1&ua=PostmanRuntime%2F7.3.0&rf=0"
        ],
        "width": 128
    },
    "requestId": "173c755c95fe4d99922771345a06e2b7",
    "ret": "0"
}

{
    advertiser =     (
                {
            adplaces =             (
                                {
                    adPlaceId = 900546910;
                    advertiserId = 71;
                    appId = 5000546;
                    type = 3;
                    version = "3.0";
                }
            );
            advertiserId = 71;
            frequencyDay = 10000;
            frequencyHour = 1000;
            frequencyMin = 100;
            isChina = 1;
            isNative = 0;
            name = "\U5934\U6761";
            priority = 1;
            targetCountry = 0;
            type = 2;
            weight = 0;
        },
                {
            adplaces =             (
                                {
                    adPlaceId = 1080215124193862;
                    advertiserId = 46;
                    apiKey = "";
                    appId = 1105344611;
                    packageName = "";
                    type = 3;
                    version = "2.0";
                }
            );
            advertiserId = 46;
            isChina = 1;
            isNative = 0;
            name = "\U5e7f\U70b9\U901a";
            priority = 1;
            targetCountry = 0;
            type = 2;
            weight = 0;
        }
    );
    frequencyDay = 99999;
    frequencyHour = 9999;
    frequencyMin = 9999;
    ret = 0;
    uuid = 88da43d085254b5ab4a1c769bb11bc0c;
}
