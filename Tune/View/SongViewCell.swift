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
    func onStateChanged(state: SongViewModel.PlyayerState)
}

@available(iOS 13.0, *)
class SongViewCell: UITableViewCell {

    var delegate: SongViewDelegate?
    var song: SongViewModel?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.text = song?.trackName
        return label
    }()
    
    lazy var coverBtn: HiButton = {
        let btn = HiButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.backgroundColor = .black.withAlphaComponent(0.5)

        btn.onTap {
            self.delegate?.didCoverTap(song: self.song!)
        }
        
        return btn
    }()
    
//    lazy var shapeLayer: CAShapeLayer = {
//        let shape = CAShapeLayer()
//        let center = CGPoint(x: contentView.bounds.height*0.4, y: contentView.bounds.height*0.4)
//        let path = UIBezierPath(arcCenter: center, radius: contentView.bounds.height*0.3, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        shape.path = path.cgPath
//        shape.strokeColor = UIColor.white.cgColor
//        shape.fillColor = UIColor.clear.cgColor
//        shape.lineWidth = 2
//        shape.strokeEnd = 1
//        return shape
//    }()
//
    lazy var coverPlayBtn: HiButton = {
        let btn = HiButton()
        btn.isHidden = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "stop.circle", withConfiguration:  UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        btn.imageView?.tintColor = .white
//        btn.backgroundColor = .white
        btn.onTap {
            self.delegate?.didCoverTap(song: self.song!)
        }

//        shapeLayer.position = btn.center
//        btn.layer.addSublayer(shapeLayer)

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
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.bounds.height * 0.75)
        })
        
        contentView.addSubview(coverPlayBtn)
        coverPlayBtn.snp.makeConstraints({ make in
            make.centerX.centerY.equalTo(coverBtn)
            make.width.height.equalTo(contentView.bounds.height * 0.75)
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
            make.left.equalTo(coverBtn.snp.left)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(song: SongViewModel)
    {
        self.song = song
        self.song?.delegate = self
        
        coverBtn.kf.setImage(with: URL(string: song.coverUrl), for: .normal)
        coverBtn.isHidden = song.isCoverHide
        coverBtn.transform3D = song.transform3D
        coverBtn.layer.opacity = song.coverOpacity
        
        coverPlayBtn.isHidden = song.isCoverPlayHide
        coverPlayBtn.transform3D = song.coverPlayTransform3D
        coverPlayBtn.layer.opacity = song.coverPlayOpacity

        nameLabel.text = song.trackName
        artistAlbumLabel.text = song.artistAlbumName

        //  shapeLayer.strokeEnd = song.playProgress

    }

}

@available(iOS 13.0, *)
extension SongViewCell: SongViewModelDelegate  {
//    func onCurrentTimeChanged(time: Double) {
//        shapeLayer.strokeEnd = CGFloat(song!.playProgress)
//        print(song?.playProgress)
//    }
    
    func onStateChanged(state: SongViewModel.PlyayerState) {
        guard let song = self.song else { return print("The Song is nil") }
        
        UIView.animate(withDuration: 0.25) {
            self.coverBtn.isHidden = song.isCoverHide
            self.coverBtn.layer.opacity = song.coverOpacity
            self.coverPlayBtn.layer.opacity = song.coverPlayOpacity
            self.coverPlayBtn.isHidden = song.isCoverPlayHide
        }
        
        UIView.animate(withDuration: 0.5) {
            self.coverBtn.layer.transform = song.transform3D
            self.coverPlayBtn.layer.transform = song.coverPlayTransform3D
        }
        completion: { _ in
            self.delegate?.onStateChanged(state: state)
        }
    }
}
