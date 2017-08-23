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
    @IBOutlet weak var imageView: UIImageView!

    
    lazy var shapeButtonArray: [(UIButton, String)] = { return [(self.freeStyle!, "icon_freestyle"),
                                                                (self.oval!, "icon_oval"),
                                                                (self.rect!, "icon_rectangle"),
                                                                (self.line!, "icon_line"),
                                                                (self.eraser!, "icon_eraser")] }()
    var colorButtonArray: [UIButton] = []
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
    var customPath : UIBezierPath?
    var layer : CAShapeLayer?
    var lineCap:String = kCALineCapRound
    var redColorValue: CGFloat = 1.0
    var greenColorValue: CGFloat = 0.0
    var blueColorValue: CGFloat = 0.0
    var ifUsingEaser = false

    // Create a new Brush
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

    // Change Button Highlight
    var selectedShape = Shapes.freeStyle {

        willSet(newShape) {

            // Set the selected button with highlighted image
            var (activeButton, iconFile) = shapeButtonArray[newShape.rawValue]
            iconFile += "_highlight"
            activeButton.setBackgroundImage(UIImage(named: iconFile), for: .normal)
        }
        didSet(oldShape){

            // Set the unselected button without highlighted image
            if oldShape != selectedShape {
                var (activeButton, iconFile) = shapeButtonArray[oldShape.rawValue]
                iconFile += "_normal"
                activeButton.setBackgroundImage(UIImage(named: iconFile), for: .normal)
            }
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        buttonColorMappingArray = [(button: self.redButton , (red: 1, green: 0, blue: 0)),
                                   (button: self.yellowButton, (red: 1, green: 1, blue: 0)),
                                   (button: self.greenButton, (red: 0, green: 1, blue: 0)),
                                   (button: self.blueButton, (red: 0, green: 0, blue: 1)),
                                   (button: self.purpleButton, (red: 0.5, green: 0, blue: 0.5))]

        // Highlight default butons
        selectedShape = .freeStyle
        selectedColorTag = 0
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {

        if ifUsingEaser {
            currentBrush.erase(Recognizer: sender, superLayer: imageView.layer)
        } else {
            currentBrush.draw(Recognizer: sender, superLayer: imageView.layer)
        }
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
        selectedShape = .eraser
    }

    @IBAction func saveArtwork(_ sender: Any) {

        UIGraphicsBeginImageContext(self.imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }

    @IBAction func deleteView(_ sender: Any) {

        let alertController = UIAlertController(title: "Delete", message: "Permanently delete your artwork, is this what you intented to do?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Continue", style: .default) { (UIAlertAction) in
            self.imageView.layer.sublayers = nil
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

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

        if self.currentBrush.red == settingsViewController.redColorValue &&
            self.currentBrush.green == settingsViewController.greenColorValue &&
            self.currentBrush.blue == settingsViewController.blueColorValue
        {
        // If color setting didn't change
        // Get new opacty & size
            self.currentBrush.opacty = settingsViewController.opacity
            self.currentBrush.size = settingsViewController.lineWidth
        } else {
        // Get the new color from Setting View
            self.currentBrush.red = settingsViewController.redColorValue
            self.currentBrush.green = settingsViewController.greenColorValue
            self.currentBrush.blue = settingsViewController.blueColorValue

        // remove highlight from color button
            self.selectedColorTag = -1
        }
    }
}
