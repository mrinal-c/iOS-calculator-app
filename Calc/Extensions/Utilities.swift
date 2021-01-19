//
//  Utilities.swift
//  Calc
//
//  Created by Mrinal Chanshetty on 12/31/20.
//

import Foundation
import UIKit

class Utilities {
    //MARK: - Helpers
    func getButtonType(index: Int) -> String {
        let button = buttons[index]
        switch (button) {
        case "+", "-", "⨉", "÷":
            return "operation"
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".":
            return "number"
        case "=":
            return "equals"
        default:
            return "other"
        }
    }
    
    func getNormalColor(idx: Int) -> UIColor {
        if (idx >= 0 && idx <= 2) {
            return .calcGrey
        } else if (idx == 3 || idx == 7 || idx == 11 || idx == 15 || idx == 18) {
            return .calcOrange
        } else {
            return .calcBlack
        }
    }
    
    func getPushColor(idx: Int) -> UIColor {
        if (idx >= 0 && idx <= 2) {
            return .calcGreyLight
        } else if (idx == 3 || idx == 7 || idx == 11 || idx == 15 || idx == 18) {
            return .calcOrangeLight
        } else {
            return .calcBlackLight
        }
    }
    
    func getButtonIndex(buttonString: String) -> Int {
        var counter = 0
        for element in buttons {
            if (element == buttonString) {
                break
            }
            counter += 1
        }
        return counter
    }
}
