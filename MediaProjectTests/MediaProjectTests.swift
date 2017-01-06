//
//  MediaProjectTests.swift
//  MediaProjectTests
//
//  Created by Clément Peyrabere on 02/12/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import XCTest
@testable import MediaProject
import Alamofire

class MediaProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchAudio() {
        let asyncExpectation = expectation(description: "longRunningFunction");
        var audios : [AnyObject] = [AnyObject]();
        
        Server.listAudio( { (error, success, result) in
            for item in result {
                audios.append(item);
            }
            asyncExpectation.fulfill();
        });
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Could not fetch Audio...")
            XCTAssertGreaterThan(audios.count, 5);
        }
    }
    
    func testFetchVideo() {
        let asyncExpectation = expectation(description: "longRunningFunction");
        var videos : [AnyObject] = [AnyObject]();
        
        Server.listAudio( { (error, success, result) in
            for item in result {
                videos.append(item);
            }
            asyncExpectation.fulfill();
        });
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Could not fetch Audio...")
            XCTAssertGreaterThan(videos.count, 5);
        }
    }
    
    func testDownloadAudio() {
        let asyncExpectation = expectation(description: "longRunningFunction");
        let songId: String = "58373ea7c3656c2fccab814d";
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent("testDownload.mp3")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        
        Server.downloadAudio(songId, destination)
            .responseData { response in
                if response.result.value != nil {
                    asyncExpectation.fulfill();
                } else {
                    print("Data was invalid")
                }
        }
        
        self.waitForExpectations(timeout: 50) { error in
            XCTAssertNil(error, "Could not download Audio...")
        }

    }
    
    func testDownloadVideo() {
        let asyncExpectation = expectation(description: "longRunningFunction");
        let videoId: String = "586fb1cf47c15d3c70de4213";
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent("testDownload.mp3")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        Server.downloadAudio(videoId, destination)
            .responseData { response in
                if response.result.value != nil {
                    asyncExpectation.fulfill();
                } else {
                    print("Data was invalid")
                }
        }
        
        self.waitForExpectations(timeout: 50) { error in
            XCTAssertNil(error, "Could not download Audio...")
        }
        
    }
}
