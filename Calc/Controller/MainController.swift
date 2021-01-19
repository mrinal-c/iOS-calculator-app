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
    
    var firstNum: Double = 0
    var secondNum: Double = 0
    var operation: String = ""
    
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
        collectionView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              paddingBottom: 20)
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
    }
    
    func updateLabel(withNum num: Double) {
        let answer = round(num: num)
        if (floor(answer) == ceil(answer)) {
            let int = Int(answer)
            answerLabel.text = "\(int)"
        } else {
            answerLabel.text = "\(answer)"
        }
    }
    
    func updateNumber(withNum num: Double) {
        if (operation == "") {
            firstNum = firstNum * 10 + num
            updateLabel(withNum: firstNum)
        } else {
            secondNum = secondNum * 10 + num
            updateLabel(withNum: secondNum)
            let row = Utilities().getButtonIndex(buttonString: operation)
            let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as! CalcButton
            cell.toggleOff()
        }
    }
    
    func calculate() {
        let answer: Double
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
        updateLabel(withNum: answer)
        firstNum = answer
        secondNum = 0
        operation = ""
    }
    
    func debugger() {
        print("DEBUG: first num = \(firstNum)")
        print("DEBUG: second num = \(secondNum)")
        print("DEBUG: displayed value = \(answerLabel.text!)")
        print("")
    }
    
    func round(num: Double) -> Double {
        var rounded: Double = (1000000 * num)
        rounded.round()
        rounded = rounded / 1000000
        return rounded
    }
    
    func toggleOperation(toggleCell cell: CalcButton) {
        if cell.isToggled {
            cell.toggleOff()
        } else {
            cell.toggleOn()
        }
        let divideCell = collectionView.cellForItem(at: IndexPath(row: 3, section: 0)) as! CalcButton
        let timesCell = collectionView.cellForItem(at: IndexPath(row: 7, section: 0)) as! CalcButton
        let minusCell = collectionView.cellForItem(at: IndexPath(row: 11, section: 0)) as! CalcButton
        let plusCell = collectionView.cellForItem(at: IndexPath(row: 15, section: 0)) as! CalcButton
        let operationButtons = [divideCell, timesCell, minusCell, plusCell]
        for button in operationButtons {
            if button.isToggled && button != cell {
                button.toggleOff()
            }
        }
        
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

//MARK: - CalcButtonDelegate
extension MainController: CalcButtonDelegate {
    func handleButtonTap(index: Int, _ cell: CalcButton) {
        let type = Utilities().getButtonType(index: index)
        let value = buttons[index]
        
        
        if (type == "number") {
            if (value == ".") {
                
            } else {
                guard let temp = Int(buttons[index]) else { return }
                let num = Double(temp)
                self.updateNumber(withNum: num)
            }
        } else if (type == "other") {
            if (value == "AC") {
                self.clear()
            }
        } else if (type == "operation") {
            self.operation = value == self.operation ? "" : value
            self.toggleOperation(toggleCell: cell)
        } else {
            self.calculate()
        }
    }
    
    
}
