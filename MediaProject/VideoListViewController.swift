//
//  VideoListViewController.swift
//  MediaProject
//
//  Created by Damien Bannerot on 09/11/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit
import Alamofire

class VideoListViewController: UIViewController {

    public var videos: [Media] = [];
    @IBOutlet var videosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.fetchVideos()
		
    }
	override func viewDidAppear(_ animated: Bool) {
		self.fetchVideos()
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers

	func fetchVideos() {
		let url: String = "https://clementpeyrabere.net:8003/list/video";
		Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
			self.videos = []
			let data = response.result.value as! [AnyObject]
			for item in data {
				let media: Media = Media(id: item["_id"]! as! String, name: item["name"]! as! String, mimeType: item["mimeType"]! as! String, fullPath: item["fullPath"]! as! String, size: item["size"] as! Int);
				self.videos.append(media);
			}
			
			DispatchQueue.main.async(execute: {
				self.videosTableView.reloadData()
			});
		}
	}
	
    // MARK: - Navigation
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "videoDetails") {
            let videoDetailController: VideoDetailViewController = segue.destination as! VideoDetailViewController
            if let selectedVideoCell = sender as? VideoTableViewCell {
                let indexPath = videosTableView.indexPath(for: selectedVideoCell)!
                let selectedVideo = videos[indexPath.row]
                videoDetailController.video = selectedVideo
            }
        }
    }
	
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.videos.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as? VideoTableViewCell
		if cell == nil {
			cell = VideoTableViewCell(style: .default, reuseIdentifier: "videoCell")
		}
		cell!.titleLabel.text = self.videos[indexPath.row].name
		return cell!
	}
}
