//
//  LoginButton.swift
//  SmartPen
//
//  Created by CK on 30/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        if let image = UIImage(named: "icon_account_normal")
        {
            self.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "icon_account_highlight")
        {
            self.setImage(image, for: .selected)
        }
    }
}
