//
//  ViewController.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import UIKit
import SnapKit
import AVFoundation
import MediaPlayer
import Kingfisher


@available(iOS 13.0, *)
class SongListViewController: UIViewController, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .black.withAlphaComponent(0.85)
        searchBar.searchTextField.backgroundColor = .black.withAlphaComponent(0.5)
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SongViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    let viewModel = SongListViewModel()
    
    
    //播放器
    private var player = AVPlayer()
    private var playerItem: AVPlayerItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initAction()
        initView()
        
        viewModel.getSongs(term: viewModel.term) {
            self.tableView.reloadData()
        }
        fail: { err in
            print(err.localizedDescription)
        }
    }


    func initView()
    {
        view.backgroundColor = .black
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        })
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        })
        
    }
    func initAction()
    {
        setupRemoteTransportControls()
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                viewModel.currentSong?.currentState = .playing
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                viewModel.currentSong?.currentState = .stopped
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNowPlaying(_ isActive: Bool = true) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = viewModel.currentSong?.trackName

        KingfisherManager.shared.retrieveImage(with: URL(string: viewModel.currentSong!.coverUrl)!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in

            if let img = image {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] =
                        MPMediaItemArtwork(boundsSize: img.size) { size in
                            return img
                }
            }
        })

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        MPNowPlayingInfoCenter.default().nowPlayingInfo = isActive ? nowPlayingInfo : nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !searchBar.text!.isEmpty else { return }

        viewModel.getSongs(term: searchBar.text!) {
            self.tableView.reloadData()
        }
        fail: { err in
            print(err.localizedDescription)
        }
    }
}



@available(iOS 13.0, *)
extension SongListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height/12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SongViewCell
        cell.bind(song: viewModel.songs[indexPath.row])
        cell.delegate = self
        cell.song?.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.songs.count > indexPath.row else { return }
        guard indexPath.row == viewModel.songs.count-1 else { return }
        
        viewModel.page += 1
        viewModel.getSongs(term: viewModel.term, page: viewModel.page) {
            self.tableView.reloadData()
        }
        fail: { err in
            self.viewModel.page -= 1
            print(err.localizedDescription)
        }
        
    }
}


@available(iOS 13.0, *)
extension SongListViewController: SongViewDelegate, SongViewModelDelegate {
    func didCoverTap(song: SongViewModel) {
        
        if song.trackId == viewModel.currentSong?.trackId {
            switch viewModel.currentSong?.currentState {
            case .playing:
                song.currentState = .stopped
            default:
                song.currentState = .playing
            }
            return
        }
        
        
        guard !song.audioUrl.isEmpty else { return }
        viewModel.currentSong?.currentState = .stopped
        viewModel.currentSong = song
        viewModel.currentSong?.currentState = .load
        print(song.trackName)
        print(song.currentState)
        print(song.audioUrl)
    }
    
    func onStateChanged(state: SongViewModel.PlyayerState) {
        switch state {
        case .load:
            playerItem = AVPlayerItem(url: URL(string: viewModel.currentSong!.audioUrl)!)
            player = AVPlayer(playerItem: playerItem)
            viewModel.currentSong?.currentState = .playing

        case .playing:
            setupNowPlaying(true)
            player.play()
            
        case .pause:
            player.pause()

        case .stopped:
            player.pause()
            player.seek(to: .zero)
            setupNowPlaying(false)
            
        default:
            break
        }
    }
}
