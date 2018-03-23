//
//  PlayerDetailsView.swift
//  Pod Blast
//  Created by Khaled Rahman Ayon on 08.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailsView: UIView {
    //MARK:- Variables
    var playListEpisodes = [Episode]()
    fileprivate let scaleForShrinking = CGAffineTransform(scaleX: 0.7, y: 0.7)
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var episode: Episode! {
        didSet {
            miniEpisodeTitleLbl.text = episode.title
            episodeTitleLbl.text = episode.title
            autherLbl.text = episode.auther
            //setting up AVAudioSession
            setupAudioSession()
            playEpiosde()
            setupNowPlayingInfo()
//            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
            guard let url = URL(string: episode.episodeImageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            
            miniEpisodeImageView.sd_setImage(with: url) { (image, _, _, _) in
                guard let img = image else { return }
                
                let artWorkItem = MPMediaItemArtwork.init(boundsSize: img.size, requestHandler: { (_) -> UIImage in
                    return img
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artWorkItem
                
            }
            
        }
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    //MARK:- IBOutLets & IBActions
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniEpisodeTitleLbl: UILabel!
    @IBOutlet weak var miniEpisodeImageView: UIImageView! {
        didSet {
            miniEpisodeImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var miniPlayPauseBtn: UIButton! {
        didSet {
            miniPlayPauseBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            miniPlayPauseBtn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniFastForwardBtn: UIButton! {
        didSet {
            miniFastForwardBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            miniFastForwardBtn.addTarget(self, action: #selector(forwardBtnPressed(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = scaleForShrinking
        }
    }
    @IBOutlet weak var episodeTitleLbl: UILabel!
    @IBOutlet weak var autherLbl: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton! {
        didSet {
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseBtn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBAction func currentTimeSliderChanged(_ sender: Any) {
        let percentage = timeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSecond = Float64(percentage) * durationInSeconds
        let seekTime = CMTime(seconds: seekTimeInSecond, preferredTimescale: 1)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSecond
        player.seek(to: seekTime)
    }
    
    @IBAction func rewindBtnPressed(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    
    @IBAction func forwardBtnPressed(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        //        self.removeFromSuperview()
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetailsView()
    }
    
    //MARK:- awakeFromNib
    
    fileprivate func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVAudioSessionInterruption, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSessionInterruptionType.began.rawValue {
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            guard let option = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if option == AVAudioSessionInterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                miniPlayPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            debugPrint(err as Any)
        }
    }
    
    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.miniPlayPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
            self.setupElapsedTime(with: 1)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.miniPlayPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
            
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            
            self.setupElapsedTime(with: 0)
            return .success
        }
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePrevTrack))
    }
    
    @objc fileprivate func handleNextTrack() {
        if playListEpisodes.count == 0 {
            return
        }
       let currentEpisodeIndex =  playListEpisodes.index { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.auther == ep.auther
        
        }
        guard let index = currentEpisodeIndex else { return }
        print("Index is \(index)")
        let nextEpisode: Episode
        if index == playListEpisodes.count - 1 {
            nextEpisode = playListEpisodes[0]
        } else {
            nextEpisode = playListEpisodes[index + 1]
        }
        self.episode = nextEpisode
    }
    
    @objc fileprivate func handlePrevTrack() {
        if playListEpisodes.isEmpty {
            return
        }
        let currentEpisodeIndex = playListEpisodes.index { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.auther == ep.auther
        }
        guard let index = currentEpisodeIndex else { return }
        let previousEpisode: Episode
        if index == 0 {
            let count = playListEpisodes.count
            previousEpisode = playListEpisodes[count - 1]
        } else {
            previousEpisode = playListEpisodes[index - 1]
        }
        self.episode = previousEpisode
    }
    

    
    fileprivate func observeBoundryTime() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpisodeImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRemoteControl()
        setupInterruptionObserver()
        setupGestures()
        
        //observing when the podcast starts to play!
        observePlayerCurrenTime()
        
        observeBoundryTime()
    }
    
    //MARK:- functions
    fileprivate func seekToCurrentTime(delta: Int64) {
        let addedSeconds = CMTime(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), addedSeconds)
        player.seek(to: seekTime)
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
            self.setupElapsedTime(with: 1)
        } else {
            player.pause()
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
            self.setupElapsedTime(with: 0)
        }
    }
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.episodeImageView.transform = .identity
            self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
        }, completion: nil)
    }
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.scaleForShrinking
            
        }, completion: nil)
    }
    
    //MARK:- Avplayer setup playing podcast episode
    fileprivate func observePlayerCurrenTime() {
        let timeInteval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: timeInteval, queue: .main) { [weak self] (time) in
            
            self?.currentTimeLbl.text = time.toFormateTimeString()
            let durationTime = self?.player.currentItem?.duration
            self?.totalTimeLbl.text = durationTime?.toFormateTimeString()
//            self?.setupLockScreenCurrentTime()
            self?.observeCurrentTimeSlider()
        }
    }
    
    fileprivate func setupLockScreenCurrentTime() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        guard let currentItem = player.currentItem else { return }
        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
        let elapsedTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTimeInSeconds
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    }
    
    fileprivate func setupElapsedTime(with plabackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = plabackRate
    }
    
    @objc func maximizePlayerView() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetailsView(episode: nil)
    }
    
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.auther
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func playEpiosde() {
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    fileprivate func observeCurrentTimeSlider() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        let durationInSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percentage = currentTimeInSeconds / durationInSeconds
        self.timeSlider.value = Float(percentage)
    }
    
    deinit {
        //to remove the object from retain cycle...
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
    }
   
}
