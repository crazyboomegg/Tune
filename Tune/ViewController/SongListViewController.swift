//
//  ViewController.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import UIKit
import SnapKit
import AVFoundation

class SongListViewController: UIViewController, SongViewDelegate, SongViewModelDelegate {
    func didCoverTap(song: SongViewModel) {
//        switch song.currentState {
//        case .playing:
//            song.currentState = .pause
//        default:
//            viewModel.currentSong = song
//            song.currentState = .playing
//        }
//
        viewModel.currentSong = song
        playerItem = AVPlayerItem(url: URL(string: viewModel.currentSong!.audioUrl)!)
        player = AVPlayer(playerItem: playerItem)
        song.currentState = .playing

        print(song.trackName)
        print(song.currentState)
    }
    
    func didStateChanged(state: SongViewModel.PlyayerState) {
        switch state {
        case .playing:
            player.play()
        default:
            player.pause()
        }
    }
    


    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SongViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .red
        tableView.dataSource = self
        return tableView
    }()
    
    let viewModel = SongListViewModel()
    
    
    //播放器
    private var player = AVPlayer()
    private var playerItem: AVPlayerItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        viewModel.getSongs(term: "小蘋果") {
            self.tableView.reloadData()
        }
        
    }


    func initView()
    {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.bottom.left.right.equalToSuperview()
        })
        
    }
}



extension SongListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SongViewCell
        cell.bind(song: viewModel.songs[indexPath.row])
        cell.delegate = self
        cell.song?.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
