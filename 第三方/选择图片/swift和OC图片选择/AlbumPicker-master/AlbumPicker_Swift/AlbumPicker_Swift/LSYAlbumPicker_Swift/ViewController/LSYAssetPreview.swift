//
//  LSYAssetPreview.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/6.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
protocol LSYAssetPreviewDelegate:class{
    func AssetPreviewDidFinishPick(assets:NSArray)->Void
}
@objc class LSYAssetPreview: UIViewController {
    var assets :NSMutableArray!
    var albumPickerCollection:UICollectionView!
    weak var delegate:LSYAssetPreviewDelegate!
    var selectedAssets:NSMutableArray!
    var previewScrollView:UIScrollView!{
        didSet{
            previewScrollView.backgroundColor = UIColor.blackColor()
            previewScrollView.pagingEnabled = true
            previewScrollView.delegate = self
            previewScrollView.showsHorizontalScrollIndicator = false
            previewScrollView.showsVerticalScrollIndicator = false
            self.view.addSubview(previewScrollView)
        }
    }
    var previewNavBar:LSYAssetPreviewNavBar!{
        didSet{
            previewNavBar.backgroundColor = UIColor(red: 19.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 0.75)
            previewNavBar.delegate = self
            self.view.addSubview(previewNavBar)
        }
    }
    var previewToolBar:LSYAssetPreviewToolBar!{
        didSet{
            previewToolBar.backgroundColor = UIColor(red: 19.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 0.75)
            previewToolBar.delegate = self
            previewToolBar.setSendNumber(self.albumPickerCollection.indexPathsForSelectedItems()!.count)
            self.view.addSubview(previewToolBar)
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    private func setup() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.prefersStatusBarHidden()
        self.selectedAssets = NSMutableArray(array: self.assets)
        self.navigationController?.navigationBarHidden = true
        self.previewScrollView = UIScrollView(frame: CGRectMake(0, 0, LSYSwiftDefine.ViewSize(self.view).width,LSYSwiftDefine.ViewSize(self.view).height))
        self.previewNavBar = LSYAssetPreviewNavBar()
        self.previewToolBar = LSYAssetPreviewToolBar()
        self.setAssets()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    private func setAssets(){
        self.previewScrollView.contentSize = CGSizeMake(LSYSwiftDefine.ViewSize(self.view).width * CGFloat(self.assets.count), LSYSwiftDefine.ViewSize(self.view).height)
        for i in 0 ..< self.assets.count {
            let previewItem :LSYAssetPreviewItem = LSYAssetPreviewItem(frame: CGRectMake(LSYSwiftDefine.ViewSize(self.view).width * CGFloat(i),0, LSYSwiftDefine.ViewSize(self.view).width, LSYSwiftDefine.ViewSize(self.view).height))
            previewItem.delegate = self
            let model:LSYAlbumModel = self.assets[i] as!LSYAlbumModel
            previewItem.asset = model.asset
            self.previewScrollView.addSubview(previewItem)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewNavBar.frame = CGRectMake(0, 0, LSYSwiftDefine.ViewSize(self.view).width,64)
        self.previewToolBar.frame = CGRectMake(0, LSYSwiftDefine.ViewSize(self.view).height-44, LSYSwiftDefine.ViewSize(self.view).width, 44)
    }
}