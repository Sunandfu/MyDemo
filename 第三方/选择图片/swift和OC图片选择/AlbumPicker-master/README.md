AlbumPicker
===
类似于微信里集成的相册功能，可以选择要上传照片或者视频

-----
选择与预览照片：<br>
![](https://github.com/GGGHub/AlbumPicker/raw/master/AlbumPicker/AlbumPicker.gif "选择照片")
![](https://github.com/GGGHub/AlbumPicker/raw/master/AlbumPicker/Preview.gif "预览照片")<br>

-----
**关于AlbumPicker：**
* 分别用Swift与Objective-C编写两个版本
* 可以选择相册里面的所有资源，也可以只设置选择图片
* 根据要求限制选取资源的最大数量，默认没有限制

## 安装
### Objective-C
1. 打开`AlbumPicker.xcworkspace`工作区选择`AlbumPicker`项目
2. 把项目里的`LSYAlbumPicker_OC`文件及里面的所有文件拷贝到其他`Objective-C`项目中
3. 由于项目中用到很多宏定义，所以需要把`AlbumPicker-prefix.pch`里面自定义宏拷贝到其他项目中的`.pch`文件中

### Swift
1. 基于`Xcode 6.4 Swift 1.2`编译正常，低版本或者高版本的`Xcode`可能会因为`Swift`版本不同而编译不通过，
2. 打开`AlbumPicker.xcworkspace`工作区选择`AlbumPicker_Swift`项目
3. 把项目里的`LSYAlbumPicker_Swift`文件以及里面所有文件拷贝到其他`Swift`项目中

## 使用
### 导入头文件
#### Objective-C

``` objective-c
#import "LSYAlbumCatalog.h"
```
在该项目里用的是自定义的导航栏，可以根据项目的需求来改变导航栏样式。所以在该项目里导入了两个头文件

``` objective-c
#import "LSYAlbumCatalog.h"
#import "LSYNavigationController.h"
```
#### Swift
Swift直接使用即可

### 打开相册
#### Objective-C

``` objective-c
    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    albumCatalog.delegate = self;
    LSYNavigationController *navigation = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    [self presentViewController:navigation animated:YES completion:^{
    }];
```
#### Swift
``` swift
    var albumCatalog:LSYAlbumCatalog! = LSYAlbumCatalog()
    albumCatalog.delegate = self
    var navigation:LSYNavigationController! = LSYNavigationController(rootViewController:albumCatalog)
    self.presentViewController(navigation, animated: true) { () -> Void in
            
        }
```

### 代理实现
#### Objective-C 
实现`LSYAlbumCatalogDelegate`的方法

``` objective-c
-(void)AlbumDidFinishPick:(NSArray *)assets
{
    for (ALAsset *asset in assets) {
        if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
            UIImage * img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        }
        else if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypeVideo"]){
            NSURL *url = asset.defaultRepresentation.url;
        }
    }
}

```

#### Swift
```swift
    func AlbumDidFinishPick(assets: NSArray) {
        for asset in assets {
            if  (asset as!ALAsset).valueForProperty("ALAssetPropertyType").isEqual("ALAssetTypePhoto") {
                var img = UIImage(CGImage: (asset as! ALAsset).defaultRepresentation().fullResolutionImage().takeUnretainedValue());
            }
            else if (asset as!ALAsset).valueForProperty("ALAssetPropertyType").isEqual("ALAssetTypeVideo") {
                var url = (asset as! ALAsset).defaultRepresentation().url()
            }
        }
    }
```
### 选择资源种类
#### Objective-C
选择相册中的所有资源，并且设置最多选择的数量
``` objective-c
    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    albumCatalog.maximumNumberOfSelectionMedia = 5;
```
只选择相册中的相片，并且设置最多选择的数量
``` objective-c
    LSYAlbumCatalog *albumCatalog = [[LSYAlbumCatalog alloc] init];
    albumCatalog.maximumNumberOfSelectionPhoto = 5;
```
#### Swift
选择相册中的所有资源，并且设置最多选择的数量
``` swift
    var albumCatalog:LSYAlbumCatalog! = LSYAlbumCatalog()
    albumCatalog.maximumNumberOfSelectionMedia = 5
```
只选择相册中的相片，并且设置最多选择的数量
```swift
    var albumCatalog:LSYAlbumCatalog! = LSYAlbumCatalog()
    albumCatalog.maximumNumberOfSelectionPhoto = 5
```
### 资源上传
#### Objective-C
``` objective-c
-(void)AlbumDidFinishPick:(NSArray *)assets
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("uploadImg", NULL);
    dispatch_async(queue, ^{
        for (ALAsset *asset in assets) {
            if ([[asset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
                //执行要上传图片的操作...
                void (^uploadImg) (BOOL isFinish) = ^(BOOL isFinish){
                  //上传完成后回调
                    dispatch_semaphore_signal(sem);
                };
            }
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        }
    });
}
```
#### Swift
``` swift
    func AlbumDidFinishPick(assets: NSArray) {
        var sem = dispatch_semaphore_create(0);
        var queue = dispatch_queue_create("uploadImg", nil)
        dispatch_async(queue, { () -> Void in
            for asset in assets {
                if  (asset as!ALAsset).valueForProperty("ALAssetPropertyType").isEqual("ALAssetTypePhoto") {
                    //执行要上传图片的操作...
                    var uploadImag = {(isFinish:Bool) -> Void in
                        //上传完成后回调
                         dispatch_semaphore_signal(sem);
                    }
                }
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
        })
    }
```
