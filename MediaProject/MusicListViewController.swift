//
//  MusicListViewController.swift
//  MediaProject
//
//  Created by Damien Bannerot on 09/11/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit
import Alamofire

class MusicListViewController: UIViewController {
    
    public var songs: [Media] = [];
	@IBOutlet var songsTableView: UITableView!
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(VideoListViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
		
		return refreshControl
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.songsTableView.addSubview(self.refreshControl)
		self.fetchSongs()
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
	
	func handleRefresh(_ refreshControl: UIRefreshControl) {
		self.fetchSongs()
		let time = DispatchTime.now() + 1
		DispatchQueue.main.asyncAfter(deadline: time) {
			refreshControl.endRefreshing()
		}
	}
	
	func fetchSongs() {
		let url: String = "https://clementpeyrabere.net:8003/list/audio";
		
		Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
			let data = response.result.value as! [AnyObject]
			for item in data {
				let media: Media = Media(id: item["_id"]! as! String, name: item["name"]! as! String, mimeType: item["mimeType"]! as! String, fullPath: item["fullPath"]! as! String, size: item["size"] as! Int, coverURL: item["coverImageURL"]! as! String);
				self.songs.append(media);
			}
			
			DispatchQueue.main.async(execute: {
				self.songsTableView.reloadData()
			});
		}
	}
	
	// MARK: - Navigation
	
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "songDetails") {
            let musicDetailController: MusicDetailViewController = segue.destination as! MusicDetailViewController
            if let selectedSongCell = sender as? MusicTableViewCell {
                let indexPath = songsTableView.indexPath(for: selectedSongCell)!
                let selectedSong = songs[indexPath.row]
                musicDetailController.song = selectedSong
            }
        }
     }
    
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "musicCell") as? MusicTableViewCell
        if cell == nil {
            cell = MusicTableViewCell(style: .default, reuseIdentifier: "musicCell")
        }
        cell!.titleLabel.text = self.songs[indexPath.row].name;
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
