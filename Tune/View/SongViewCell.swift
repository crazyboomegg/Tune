//
//  SongViewCell.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation
import UIKit
import Kingfisher


protocol SongViewDelegate: AnyObject {
    func didCoverTap(song: SongViewModel)
}

@available(iOS 13.0, *)
class SongViewCell: UITableViewCell, SongViewModelDelegate {
    
    var delegate: SongViewDelegate?
    var song: SongViewModel?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.text = song!.trackName
        return label
    }()
    
    lazy var coverBtn: HiButton = {
        let btn = HiButton()
        btn.backgroundColor = .brown

        btn.onTap {
            self.delegate?.didCoverTap(song: self.song!)
                
//            UIView.animate(withDuration: 0.5) {
//                self.coverBtn.transform3D = CATransform3DMakeRotation(state == .playing ? .pi : 0, 0, 1, 0)
//            }

            
        }
        return btn
    }()
    
    lazy var artistAlbumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.5)
        label.text = song?.artistAlbumName
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    let botLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        
        contentView.addSubview(coverBtn)
        coverBtn.snp.makeConstraints({ make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.bounds.height - 12)
        })

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.left.equalTo(coverBtn.snp.right).offset(8)
            make.right.equalToSuperview().offset(-contentView.bounds.width/5)
            make.centerY.equalToSuperview()
        })
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(artistAlbumLabel)

        
        contentView.addSubview(botLine)
        botLine.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(song: SongViewModel)
    {
        self.song = song
        self.coverBtn.kf.setImage(with: URL(string: song.coverUrl), for: .normal)
        nameLabel.text = song.trackName
        artistAlbumLabel.text = song.artistAlbumName


    }
}
