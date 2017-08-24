//
//  DeleteButton.swift
//  SmartPen
//
//  Created by Chunkai Meng on 8/24/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class DeleteButton: UIButton {
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor(red:0, green:0 , blue:255/255, alpha:0.3).cgColor
        self.layer.cornerRadius = 5
        
        if let image = UIImage(named: "cicon_delete_normal")
        {
            self.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "icon_delete_highlight")
        {
            self.setImage(image, for: .highlighted)
        }
    }
}
