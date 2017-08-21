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

    @IBOutlet weak var eraser: UIButton!
    @IBOutlet weak var label: UILabel!
    
    lazy var shapeButtonArray: [(UIButton, String)] = { return [(self.freeStyle!, "icon_button_freestyle02"),
                                                                (self.oval!, "icon_button_oval02"),
                                                                (self.rect!, "icon_button_rectangle02"),
                                                                (self.line!, "icon_button_line02")] }()

    var colorButtonArray: [UIButton] = []
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
    var customPath : UIBezierPath?
    var layer : CAShapeLayer?
    var lineCap:String = kCALineCapRound
    var redColorValue: CGFloat = 1.0
    var greenColorValue: CGFloat = 0.0
    var blueColorValue: CGFloat = 0.0
    var customColor: CGColor?
    var lineWidth: CGFloat = 0.0
    var opacity: CGFloat = 0.0

    var selectedColor: CGColor {
        get {

            if let colorName = ColorButton(rawValue: selectedColorTag) {

                // color from Palette
                let color = colorGroupDict[colorName]!
                return color.copy(alpha: opacity)!

            } else {

                // color from setting view
                return customColor!.copy(alpha: opacity)!

            }
        }
    }

    var selectedColorTag: Int = 0 {

        willSet(newButton){

            // Highlight the select Color Button
            if newButton != -1 {
                colorButtonArray[newButton].backgroundColor = UIColor.colorButtonBackground
            }

        }
        didSet(oldButton){

            if oldButton != selectedColorTag && oldButton != -1 {
                colorButtonArray[oldButton].backgroundColor = UIColor.white
            }
            if selectedColorTag != -1 {
                // Modify the Setting View's color value
                redColorValue = (selectedColor.components?[0])!
                greenColorValue = (selectedColor.components?[1])!
                blueColorValue = (selectedColor.components?[2])!
            }
        }
    }
    

    var selectedShape = Shapes.freeStyle {

        willSet(newShape) {
            // Set the selected button with highlighted image
            let (activeButton, iconFile) = shapeButtonArray[newShape.rawValue]
            activeButton.setImage(UIImage(named: iconFile), for: UIControlState.normal)
        }
        didSet(oldShape){
            // Set the unselected button without highlighted image
            if oldShape != selectedShape {
                let (activeButton, _) = shapeButtonArray[oldShape.rawValue]
                activeButton.setImage(UIImage(named: ""), for: UIControlState.normal)
            }
        }
    }
    

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        lineWidth = 3
        opacity = 1.0

        // Initialize default Shape
        selectedShape = Shapes.freeStyle

        // Initialize default color
        red.backgroundColor = UIColor.colorButtonBackground
        
        // Order according to enum property "colorButton", for highlighting the selected button
        colorButtonArray = [red, yellow, green, blue, purple, eraser]
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
            layer?.lineWidth = lineWidth
            layer?.strokeColor = selectedColor
            layer?.fillColor = selectedColor
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

        selectedColorTag = sender.tag
    }

    @IBAction func erase(_ sender: Any) {

        selectedColorTag = 5
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.redColorValue = redColorValue
        settingsViewController.greenColorValue = greenColorValue
        settingsViewController.blueColorValue = blueColorValue
        settingsViewController.opacity = opacity
        settingsViewController.lineWidth = lineWidth
    }
}

extension ViewController: SettingsViewControllerDelegate {

    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {

        self.redColorValue = settingsViewController.redColorValue
        self.greenColorValue = settingsViewController.greenColorValue
        self.blueColorValue = settingsViewController.blueColorValue
        self.opacity = settingsViewController.opacity
        self.lineWidth = settingsViewController.lineWidth
        
        // If custom color is in the default color group,
        // just reset the selected Button Tag
        // Otherwise, set the selected Color into custom color.
        let x = { UIColor(red: self.redColorValue, green: self.greenColorValue, blue: self.blueColorValue, alpha: 1) }()
        self.customColor = x.cgColor
        if let index = colorGroupDict.index(where: { $0.value == customColor }) {
            self.selectedColorTag = colorGroupDict[index].key.rawValue
        } else {
            // Notify the computed property selectedColor to select custom color
            self.selectedColorTag = -1
        }
    }
}
