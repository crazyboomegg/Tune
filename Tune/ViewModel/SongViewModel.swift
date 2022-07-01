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

    
    init(song: Song)
    {
        self.song = song
    }
}
