//
//  ViewController.swift
//  AlbumPicker_Swift
//
//  Created by Labanotation on 15/8/10.
//  Copyright (c) 2015年 com.okwei. All rights reserved.
//

import UIKit
import AssetsLibrary
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openAlbum(sender: AnyObject) {
        let albumCatalog:LSYAlbumCatalog! = LSYAlbumCatalog()
        albumCatalog.delegate = self
        let navigation:LSYNavigationController! = LSYNavigationController(rootViewController:albumCatalog)
        albumCatalog.maximumNumberOfSelectionMedia = 5
        self.presentViewController(navigation, animated: true) { () -> Void in
            
        }
    }


}
extension ViewController:LSYAlbumCatalogDelegate{
    func AlbumDidFinishPick(assets: NSArray) {
        for asset in assets {
            if  (asset as!ALAsset).valueForProperty("ALAssetPropertyType").isEqual("ALAssetTypePhoto") {
                var img = UIImage(CGImage: (asset as! ALAsset).defaultRepresentation().fullResolutionImage().takeUnretainedValue());
            }
            else if (asset as!ALAsset).valueForProperty("ALAssetPropertyType").isEqual("ALAssetTypeVideo") {
                var url = (asset as! ALAsset).defaultRepresentation().url()
            }
        }
//        var sem = dispatch_semaphore_create(0);
//        var queue = dispatch_queue_create("uploadImg", nil)
//        dispatch_async(queue, { () -> Void in
//            for asset in assets {
//                if  (asset as!ALAsset).valueForProperty("ALAssetPropertyType").isEqual("ALAssetTypePhoto") {
//                    //执行要上传图片的操作...
//                    var uploadImag = {(isFinish:Bool) -> Void in
//                        //上传完成后回调
//                         dispatch_semaphore_signal(sem);
//                    }
//                }
//                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//            }
//        })
    }
    
}
