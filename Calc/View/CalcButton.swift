//
//  CalcButton.swift
//  Calc
//
//  Created by Mrinal Chanshetty on 12/30/20.
//

import Foundation
import UIKit

protocol CalcButtonDelegate: class {
    func handleButtonTap(index: Int, _ cell: CalcButton)
}

class CalcButton: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: CalcButtonDelegate?
    var isToggled: Bool = false
    var index: Int? {
        didSet {
            configureViewModel()
        }
    }
    
    private var viewModel: CalcViewModel? {
        didSet {
            configureTitle()
            configureCell()
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(handleButtonReleased), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonReleased), for: .touchUpOutside)
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
    private func configureTitle() {
        guard let idx = self.index else { return }
        button.setTitle(buttons[idx], for: .normal)
    }
    
    private func configureCell() {
        guard let viewModel = self.viewModel else { return }
        button.setTitleColor(viewModel.option.textColorNormal, for: .normal)
        clipsToBounds = true
        addSubview(button)
        button.center(inView: self)
        layer.cornerRadius = CGFloat(cellSize / 2)
        button.setDimensions(width: 160, height: 80)
        backgroundColor = viewModel.option.normalColor
    }
    
    private func configureViewModel() {
        guard let idx = index else { return }
        self.viewModel = CalcViewModel(idx: idx)
    }
    
    func toggleOn() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = .white
            self.button.setTitleColor(.calcOrange, for: .normal)
        }
        isToggled = true
    }
    
    func toggleOff() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = .calcOrange
            self.button.setTitleColor(.white, for: .normal)
        }
        isToggled = false
    }
    
    //MARK: - Selectors
    @objc func handleButtonReleased() {
        guard let viewModel = self.viewModel else { return }
        UIView.animate(withDuration: 0.4) {
            self.backgroundColor = viewModel.option.normalColor
        }
        guard let idx = self.index else { return }
        delegate?.handleButtonTap(index: idx, self)
    }
    
    @objc func toggleButtonPushed() {
        guard let viewModel = self.viewModel else { return }
        backgroundColor = viewModel.option.pushColor
    }
}
