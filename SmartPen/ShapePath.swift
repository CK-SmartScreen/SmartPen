//
//  ShapePath.swift
//  SmartPen
//
//  Created by CK on 17/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class ShapePath: UIBezierPath
{
    func oval(startPoint: CGPoint, translationPoint: CGPoint) -> UIBezierPath
    {
        return UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width:translationPoint.x, height: translationPoint.y))
    }
    
    func rectangle(startPoint: CGPoint, translationPoint: CGPoint) -> UIBezierPath
    {
        return UIBezierPath(rect: CGRect(x: startPoint.x, y: startPoint.y, width: translationPoint.x, height: translationPoint.y))
    }
    
    func line(startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath
    {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        linePath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        return linePath
    }
}
