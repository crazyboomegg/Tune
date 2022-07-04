//
//  Song.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation
import HandyJSON

struct Song: HandyJSON {
    var trackId: Int?
    var trackName: String?
    var previewUrl: String?
    var artworkUrl100: String?
    var artistName: String?
    var collectionName: String?
//    var trackTimeMillis: Int?

}


