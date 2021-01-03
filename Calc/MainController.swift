//
//  MainController.swift
//  Calc
//
//  Created by Mrinal Chanshetty on 12/30/20.
//

import Foundation
import UIKit

private let cellIdentifier = "CellIdentifier"

class MainController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var firstNum: Int = 0
    var secondNum: Int = 0
    var operation: String = ""
    var isDisplayingAnswer: Bool = false
    
    private let answerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.text = "\(0)"
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        configureCollectionView()
        constrainCollectionView()
        addAnswerLabelToView()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - Helpers
    func configureCollectionView() {
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = view.backgroundColor
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalcButton.self, forCellWithReuseIdentifier: cellIdentifier)
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
    
    func constrainCollectionView() {
        collectionView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height * 0.55).isActive = true
    }
    
    func addAnswerLabelToView() {
        view.addSubview(answerLabel)
        answerLabel.anchor(left: collectionView.leftAnchor,
                           bottom: collectionView.topAnchor,
                           right: collectionView.rightAnchor,
                           paddingLeft: 10,
                           paddingBottom: 15,
                           paddingRight: 10)
    }
    
    func clear() {
        firstNum = 0
        secondNum = 0
        answerLabel.text = "\(0)"
        operation = ""
        isDisplayingAnswer = false
    }
    
    func updateLabel(withInt num: Int) {
        answerLabel.text = "\(num)"
    }
    
    func updateNumber(withInt num: Int) {
        if (isDisplayingAnswer) {
            firstNum = 0
            secondNum = 0
            operation = ""
        }
        if (operation == "") {
            firstNum = firstNum * 10 + num
            updateLabel(withInt: firstNum)
        } else {
            secondNum = secondNum * 10 + num
            updateLabel(withInt: secondNum)
        }
        isDisplayingAnswer = false
    }
    
    func calculate() {
        let answer: Int
        switch (operation) {
        case "+":
            answer = firstNum + secondNum
        case "-":
            answer = firstNum - secondNum
        case "÷":
            answer = firstNum / secondNum
        default:
            answer = firstNum * secondNum
        }
        updateLabel(withInt: answer)
        isDisplayingAnswer = true
        firstNum = answer
    }
    
    func debugger() {
        print("DEBUG: first num = \(firstNum)")
        print("DEBUG: second num = \(secondNum)")
        print("DEBUG: displayed value = \(answerLabel.text!)")
        print("")
    }
    
    //MARK: - Selectors
}

//MARK: - UICollectionViewDelegate
extension MainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (buttons[indexPath.row] == "0") {
            return CGSize(width: cellSize * 2 + 20, height: cellSize)
        } else {
            return CGSize(width: cellSize, height: cellSize)
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension MainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalcButton
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
}

extension MainController: CalcButtonDelegate {
    func handleButtonTap(index: Int) {
        let type = Utilities().getButtonType(index: index)
        let value = buttons[index]
        
        
        if (type == "number") {
            if (value == ".") {
                
            } else {
                guard let num = Int(buttons[index]) else { return }
                self.updateNumber(withInt: num)
            }
        } else if (type == "other") {
            if (value == "AC") {
                self.clear()
            }
        } else if (type == "operation") {
            self.operation = value
        } else {
            self.calculate()
        }
    }
    
    
}
