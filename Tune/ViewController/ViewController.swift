//
//  ViewController.swift
//  Tune
//
//  Created by 江柏毅 on 2022/6/30.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = SongListViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
