//
//  Colors.swift
//  SmartPen
//
//  Created by CK on 20/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

enum ColorButton: Int {
    case red = 0
    case yellow
    case green
    case blue
    case purple
    case white
}

let colorGroupDict = [ColorButton.red: UIColor.red.cgColor,
                      ColorButton.yellow: UIColor.yellow.cgColor,
                      ColorButton.green: UIColor.green.cgColor,
                      ColorButton.blue: UIColor.blue.cgColor,
                      ColorButton.purple: UIColor.purple.cgColor,
                      ColorButton.white: UIColor.white.cgColor]
