//
//  RecordingViewController.swift
//  Camera using AvFoundation
//
//  Created by Digival on 04/08/23.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
    var videoUrl: URL?

    @IBOutlet weak var playerView: UIView!
    @IBOutlet var recordingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoPlayer = AVPlayer(url: videoUrl!)
        // create instance of playerlayer with videoPlayer
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        // set its videoGravity to AVLayerVideoGravityResizeAspectFill to make it full size
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // add it to your view
        playerLayer.frame = self.view.frame
        playerView.layer.addSublayer(playerLayer)
        // start playing video
        videoPlayer.play()
    }
  
}


