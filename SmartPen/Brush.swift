//
//  Brush.swift
//  SmartPen
//
//  Created by CK on 22/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class Brush {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    enum Shape: Int {
        case freeStyle = 0
        case oval
        case rectangle
        case line
    }

    // Brush Type
    var selectedShape = Shape.freeStyle

    // Brush Style
    var lineCap: String = kCALineCapRound
    var opacty: CGFloat = 0.8
    var size: CGFloat = 10
    let fillLineWidth: CGFloat = 3

    // Color Properties
    var red: CGFloat = 1.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var color: CGColor {
        get {
            return UIColor(red: red, green: green, blue: blue, alpha: opacty).cgColor
        }
    }

    // Location and other Properties
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
    var layer: CAShapeLayer?
    var customPath : UIBezierPath?

    func draw (Recognizer sender: UIPanGestureRecognizer!, superLayer: CALayer) {

        if sender.state == .began
        {
            customPath = UIBezierPath()
            startPoint = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.lineWidth = (selectedShape == .line || selectedShape == .freeStyle) ? self.size : fillLineWidth
            layer?.strokeColor = self.color
            layer?.fillColor = self.color
            layer?.lineCap = self.lineCap
            superLayer.addSublayer(layer!)
        }
        else if sender.state == .changed
        {
            switch selectedShape
            {
            case .oval:
                let translation = sender.translation(in: sender.view)
                layer?.path = ShapePath().oval(startPoint: startPoint, translationPoint: translation).cgPath

            case .rectangle:
                let translation = sender.translation(in: sender.view)
                layer?.path = ShapePath().rectangle(startPoint: startPoint, translationPoint: translation).cgPath

            case .line:
                endPoint = sender.location(in: sender.view)
                layer?.path = ShapePath().line(startPoint: startPoint, endPoint: endPoint).cgPath

            case .freeStyle:
                endPoint = sender.location(in: sender.view)
                customPath?.move(to: startPoint)
                customPath?.addLine(to: endPoint)
                startPoint = endPoint
                customPath?.close()
                layer?.path = customPath?.cgPath
            }
        }
    }

    func erase(Recognizer sender: UIPanGestureRecognizer!, superLayer: CALayer) {

        if sender.state == .began
        {
            customPath = UIBezierPath()
            startPoint = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer!.lineWidth = self.size
            layer!.strokeColor = UIColor.white.cgColor
            layer!.fillColor = UIColor.white.cgColor
            layer!.lineCap = kCALineCapRound
            superLayer.addSublayer(layer!)
        }
        else if sender.state == .changed
        {
            endPoint = sender.location(in: sender.view)
            customPath?.move(to: startPoint)
            customPath?.addLine(to: endPoint)
            startPoint = endPoint
            customPath?.close()
            layer?.path = customPath?.cgPath
        }
    }
}
