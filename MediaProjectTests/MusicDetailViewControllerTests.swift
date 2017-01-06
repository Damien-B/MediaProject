//
//  MusicListViewControllerTests.swift
//  MediaProject
//
//  Created by Clément Peyrabere on 06/01/2017.
//  Copyright © 2017 Damien Bannerot. All rights reserved.
//

import XCTest
@testable import MediaProject
import Alamofire

class MusicDetailViewControllerTests: XCTestCase {
    
    var vc : MusicDetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        vc = storyboard.instantiateViewController(withIdentifier: "MusicDetailViewController") as! MusicDetailViewController
        let dummy = vc.view // force loading subviews and setting outlets
        
        vc.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
