//
//  TriangleButton.swift
//  SmartPen
//
//  Created by CK on 28/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class TriangleButton: UIButton {
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        if let image = UIImage(named: "icon_triangle_normal")
        {
            self.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "icon_triangle_highlight")
        {
            self.setImage(image, for: .selected)
        }
    }
}
