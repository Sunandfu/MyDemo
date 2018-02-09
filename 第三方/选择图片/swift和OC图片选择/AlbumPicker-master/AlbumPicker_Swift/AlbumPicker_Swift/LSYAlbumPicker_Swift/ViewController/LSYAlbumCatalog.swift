//
//  LSYAlbumCatalog.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/4.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

//MARK:唯类协议
protocol LSYAlbumCatalogDelegate:class {
    func AlbumDidFinishPick(assets:NSArray)->Void
}
@objc class LSYAlbumCatalog:UIViewController {
    let kAlbumCatalogCellIdentifer:String = "albumCatalogCellIdentifer"
    
    var maximumNumberOfSelectionPhoto:Int = 0{
        didSet{
            LSYAlbum.sharedAlbum().assetsFilter = ALAssetsFilter.allPhotos()
        }
    }
    var maximumNumberOfSelectionMedia:Int = 0{
        didSet{
            LSYAlbum.sharedAlbum().assetsFilter = ALAssetsFilter.allAssets()
        }
    }
    weak var delegate:LSYAlbumCatalogDelegate!
    var dataArray:NSMutableArray!
    private var albumTabView:UITableView!{
        didSet{
            albumTabView.delegate = self
            albumTabView.dataSource = self
            albumTabView.rowHeight = 70
            albumTabView.tableFooterView = UIView()
            self.view.addSubview(albumTabView)
        }
    }
    private func setup(){
        self.dataArray = NSMutableArray()
        self.albumTabView = UITableView(frame: CGRectMake(0, 15, LSYSwiftDefine.ViewSize(self.view).width, LSYSwiftDefine.ViewSize(self.view).height-15), style: UITableViewStyle.Plain)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "照片"
        self.view.backgroundColor = UIColor.whiteColor()
        self.setup()
        LSYAlbum.sharedAlbum().setupAlbumGroups { (groups) -> () in
            self.dataArray = groups
            self.albumTabView.reloadData()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LSYAlbumCatalog.backMainView))
        
    }
    func backMainView(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
