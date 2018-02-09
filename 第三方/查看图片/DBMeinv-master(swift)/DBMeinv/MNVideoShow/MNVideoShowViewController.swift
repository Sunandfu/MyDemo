//
//  MNVideoShowViewController.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/24.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import MJRefresh


class MNVideoShowViewController: MNBaseController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var vedioCollectionView: UICollectionView!
    var viewModel = MNVideoShowViewModel()
    var palyingVideo = MNVideo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionview), name: NSNotification.Name("populateVideoshttp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo(notifier:)), name: NSNotification.Name("populateVideosPlayUrlHttp"), object: nil)
        
        self.setupCollectionView()
        self.configureRefresh()
        self.getVideoData(isloadMore: false)
        
    }
    
    func setupCollectionView() {
        self.vedioCollectionView.scrollsToTop = true
    }
    
    func configureRefresh() {
        self.vedioCollectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("header")
            self.getVideoData(isloadMore: false)
        })
        self.vedioCollectionView?.mj_footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            print("footer")
            self.getVideoData(isloadMore: true)
        })
    }
    
    func getVideoData(isloadMore: Bool) -> Void {
        HUD.show(.progress)
        viewModel.populateVieos(loadMore: isloadMore)
    }
    
    @objc func reloadCollectionview() -> Void {
        DispatchQueue.main.async(execute: {
            self.endRefresh()
            if self.viewModel.populateSuccess {
                HUD.hide(animated: true)
                self.vedioCollectionView.reloadData()
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        })
        
    }
    
    @objc func playVideo(notifier:Notification) {
        DispatchQueue.main.async(execute: {
            if self.viewModel.populateSuccess {
                HUD.hide(animated: true)
                // 播放视频
                print(notifier.object ?? "")
                if (notifier.object as! NSString).length > 0 {
                    let playVC = MNVideoPlayViewController()
                    playVC.videoUrl = notifier.object as! String
                    playVC.videoTitle = self.palyingVideo.title
                    self.present(playVC, animated: true, completion: nil)
                } else {
                    HUD.flash(.error, delay: 1.0)
                }
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        })
    }
    
    // MARK: Refresh
    
    func endRefresh() -> Void {
        if self.vedioCollectionView.mj_header != nil{
            self.vedioCollectionView?.mj_header.endRefreshing()
        }
        if self.vedioCollectionView.mj_footer != nil{
            self.vedioCollectionView?.mj_footer.endRefreshing()
        }
    }
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.videos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MNVideoCollectionViewCellIdentifier", for: indexPath) as! MNVideoCollectionViewCell
        let model: MNVideo = viewModel.videos.object(at: indexPath.row) as! MNVideo;
        cell.titleLabel.text = model.title
        let imageUrl = URL(string: model.thumbnailUrl)
//        let userUrl = URL(string: model.userPhotoUrl)
        cell.bigImageView.kf.setImage(with: imageUrl)
//        cell.userPhotoImageView.kf.setImage(with: userUrl)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: MNVideo = viewModel.videos.object(at: indexPath.row) as! MNVideo;
        palyingVideo = model;
        HUD.show(.progress)
        viewModel.populateVieosUrl(targetUrl: model.videoUrl)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
