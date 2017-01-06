//
//  VideoDetailViewController.swift
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

class VideoDetailViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    public var video: Media?;

    @IBOutlet var downloadProgressView: UIProgressView!
    @IBOutlet var downloadProgressLabel: UILabel!
	@IBOutlet weak var showVideoButton: UIButton!
    
    private var fileURL: URL?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.downloadVideo()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Helpers
	
	func downloadVideo() {
		let videoId: String = self.video!.id;
		let url: String = "https://clementpeyrabere.net:8003/download/video/" + videoId;
		self.title = self.video?.name
        
		let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
		fileURL = documentsURL.appendingPathComponent((self.video?.name)! + ".mp4")
		let destination: DownloadRequest.DownloadFileDestination = { _, _ in
			return (self.fileURL!, [.removePreviousFile, .createIntermediateDirectories])
		}
		
		if(FileManager.default.fileExists(atPath: (fileURL?.path)!)) {
			self.videoAvailable()
		} else {
			self.downloadProgressLabel.isHidden = false;
			self.downloadProgressLabel.text = "Downloading ... 0%";
			self.downloadProgressView.isHidden = false;
            
			Server.downloadVideo(videoId, destination)
				.downloadProgress { progress in
					self.downloadProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
					self.downloadProgressLabel.text = "Downloading ... \(Int(progress.fractionCompleted * 100))%";
				}.responseData { response in
					if response.result.value != nil {
						self.videoAvailable()
					} else {
						print("Data was invalid")
					}
			}
		}
	}
	
    private func playVideo() -> Void {
        let videoPlayer = AVPlayer(url: self.fileURL!)
        let videoPlayerViewController = AVPlayerViewController()
        videoPlayerViewController.player = videoPlayer
        self.present(videoPlayerViewController, animated: true, completion:  {
            videoPlayer.play()
        })
    }
	
	func videoAvailable() {
		self.downloadProgressView.isHidden = true
		self.downloadProgressLabel.isHidden = true
		self.showVideoButton.isHidden = false
		self.showVideoButton.isEnabled = true
	}
	
	// MARK: - Actions
    
	@IBAction func showVideo(_ sender: AnyObject) {
		self.playVideo()
	}

}
