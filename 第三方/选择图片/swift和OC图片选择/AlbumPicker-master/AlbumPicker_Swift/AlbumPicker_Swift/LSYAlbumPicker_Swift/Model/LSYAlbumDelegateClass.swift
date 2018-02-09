//
//  LSYAlbumDelegateClass.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/4.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
//MARK:- LSYAlbumCatalog
//MARK:UITableViewDataSource,UITableViewDelegate
extension LSYAlbumCatalog:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : LSYAlbumCatalogCell! = tableView.dequeueReusableCellWithIdentifier(self.kAlbumCatalogCellIdentifer) as?LSYAlbumCatalogCell
        if cell == nil {
            cell = LSYAlbumCatalogCell(style: UITableViewCellStyle.Value1, reuseIdentifier: self.kAlbumCatalogCellIdentifer)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        cell.group = self.dataArray[indexPath.row] as? ALAssetsGroup
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let albumPicker:LSYAlbumPicker! = LSYAlbumPicker()
        albumPicker.group = self.dataArray[indexPath.row] as! ALAssetsGroup
        albumPicker.delegate = self
        if self.maximumNumberOfSelectionPhoto != 0{
            albumPicker.maxminumNumber = self.maximumNumberOfSelectionPhoto;
        }else if self.maximumNumberOfSelectionMedia != 0{
            albumPicker.maxminumNumber = self.maximumNumberOfSelectionMedia;
        }
        self.navigationController?.pushViewController(albumPicker, animated: true)
    }
}
//MARK:LSYAlbumPickerDelegate
extension LSYAlbumCatalog:LSYAlbumPickerDelegate
{
    func AlbumPickerDidFinishPick(assets: NSArray) {
        if self.delegate != nil {
            self.delegate.AlbumDidFinishPick(assets)
            self.backMainView()
        }
    }
}
//MARK:- LSYAlbumPicker
//MARK:UICollectionViewDelegate,UICollectionViewDataSource
extension LSYAlbumPicker:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumAssets.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:LSYAlbumPickerCell! = collectionView.dequeueReusableCellWithReuseIdentifier(self.albumPickerCellIdentifer, forIndexPath: indexPath) as? LSYAlbumPickerCell
        let model:LSYAlbumModel! = self.albumAssets[indexPath.row] as? LSYAlbumModel
        model.indexPath = indexPath
        cell.model = model
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model:LSYAlbumModel! = self.albumAssets[indexPath.row] as? LSYAlbumModel
        model.isSelect = !model.isSelect
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LSYAlbumPickerCell
        cell.setupIsSelect()
        self.selectNumber = collectionView.indexPathsForSelectedItems()!.count
        self.assetsSort.addObject(indexPath)
        
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let model:LSYAlbumModel! = self.albumAssets[indexPath.row] as? LSYAlbumModel
        model.isSelect = !model.isSelect
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LSYAlbumPickerCell
        cell.setupIsSelect()
        self.selectNumber = collectionView.indexPathsForSelectedItems()!.count
        self.assetsSort.removeObject(indexPath)
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.maxminumNumber != 0 {
            if !(self.maxminumNumber > collectionView.indexPathsForSelectedItems()!.count){
                let alert:UIAlertView! = UIAlertView(title: "提示", message: "最多只能选\(self.maxminumNumber)张图片", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return false
            }
            return true
        }
        else{
            return true
        }
    }
    
}
//MARK:LSYPickerButtomViewDelegate
extension LSYAlbumPicker:LSYPickerButtomViewDelegate{
    func sendButtonClick() {
        if self.delegate != nil{
            let assets:NSMutableArray = NSMutableArray()
            for model in self.selectedAssets{
                assets.addObject((model as! LSYAlbumModel).asset)
            }
            self.delegate.AlbumPickerDidFinishPick(assets)
        }
    }
    func previewButtonClick() {
        let assetPreview:LSYAssetPreview! = LSYAssetPreview()
        self.navigationController?.pushViewController(assetPreview, animated: true)
        assetPreview.assets = self.selectedAssets
        assetPreview.albumPickerCollection = self.albumView
        assetPreview.delegate = self
    }
}
//MARK:LSYAssetPreviewDelegate
extension LSYAlbumPicker:LSYAssetPreviewDelegate{
    func AssetPreviewDidFinishPick(assets: NSArray) {
        if self.delegate != nil {
            self.delegate.AlbumPickerDidFinishPick(assets)
        }
    }
}
//MARK:- LSYAssetPreview
//MARK:LSYAssetPreviewItem UIScrollViewDelegate
extension LSYAssetPreviewItem:UIScrollViewDelegate{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.assetImageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let originalSize = self.previewScrollView.bounds.size
        let contentSize = self.previewScrollView.contentSize
        let offsetX = (originalSize.width > contentSize.width) ? (originalSize.width - contentSize.width) : 0
        let offsetY = (originalSize.height > contentSize.height) ? (originalSize.height - contentSize.height) : 0
        assetImageView.center = CGPointMake(contentSize.width/2 + offsetX,(originalSize.height > contentSize.height) ? originalSize.height/2 : contentSize.height/2 + offsetY)
    }
}
//MARK:LSYAssetPreview UIScrollViewDelegate,LSYAssetPreviewNavBarDelegate,LSYAssetPreviewToolBarDelegate
extension LSYAssetPreview:UIScrollViewDelegate,LSYAssetPreviewNavBarDelegate,LSYAssetPreviewToolBarDelegate{
    func selectButtonClick(selectButton: UIButton) {
        if self.previewScrollView.decelerating {
            return
        }
        let assetNumber = Int(self.previewScrollView.contentOffset.x / LSYSwiftDefine.ViewSize(self.view).width)
        
        let model:LSYAlbumModel = self.assets[assetNumber] as!LSYAlbumModel
        self.previewNavBar.selectButton.selected = !model.isSelect
        if !model.isSelect {
            self.albumPickerCollection.selectItemAtIndexPath(model.indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
            self.selectedAssets.addObject(model)
            if self.albumPickerCollection.delegate != nil {
                self.albumPickerCollection.delegate?.collectionView!(self.albumPickerCollection, didSelectItemAtIndexPath: model.indexPath)
            }
        }
        else {
            self.albumPickerCollection.deselectItemAtIndexPath(model.indexPath, animated: false)
            self.selectedAssets.removeObject(model)
            if self.albumPickerCollection.delegate != nil {
                self.albumPickerCollection.delegate?.collectionView!(self.albumPickerCollection, didDeselectItemAtIndexPath: model.indexPath)
            }
        }
        self.previewToolBar.setSendNumber(self.albumPickerCollection.indexPathsForSelectedItems()!.count)
    }
    func backButtonClick(backButton: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func sendButtonClick(sendButton: UIButton) {
        if self.delegate != nil {
            let assets:NSMutableArray = NSMutableArray()
            for model in self.selectedAssets{
                assets.addObject((model as! LSYAlbumModel).asset)
            }

            self.delegate.AssetPreviewDidFinishPick(assets)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let assetNumber = Int(scrollView.contentOffset.x / LSYSwiftDefine.ViewSize(self.view).width)
        let model:LSYAlbumModel = self.assets[assetNumber] as!LSYAlbumModel
        self.previewNavBar.selectButton.selected = model.isSelect
    }
}
//MARK:LSYAssetPreviewItemDelegate
extension LSYAssetPreview:LSYAssetPreviewItemDelegate{
    func hiddenBarControl() {
        self.previewNavBar.hidden = !self.previewNavBar.hidden
        self.previewToolBar.hidden = !self.previewToolBar.hidden
    }
}
    