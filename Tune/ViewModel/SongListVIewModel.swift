//
//  MusicListVIewModel.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation

class SongListViewModel {

    var songs = [SongViewModel]()
    var currentSong: SongViewModel?
    
    func getSongs(term: String, success: @escaping () -> Void)
    {
        let params = [
            "term" : term,
            "entity" : "song",
        ]
        
        ListResponse<Song>.request(api: .searchSong, params: params) { res in
            guard res.isSuccess else { return }
            guard let v = res.value else { return }

            var songs = [SongViewModel]()

            for song in v.results {
                songs.append(SongViewModel(song: song))
            }
            
            self.songs = songs
            success()
        }
    }
}
