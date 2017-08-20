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
    @IBOutlet weak var label: UILabel!
    
    lazy var shapeButtonArray: [(UIButton, String)] = { return [(self.freeStyle!, "icon_button_freestyle02"),
                                                                (self.oval!, "icon_button_oval02"),
                                                                (self.rect!, "icon_button_rectangle02"),
                                                                (self.line!, "icon_button_line02")] }()
    
    lazy var colorButtonArray: [(UIButton, CGColor)] = { return [(self.red!, UIColor.transparentRed.cgColor),
                                                                 (self.yellow!, UIColor.transparentYellow.cgColor),
                                                                 (self.green!, UIColor.transparentGreen.cgColor),
                                                                 (self.blue!, UIColor.transparentBlue.cgColor),
                                                                 (self.purple!, UIColor.transparentPurple.cgColor)] }()
    var redColorValue: CGFloat = 0.0
    var greenColorValue: CGFloat = 0.0
    var blueColorValue: CGFloat = 0.0
    
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
    var customPath : UIBezierPath?
    var layer : CAShapeLayer?
    var lineCap:String = kCALineCapRound
    var selectedColor = UIColor.transparentRed.cgColor
    
    var selectedColorButton: Int = 0 {
        willSet(newButton){
            colorButtonArray[newButton].0.backgroundColor = UIColor.colorButtonBackground
        }
        didSet(oldButton){
            colorButtonArray[oldButton].0.backgroundColor = UIColor.white
        }
    }
    

    var selectedShape = Shapes.freeStyle {
        willSet(newShape) {
            // Set the selected button with highlighted image
            let (activeButton, iconName) = shapeButtonArray[newShape.rawValue]
            activeButton.setImage(UIImage(named: iconName), for: UIControlState.normal)
        }
        didSet(oldShape){
            // Set the unselected button without highlighted image
            let (activeButton, _) = shapeButtonArray[oldShape.rawValue]
            activeButton.setImage(UIImage(named: ""), for: UIControlState.normal)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set default selected button
        let btnImage = UIImage(named: "icon_button_freestyle02")
        freeStyle.setImage(btnImage, for: UIControlState.normal)
        
        // Set default selected color
        red.backgroundColor = UIColor.colorButtonBackground
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
            layer?.lineWidth = 3.0
//            layer?.strokeColor = selectedColor
            let cclor = UIColor(red: redColorValue, green: greenColorValue, blue: blueColorValue, alpha: 1)
            layer?.strokeColor = cclor.cgColor
//          layer?.fillColor = selectedColor
            layer?.fillColor = cclor.cgColor
            
            layer?.lineCap = lineCap
            self.view.layer.addSublayer(layer!)
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

    @IBAction func shapeDidSelect(_ sender: UIButton) {
        selectedShape = Shapes(rawValue: sender.tag)!
    }
    
    @IBAction func colorDidSelect(_ sender: UIButton) {
        (_, selectedColor) = colorButtonArray[sender.tag]
        selectedColorButton = sender.tag
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.redColorValue = redColorValue
        settingsViewController.greenColorValue = greenColorValue
        settingsViewController.blueColorValue = blueColorValue
        
    }
    
}

extension ViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
        self.redColorValue = settingsViewController.redColorValue
        self.greenColorValue = settingsViewController.greenColorValue
        self.blueColorValue = settingsViewController.blueColorValue
    }
}


