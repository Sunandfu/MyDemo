# WaterWaveView
水波纹的动画效果 . a water wave view.

## ScreenShot
![VVWaterWaveViewDemo](ScreenShot/VVWaterWaveViewDemo.gif)


## CocoaPods
```
platform :ios, '7.0'
pod 'VVWaterWaveView'
```


## Usage

1.creat a VVWaterWaveView instance, you can drag a view to your Storyboard and set the view's custom class to VVWaterWaveView.

2.set properties

```objc

self.waterWaveView.percent = 0.5; // 百分比
self.waterWaveView.amplitude = 8.0; // 幅度
self.waterWaveView.waveLayerColorArray = @[
                                           [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:0.5],
                                           [UIColor colorWithRed:131/255.0 green:169/255.0 blue:235/255.0 alpha:1.0]
                                          ];

```

3.start animation

```objc
[self.waterWaveView startWave];
```