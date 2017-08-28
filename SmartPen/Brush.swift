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
        case line
        case oval
        case rectangle
        case triangle
        case parallelogram
    }

    // Brush Type
    var selectedShape = Shape.freeStyle

    // Brush Style
    var lineCap: String = kCALineCapRound
    var opacty: CGFloat = 0.85
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
            layer?.lineWidth = 0
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
                layer?.lineWidth = self.size
                endPoint = sender.location(in: sender.view)
                layer?.path = ShapePath().line(startPoint: startPoint, endPoint: endPoint).cgPath

            case .freeStyle:
                layer?.lineWidth = self.size
                endPoint = sender.location(in: sender.view)
                customPath?.move(to: startPoint)
                customPath?.addLine(to: endPoint)
                startPoint = endPoint
                customPath?.close()
                layer?.path = customPath?.cgPath

            case .triangle:
                endPoint = sender.location(in: sender.view)
                layer?.path = ShapePath().triangle(startPoint: startPoint, endPoint: endPoint).cgPath

            case .parallelogram:
                endPoint = sender.location(in: sender.view)
                layer?.path = ShapePath().parallelogram(startPoint: startPoint, endPoint: endPoint).cgPath
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
