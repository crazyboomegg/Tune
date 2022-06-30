//
//  Song.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation
import HandyJSON

struct Song: HandyJSON {
    var trackName: String?
    var previewUrl: String?
    var artworkUrl30: String?
}
