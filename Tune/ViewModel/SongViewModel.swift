//
//  SongCellViewModel.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation
import UIKit

protocol SongViewModelDelegate {
    func onStateChanged(state: SongViewModel.PlyayerState)
//    func onCurrentTimeChanged(time: Double)
}

class SongViewModel {

    enum PlyayerState {
        case none, load, playing, pause, stopped
    }
    
    var delegate: SongViewModelDelegate?

    var currentState: SongViewModel.PlyayerState = .none {
        didSet {
            self.delegate?.onStateChanged(state: self.currentState)
        }
    }
    
    
    var song: Song
    
    
    var trackId: Int {
        return song.trackId ?? 0
    }
    
    var trackName: String {
        return song.trackName ?? ""
    }

    var coverUrl: String {
        return song.artworkUrl100 ?? ""
    }
    
    var audioUrl: String {
        return song.previewUrl ?? ""
    }
    
    var artistAlbumName: String {
        return "\(song.artistName ?? "") - \(song.collectionName ?? "")"
    }
    
    var transform3D: CATransform3D {
        var trans = CATransform3DIdentity
        trans.m34 = 1 / -100
        trans = CATransform3DRotate(trans, currentState == .playing ? .pi : 0, 0, 1, 0)
        return trans
    }
    var coverPlayTransform3D: CATransform3D {
        var trans = CATransform3DIdentity
        trans.m34 = 1 / -100
        trans = CATransform3DRotate(trans, currentState == .playing ? 0 : .pi, 0, 1, 0)
        return trans
    }
    
    var isCoverHide: Bool {
        return currentState == .playing ? true: false
    }
    var isCoverPlayHide: Bool {
        return !isCoverHide
    }
    var coverOpacity: Float {
        return currentState == .playing ? 0 : 1
    }
    var coverPlayOpacity: Float {
        return 1 - coverOpacity
    }
    
//    var playProgress: Double {
//        print(currentTime)
//        print(totalTime)
//        return currentTime/totalTime
//    }
//    var totalTime: Double {
//        return Double(song.trackTimeMillis ?? 0)/10000
//    }
//    var currentTime = 0.0 {
//        didSet {
//            delegate?.onCurrentTimeChanged(time: currentTime)
//        }
//    }
    
    init(song: Song)
    {
        self.song = song
    }
}
