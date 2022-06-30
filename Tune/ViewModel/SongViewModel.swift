//
//  SongCellViewModel.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation

protocol SongViewModelDelegate {
    func didStateChanged(state: SongViewModel.PlyayerState)
}

class SongViewModel {
    var delegate: SongViewModelDelegate?

    enum PlyayerState {
        case none, playing, pause, stop
    }
    
    var currentState: SongViewModel.PlyayerState = .none {
        didSet {
            self.delegate?.didStateChanged(state: self.currentState)
        }
    }
    
    
    var song: Song
    
    var trackName: String {
        guard let name = song.trackName else { return "" }
        return name
    }
    
    var coverUrl: String {
        guard let url = song.artworkUrl30 else { return "" }
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
