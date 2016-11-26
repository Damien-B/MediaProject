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

class VideoDetailViewController: UIViewController {
    
    public var video: Media?;

    @IBOutlet var downloadProgressView: UIProgressView!
    @IBOutlet var downloadProgressLabel: UILabel!
    
    private var fileURL: URL?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let videoId: String = self.video!.id;
        let url: String = "https://clementpeyrabere.net:8003/download/video/" + videoId;
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        fileURL = documentsURL.appendingPathComponent((self.video?.name)! + ".mp4")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (self.fileURL!, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if(FileManager.default.fileExists(atPath: (fileURL?.path)!)) {
            self.playVideo()
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
                        self.playVideo();
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
