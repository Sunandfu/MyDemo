//
//  MNVideoPlayViewController.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/24.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit
import BMPlayer
import SnapKit

class MNVideoPlayViewController: MNBaseController {
    
    var player = BMPlayer()
    var videoUrl = ""
    var videoTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupPlayer()
        let asset = BMPlayerResource(url: URL(string: videoUrl)!,
                                     name: videoTitle)
        self.player.setVideo(resource: asset)
    }

    func setupPlayer() {
        player = BMPlayer()
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        // Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.dismiss(animated: true, completion: nil)
        }
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
