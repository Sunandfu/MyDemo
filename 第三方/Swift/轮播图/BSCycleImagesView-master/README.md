# BSCycleImagesView

## Overview

![BSCycleImagesViewGIF.gif](https://github.com/blurryssky/BSCycleImagesView/blob/master/ScreenShots/BSCycleImagesViewGIF.gif)

## Installation

> use_frameworks!

> pod 'BSCycleImagesView'


## Usage

### Supple an array with models as datasource

```swift
//auto scroll stay seconds each page, set 0 to stop
cycleImagesView.timeInterval = 2

//assume there is 4 jpg in bundle
var images: [UIImage] = []
for i in 1...4 {
    let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("\(i)", ofType: ".jpg")!)!
    images.append(image)
}
        
//set local images
cycleImagesView.images = images
        
//or set image urls, the view will be show after all images downloaded, and will cache images
cycleImagesView.imageURLs = ["http://img4.duitang.com/uploads/item/201403/31/20140331094819_dayKx.jpeg",
"http://i1.17173cdn.com/9ih5jd/YWxqaGBf/forum/images/2014/08/05/201143hmymxmizwmqi86yi.jpg",
"http://p1.image.hiapk.com/uploads/allimg/150413/7730-150413103526-51.jpg",
"http://s9.knowsky.com/bizhi/l/55001-65000/2009529123133602476178.jpg"]

//if you need tap
cycleImagesView.imageDidSelectedClousure = { index in
    print(index)
}
```

```
