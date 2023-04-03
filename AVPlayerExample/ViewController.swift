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
    
    private var videoPlayerTimeObserverToken : Any?
    private var videoPlayerTimeControlStatusObserver : NSKeyValueObservation?
    
    private var videoPlayerEndedObserver : NSObjectProtocol?
    
    static let contentURL : URL! = URL(string:"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
                                        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Creating AVAsset and AVPlayer
        let asset = AVAsset(url: ViewController.contentURL)
        let playerItem = AVPlayerItem(asset: asset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        //Periodic Time Observation every 0.5 a second
        videoPlayerTimeObserverToken = videoPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 5,timescale: 10),
                                             queue: DispatchQueue.main) { [weak self] time in
            if let videoPlayer = self?.videoPlayer, let timeValue = self?.createTimeString(time: Float(videoPlayer.currentTime().seconds)) {
                print("Playhead Time : \(timeValue)")
            }
        }
        
        //Status of Playback to observe
        videoPlayerTimeControlStatusObserver = videoPlayer?.observe(\AVPlayer.timeControlStatus,
                                                         options: [.initial, .new]) { player, anItem in
            DispatchQueue.main.async {
                switch player.timeControlStatus {
                case .playing:
                    print("Currently Playing....")
                case .paused:
                    print("Currently Paused....")
                case .waitingToPlayAtSpecifiedRate:
                    print("Waiting to Play....")
                default:
                    print("Unknown Status.....")
                }
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemEnded),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer)
        
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
        if let timeObserverToken = videoPlayerTimeObserverToken , let videoPlayer = videoPlayer {
            videoPlayer.removeTimeObserver(timeObserverToken)
            self.videoPlayerTimeObserverToken = nil
            self.videoPlayerEndedObserver = nil
        }
        super.viewWillDisappear(animated)
    }
    
    @objc func playerItemEnded() {
        print("The Current Item has Ended ")
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
