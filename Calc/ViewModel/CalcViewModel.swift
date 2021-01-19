//
//  CalcViewModel.swift
//  Calc
//
//  Created by Mrinal Chanshetty on 1/3/21.
//

import Foundation
import UIKit

enum ButtonOptions: Int, CaseIterable {
    case operation
    case number
    case equals
    case other
    
    var normalColor: UIColor {
        switch self {
        case .operation, .equals:
            return .calcOrange
        case .number:
            return .calcBlack
        case .other:
            return .calcGrey
        }
    }
    
    var pushColor: UIColor {
        switch self {
        case .operation, .equals:
            return .calcOrangeLight
        case .number:
            return .calcBlackLight
        case .other:
            return .calcGreyLight
        }
    }
    
    var textColorNormal: UIColor {
        switch self {
        case .other:
            return .black
        case .equals, .number, .operation:
            return .white
        }
    }
    
}

struct CalcViewModel {
    let option: ButtonOptions
    
    init(idx : Int) {
        if (idx >= 0 && idx <= 2) {
            self.option = .other
        } else if (idx == 3 || idx == 7 || idx == 11 || idx == 15) {
            self.option = .operation
        } else if (idx == 18) {
            self.option = .equals
        } else {
            self.option = .number
        }
    }
}
