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
    var page = 1
    var term = "愛"
    
    func getSongs(term: String, page: Int = 1, limit:Int = 10, success: @escaping () -> Void, fail: @escaping (ResponseError) -> Void)
    {
        self.term = term
        self.page = page
        
        var params = [
            "term" : self.term,
            "entity" : "song",
            "limit" : "\(limit)",
            "country" : "TW",
        ]
        if page != 1 {
            params["offset"] = "\((page-1) * limit)"
        }
        
      
        
        ListResponse<Song>.request(api: .searchSong, params: params) { res in
            guard res.isSuccess else { return fail(.deserializeFailed) }
            guard let v = res.value else { return fail(.deserializeFailed) }
            guard v.results.count != 0 else { return fail(.emptyDataFailed) }

            var songs = [SongViewModel]()

            for song in v.results {
                songs.append(SongViewModel(song: song))
            }

            self.songs = page == 1 ? songs : self.songs + songs
            print("你媽的\(page)")
            return success()
        }
    }
}
