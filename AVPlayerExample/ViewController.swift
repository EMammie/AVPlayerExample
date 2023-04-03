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
    private var timeObserverToken: Any?
    
    static let contentURL : URL! = URL(string:"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
                                        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Creating AVAsset and AVPlayer
        let asset = AVAsset(url: ViewController.contentURL)
        let playerItem = AVPlayerItem(asset: asset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        //Periodic Time Observation every 0.5 a second
        timeObserverToken = videoPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 5,timescale: 10),
                                             queue: DispatchQueue.main) { [weak self] time in
            if let videoPlayer = self?.videoPlayer, let timeValue = self?.createTimeString(time: Float(videoPlayer.currentTime().seconds)) {
                print("Playhead Time : \(timeValue)")
            }
        }
        
        let layer = AVPlayerLayer(player: videoPlayer)
        layer.frame = self.view.bounds
        
        view.layer.addSublayer(layer)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let player = videoPlayer {
            player.play()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let timeObserverToken = timeObserverToken , let videoPlayer = videoPlayer {
            videoPlayer.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        super.viewWillDisappear(animated)
    }
    
    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: components as DateComponents)!
    }
}

