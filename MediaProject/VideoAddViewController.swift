//
//  VideoAddViewController.swift
//  MediaProject
//
//  Created by Damien Bannerot on 09/11/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit
import Alamofire

class VideoAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var videoInfo: [String : Any]?
	@IBOutlet weak var videoNameTextField: UITextField!
	@IBOutlet weak var chooseVideoButton: UIButton!
	@IBOutlet weak var sendVideoButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.sendVideoButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Helpers
	
	
	// MARK: - Actions
	
	@IBAction func sendVideo(_ sender: AnyObject) {
		if let info = self.videoInfo {
			if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
				print(videoURL)
				let tmpString = "\(info[UIImagePickerControllerReferenceURL] as! NSURL)"
				let extensionString = tmpString.substring(from: tmpString.range(of: "ext=")!.upperBound)
				
				// TODO: add textfield for the name of the video (filename)
				if let name = self.videoNameTextField.text {
					if name != "" {
                        Server.uploadVideo(videoURL, name, extensionString, encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                print(upload)
                                self.navigationController?.popViewController(animated: true)
                            case .failure(let encodingError):
                                print(encodingError)
                            }
                        });
					} else {
						let nameAlert = UIAlertController(title: "Missing information", message: "Please fill name field", preferredStyle: UIAlertControllerStyle.alert)
						nameAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
							self.videoNameTextField.becomeFirstResponder()
						}))
					}
				}
			}
		}
	}
	
	@IBAction func chooseVideo(_ sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
			let imagePickerController = UIImagePickerController()
			imagePickerController.sourceType = .photoLibrary
			imagePickerController.allowsEditing = true
			imagePickerController.delegate = self
			imagePickerController.mediaTypes = ["public.movie"]
			self.present(imagePickerController, animated: true, completion: nil)
		}
	}
	
	// MARK: - UIImagePickerControllerDelegate
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		print(info)
		self.videoInfo = info
		
		self.sendVideoButton.titleLabel!.text = "Choose another video"
		self.sendVideoButton.isEnabled = true
		self.sendVideoButton.backgroundColor = UIColor(red: 90.0/255.0, green: 170.0/255.0, blue: 60.0/255.0, alpha: 1)
		
		picker.dismiss(animated: true, completion: nil)
	}

}
