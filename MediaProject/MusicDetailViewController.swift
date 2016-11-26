//
//  MusicDetailViewController.swift
//  MediaProject
//
//  Created by Damien Bannerot on 09/11/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AVKit
import AVFoundation

class MusicDetailViewController: UIViewController {
    
    public var song: Media?;
    private var player: AVAudioPlayer?
    private var isPlaying: Bool = false;
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var musicControls: UIStackView!
    @IBOutlet var downloadProgressView: UIProgressView!
    @IBOutlet var downloadProgressLabel: UILabel!
    
    private var fileURL: URL?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let songId: String = self.song!.id;
        let url: String = "https://clementpeyrabere.net:8003/download/audio/" + songId;
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        fileURL = documentsURL.appendingPathComponent((self.song?.name)! + ".mp3")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (self.fileURL!, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if(FileManager.default.fileExists(atPath: (fileURL?.path)!)) {
            self.loadSong()
        } else {
            self.downloadProgressLabel.isHidden = false;
            self.downloadProgressLabel.text = "Downloading ... 0%";
            self.downloadProgressView.isHidden = false;
            Alamofire.download(url, to:
                destination)
                .downloadProgress { progress in
                    self.downloadProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
                    self.downloadProgressLabel.text = "Downloading ... \(Int(progress.fractionCompleted * 100))%";
                }.responseData { response in
                    if response.result.value != nil {
                        self.loadSong();
                    } else {
                        print("Data was invalid")
                    }
            }
        }
    }
    
    private func loadSong() -> Void {
        if let player = try? AVAudioPlayer(contentsOf: self.fileURL!) {
            self.player = player
            self.downloadProgressView.isHidden = true;
            self.downloadProgressLabel.isHidden = true;
            self.musicControls.isHidden = false;
        }
    }
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        if(isPlaying) {
            self.player?.pause();
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            self.player?.play();
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        isPlaying = !isPlaying;
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.loadSong();
        if(isPlaying) {
            self.player?.play();
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
