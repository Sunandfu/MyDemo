//
//  LSYAlbumPicker.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/5.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

protocol LSYAlbumPickerDelegate : class{
    func AlbumPickerDidFinishPick(assets:NSArray)
}
class LSYAlbumPicker: UIViewController {
    let thumbnailLength :CGFloat = (UIScreen.mainScreen().bounds.size.width-5*5)/4
    let albumPickerCellIdentifer :String = "albumPickerCellIdentifer"
    var group:ALAssetsGroup!
    var maxminumNumber:Int = 0
    weak var delegate:LSYAlbumPickerDelegate!
    
    var albumAssets:NSMutableArray!
    var assetsSort:NSMutableArray!
    var selectedAssets:NSMutableArray!{
        get{
            let selectArray = NSMutableArray()
            for index in self.assetsSort{
                selectArray.addObject(self.albumAssets[index.item])
            }
            return selectArray;
        }
    }
    var selectNumber:Int = 0 {
        didSet{
            self.pickerButtomView.setSendNumber(selectNumber)
        }
    }
    var pickerButtomView:LSYPickerButtomView!{
        didSet{
            pickerButtomView.delegate = self
            pickerButtomView.setSendNumber(self.selectNumber)
            self.view.addSubview(pickerButtomView)
        }
    }
    var flowLayout:UICollectionViewFlowLayout!{
        didSet{
            flowLayout.itemSize = CGSizeMake(self.thumbnailLength, self.thumbnailLength)
            flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
            flowLayout.minimumInteritemSpacing = 5;
            flowLayout.minimumLineSpacing = 5;
        }
    }
    var albumView:UICollectionView!{
        didSet{
            albumView.allowsMultipleSelection = true;
            albumView.delegate = self
            albumView.dataSource = self
            albumView.backgroundColor = UIColor.whiteColor()
            albumView.alwaysBounceVertical = true
            albumView.registerClass(LSYAlbumPickerCell.classForCoder(), forCellWithReuseIdentifier: self.albumPickerCellIdentifer)
            self.view.addSubview(albumView)
        }
    }
    private func setup(){
        self.title = self.group.valueForProperty(ALAssetsGroupPropertyName) as? String
        self.assetsSort = NSMutableArray()
        self.flowLayout = UICollectionViewFlowLayout()
        self.albumView = UICollectionView(frame: CGRectMake(0,0, LSYSwiftDefine.ViewSize(self.view).width, LSYSwiftDefine.ViewSize(self.view).height-44), collectionViewLayout: self.flowLayout)
        self.pickerButtomView = LSYPickerButtomView(frame: CGRectMake(0, LSYSwiftDefine.ViewSize(self.view).height-44, LSYSwiftDefine.ViewSize(self.view).width, 44))
        LSYAlbum.sharedAlbum().setupAlbumAssets(self.group, albumAssets: { (assets) -> () in
            self.albumAssets = assets
            self.albumView.reloadData()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.selectNumber = self.albumView.indexPathsForSelectedItems()!.count
    }
}