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
    @IBOutlet weak var eraser: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
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

    var ifUsingEaser = false

    //------------
    let currentBrush = Brush()
    var buttonColorMappingArray: [(button: UIButton, (red: CGFloat, green: CGFloat, blue: CGFloat))] = []
    var buttonBackgroundColor: UIColor {
        return UIColor(red: 63/255, green: 125/255, blue: 182/255, alpha: 1)
    }

    var selectedColorTag: Int = 0 {

        willSet(newButtonTag){

            if newButtonTag == -1 {
                // New color comes from setting view, no button to highligh
                return
            }
            // Highlight the select Color Button
            buttonColorMappingArray[newButtonTag].button.backgroundColor = buttonBackgroundColor
        }
        didSet(oldButtonTag){

            // if click the same color button
            if oldButtonTag == selectedColorTag || oldButtonTag == -1 {
                return
            }

            // Remove hight from old button
            buttonColorMappingArray[oldButtonTag].button.backgroundColor = UIColor.white

            // Sync the color value used in SettingViewController
            if 0 <= selectedColorTag && selectedColorTag <= 4 {
                // Modify the Setting View's color value
                redColorValue = currentBrush.red
                greenColorValue = currentBrush.green
                blueColorValue = currentBrush.blue
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
        redButton.backgroundColor = buttonBackgroundColor
        
        // Order according to enum property "colorButton", for highlighting the selected button
//        colorButtonArray = [red, yellow, green, blue, purple, eraser]

        //---------
        buttonColorMappingArray = [(button: self.redButton , (red: 1, green: 0, blue: 0)),
                                   (button: self.yellowButton, (red: 1, green: 1, blue: 0)),
                                   (button: self.greenButton, (red: 0, green: 1, blue: 0)),
                                   (button: self.blueButton, (red: 0, green: 0, blue: 1)),
                                   (button: self.purpleButton, (red: 0.5, green: 0, blue: 0.5))]


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {

        if ifUsingEaser {
            currentBrush.erase(Recognizer: sender, superLayer: self.view.layer)
        } else {
            currentBrush.draw(Recognizer: sender, superLayer: self.view.layer)
        }

//----------------
//        if sender.state == .began
//        {
//            customPath = UIBezierPath()
//            startPoint = sender.location(in: sender.view)
//            layer = CAShapeLayer()
//            layer?.lineWidth = lineWidth
//            layer?.strokeColor = selectedColor
//            layer?.fillColor = selectedColor
//            layer?.lineCap = lineCap
//            self.view.layer.addSublayer(layer!)
//        }
//        else if sender.state == .changed
//        {
//
//            switch selectedShape
//            {
//            case .oval:
//                let translation = sender.translation(in: sender.view)
//                layer?.path = ShapePath().oval(startPoint: startPoint, translationPoint: translation).cgPath
//                
//            case .rectangle:
//                let translation = sender.translation(in: sender.view)
//                layer?.path = ShapePath().rectangle(startPoint: startPoint, translationPoint: translation).cgPath
//                
//            case .line:
//                endPoint = sender.location(in: sender.view)
//                layer?.path = ShapePath().line(startPoint: startPoint, endPoint: endPoint).cgPath
//                
//            case .freeStyle:
//                endPoint = sender.location(in: sender.view)
//                customPath?.move(to: startPoint)
//                customPath?.addLine(to: endPoint)
//                startPoint = endPoint
//                customPath?.close()
//                layer?.path = customPath?.cgPath
//                
//            default:
//                endPoint = sender.location(in: sender.view)
//                customPath?.move(to: startPoint)
//                customPath?.addLine(to: endPoint)
//                startPoint = endPoint
//                customPath?.close()
//                layer?.path = customPath?.cgPath
//            }
//        }
    }

    @IBAction func shapeDidSelect(_ sender: UIButton) {

        selectedShape = Shapes(rawValue: sender.tag)!
        currentBrush.selectedShape = Brush.Shape(rawValue: sender.tag)!
        ifUsingEaser = false
    }
    
    @IBAction func colorDidSelect(_ sender: UIButton) {

        selectedColorTag = sender.tag
        currentBrush.red = buttonColorMappingArray[selectedColorTag].1.red
        currentBrush.green = buttonColorMappingArray[selectedColorTag].1.green
        currentBrush.blue = buttonColorMappingArray[selectedColorTag].1.blue
    }

    @IBAction func erase(_ sender: Any) {

        ifUsingEaser = true
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.redColorValue = currentBrush.red
        settingsViewController.greenColorValue = currentBrush.green
        settingsViewController.blueColorValue = currentBrush.blue
        settingsViewController.opacity = currentBrush.opacty
        settingsViewController.lineWidth = currentBrush.size
    }
}

extension ViewController: SettingsViewControllerDelegate {

    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {

        // If color setting is not changed
        if self.currentBrush.red == settingsViewController.redColorValue &&
            self.currentBrush.green == settingsViewController.greenColorValue &&
            self.currentBrush.blue == settingsViewController.blueColorValue {

            self.currentBrush.opacty = settingsViewController.opacity
            self.currentBrush.size = settingsViewController.lineWidth

        } else // if color changed get the new color from Setting View
        {
            self.currentBrush.red = settingsViewController.redColorValue
            self.currentBrush.green = settingsViewController.greenColorValue
            self.currentBrush.blue = settingsViewController.blueColorValue

            self.selectedColorTag = -1
        }

    }
}
