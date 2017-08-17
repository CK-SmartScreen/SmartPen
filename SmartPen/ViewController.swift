//
//  ViewController.swift
//  SmartPen
//
//  Created by CK on 17/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var freeStyle: UIButton!
    @IBOutlet weak var oval: UIButton!
    @IBOutlet weak var rect: UIButton!
    @IBOutlet weak var line: UIButton!
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var purple: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
    var customPath : UIBezierPath?
    var layer : CAShapeLayer?
    
    var selectedShape = Shapes.freeStyle
    var selectedColor = UIColor.transparentRed.cgColor
    
    var lineCap:String = kCALineCapRound
    
    let shapeArray = [Shapes.freeStyle, Shapes.oval, Shapes.rectangle, Shapes.line]
    let colorArray = [UIColor.transparentRed.cgColor,
                      UIColor.transparentYellow.cgColor,
                      UIColor.transparentGreen.cgColor,
                      UIColor.transparentBlue.cgColor,
                      UIColor.transparentPurple.cgColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        red.layer.cornerRadius = 3
//        red.layer.borderWidth = 1
//        red.layer.borderColor = UIColor.cyan.cgColor
//        green.layer.cornerRadius = 3
//        green.layer.borderWidth = 1
//        green.layer.borderColor = UIColor.cyan.cgColor
//        yellow.layer.cornerRadius = 3
//        yellow.layer.borderWidth = 1
//        yellow.layer.borderColor = UIColor.cyan.cgColor
//        blue.layer.cornerRadius = 3
//        blue.layer.borderWidth = 1
//        blue.layer.borderColor = UIColor.cyan.cgColor
//        purple.layer.cornerRadius = 3
//        purple.layer.borderWidth = 1
//        purple.layer.borderColor = UIColor.cyan.cgColor
//        delete.frame = CGRect(x: 0, y: 0 , width: 3, height: 3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began
        {
            customPath = UIBezierPath()
            startPoint = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = selectedColor
            layer?.lineWidth = 3.0
            layer?.strokeColor = selectedColor
            layer?.lineCap = lineCap
            self.view.layer.addSublayer(layer!)
        }
        else if sender.state == .changed
        {
            switch selectedShape
            {
            case Shapes.oval:
                let translation = sender.translation(in: sender.view)
                layer?.path = ShapePath().oval(startPoint: startPoint, translationPoint: translation).cgPath
                
            case Shapes.rectangle:
                let translation = sender.translation(in: sender.view)
                layer?.path = ShapePath().rectangle(startPoint: startPoint, translationPoint: translation).cgPath
                
            case Shapes.line:
                endPoint = sender.location(in: sender.view)
                layer?.path = ShapePath().line(startPoint: startPoint, endPoint: endPoint).cgPath
                
            case Shapes.freeStyle:
                endPoint = sender.location(in: sender.view)
                customPath?.move(to: startPoint)
                customPath?.addLine(to: endPoint)
                startPoint = endPoint
                customPath?.close()
                layer?.path = customPath?.cgPath
            }
        }
    }

    @IBAction func shapeDidSelect(_ sender: UIButton) {
        selectedShape = shapeArray[sender.tag]
    }
    
    @IBAction func colorDidSelect(_ sender: UIButton) {
        selectedColor = colorArray[sender.tag]
    }
    
    
}

