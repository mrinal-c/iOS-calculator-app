//
//  CalcButton.swift
//  Calc
//
//  Created by Mrinal Chanshetty on 12/30/20.
//

import Foundation
import UIKit

protocol CalcButtonDelegate: class {
    func handleButtonTap(index: Int)
}

class CalcButton: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: CalcButtonDelegate?
    
    var index: Int?  {
        didSet {
            configureCell()
            configureColors()
            configureTitle()
        }
    }
    
    var normalColor: UIColor?
    var pushColor: UIColor?
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(handleButtonReleased), for: .touchUpInside)
        button.addTarget(self, action: #selector(toggleButtonPushed), for: .touchDown)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureTitle() {
        guard let idx = index else { return }
        button.setTitle(buttons[idx], for: .normal)
    }
    
    func configureCell() {
        clipsToBounds = true
        addSubview(button)
        button.center(inView: self)
        layer.cornerRadius = CGFloat(cellSize / 2)
//        button.backgroundColor = .white
        button.setDimensions(width: 160, height: 80)
    }
    
    func configureColors() {
        guard let idx = index else { return }
        pushColor = Utilities().getPushColor(idx: idx)
        normalColor = Utilities().getNormalColor(idx: idx)
        backgroundColor = normalColor
    }
    
    //MARK: - Selectors
    @objc func handleButtonReleased() {
        guard let color = normalColor else { return }
        UIView.animate(withDuration: 0.4) {
            self.backgroundColor = color
        }
        guard let idx = index else { return }
        delegate?.handleButtonTap(index: idx)
    }
    
    @objc func toggleButtonPushed() {
        guard let color = pushColor else { return }
        backgroundColor = color
    }
}
