//
//  Media.swift
//  MediaProject
//
//  Created by Clément Peyrabere on 25/11/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import Foundation

public class Media : NSObject {
    
    public var name: String;
    public var id: String;
    public var mimeType: String;
    public var fullPath: String;
    public var size: Int;
    
    public init(id: String, name: String, mimeType: String, fullPath: String, size: Int) {
        self.id = id;
        self.name = name;
        self.mimeType = mimeType;
        self.fullPath = fullPath;
        self.size = size;
    }
    
}
