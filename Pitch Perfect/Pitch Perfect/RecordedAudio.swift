//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jim Mhe on 4/4/15.
//  Copyright (c) 2015 Jamal Mhe. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    init(FilePathURL: NSURL, Title:String!) {
        self.filePathURL = FilePathURL
        self.title = Title
    }
}
