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

class SongViewCell: UITableViewCell {
    
    var delegate: SongViewDelegate?
    var song: SongViewModel?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = song!.trackName
        return label
    }()
    
    lazy var coverBtn: HiButton = {
        let btn = HiButton()
        btn.backgroundColor = .brown

        btn.onTap {
            self.delegate?.didCoverTap(song: self.song!)
        }
        return btn
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
            make.width.height.equalTo(contentView.bounds.height - 5)
        })
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({ make in
            make.left.equalTo(coverBtn.snp.right).offset(6)
            make.centerY.equalToSuperview()
        })

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(song: SongViewModel)
    {
        self.song = song
        self.coverBtn.kf.setImage(with: URL(string: song.coverUrl), for: .normal)
    }
}
