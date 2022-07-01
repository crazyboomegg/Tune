//
//  SongCellViewModel.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation

protocol SongViewModelDelegate {
    func onStateChanged(state: SongViewModel.PlyayerState)
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
        guard let id = song.trackId else { return 0 }
        return id
    }
    
    var trackName: String {
        guard let name = song.trackName else { return "" }
        return name
    }

    var coverUrl: String {
        guard let url = song.artworkUrl100 else { return "" }
        return url
    }
    
    var audioUrl: String {
        guard let url = song.previewUrl else { return "" }
        return url
    }
    
    init(song: Song)
    {
        self.song = song
    }
}
