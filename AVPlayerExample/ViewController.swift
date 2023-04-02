//
//  ViewController.swift
//  AVPlayerExample
//
//  Created by  Eugene Mammie on 4/2/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    var videoPlayer : AVPlayer?
    
    static let contentURL : URL! = URL(string:"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
                                        

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        let asset = AVAsset(url: ViewController.contentURL)
        let playerItem = AVPlayerItem(asset: asset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        let layer = AVPlayerLayer(player: videoPlayer)
        layer.frame = self.view.bounds
        
        view.layer.addSublayer(layer)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let player = videoPlayer {
            player.play()
            
        }
    }

}

