# Singular-SKAdNetwork-App
示例应用程序演示了将SKAdNetwork作为广告网络、出版商和广告商实施所需的逻辑。

本回购协议包含：
1. 广告客户示例应用程序
2. Publisher示例应用程序
3. 模拟广告网络API（包括广告签名）的服务器

***Note: to run the sample apps use XCode 12 (currently in beta)***

## 如何使用广告客户示例应用程序
- 打开 `SingularAdvertiserSampleApp.xcodeproj`
- 运行应用程序并按照屏幕上的说明进行操作

## 如何使用广告主示例应用程序
- 打开 `SingularPublisherSampleApp.xcodeproj`
- 确保 `skadnetwork_server.py `正在运行（以下说明）
- 修改 `ViewController.m `中的常量占位符以设置您自己的参数
- 按照 `ViewController.m `中的步骤从 `showaddclick `开始
- 运行应用程序并按照屏幕上的说明进行操作

## 如何运行skadnetwork_server.py
- 将您的私钥（请参阅下面的如何生成）放在名为`key.pem的文件中与服务器相同的目录中`
- `cd skadnetwork-server`
- `pip install -r requirements.txt` （确保您正在使用Python 3）
- `python skadnetwork_server.py`

现在，您应该有一个服务器监听端口8000，该端口为发布者示例应用程序提供广告网络响应。

## 如何生成您的公钥-私钥对
- SKAdNetwork使用带有 `prime192v1 `曲线的ECDSA密钥对，通过以下方式生成：\
`openssl ecparam -name prime192v1 -genkey -noout -out companyname_skadnetwork_private_key.pem`
- 有关更多详细信息，请参见苹果的说明[点击此处](https://developer.apple.com/documentation/storekit/skadnetwork/registering_an_ad_network)
- 苹果已经两次更改了有关签名算法的说明，因此请确保ADSServer使用的ECDSA曲线与您创建私钥时使用的曲线相同
\
\
\
要了解更多关于Singular访问的信息：[https://www.singular.net[https://www.singular.net）
