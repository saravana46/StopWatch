//
//  Extension.swift
//  StopWatchTimer
//
//  Created by Saravana on 28/10/22.
//

import Foundation
import UIKit

extension UIButton {
    
    func setBorder() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}
