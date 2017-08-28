//
//  SavingButton.swift
//  SmartPen
//
//  Created by Chunkai Meng on 8/24/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class SavingButton: UIButton {
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        if let image = UIImage(named: "cicon_saving_normal")
        {
            self.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "icon_saving_highlight")
        {
            self.setImage(image, for: .highlighted)
        }
    }
}
