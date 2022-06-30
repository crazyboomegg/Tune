//
//  8utton.swift
//  Hi8
//
//  Created by hanchu on 2022/2/24.
//

import UIKit


class HiButton: UIButton {
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func onTap(_ action: @escaping (()-> Void))
    {
        self.action = action
        self.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    @objc private func tap()
    {
        action?()
    }
}
