//
//  ViewController.swift
//  SmartPen
//
//  Created by CK on 17/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eraser: EraserButton!
    @IBOutlet weak var settingButton: SettingButton!
    @IBOutlet weak var deleteButton: DeleteButton!
    @IBOutlet weak var saveButton: SavingButton!
    @IBOutlet weak var freestyleButton: FreeStyleButton!
    @IBOutlet weak var lineButton: LineButton!
    @IBOutlet weak var ovalButton: OvalButton!
    @IBOutlet weak var rectButton: RectangleButton!
    @IBOutlet weak var triangleButton: TriangleButton!
    @IBOutlet weak var parallelogramButton: ParallelogramButton!
    var buttonBackgroundColor: UIColor {
        return UIColor(red: 63/255, green: 125/255, blue: 182/255, alpha: 1)
    }
    var shapeButtonArray: [UIButton] = []
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

    var selectedShapeTag: Int = 0 {
        willSet(newTag) {
            shapeButtonArray[newTag].isSelected = true
        }
        didSet(oldTag) {
            if selectedShapeTag != oldTag {
                shapeButtonArray[oldTag].isSelected = false
            }
        }
    }


    var selectedColorTag: Int = 0 {
        willSet(newTag) {
            if newTag != -1{
            colorButtonArray[newTag].backgroundColor = buttonBackgroundColor
            }
        }
        didSet(oldTag) {
            if selectedColorTag != oldTag {
                colorButtonArray[oldTag].backgroundColor = UIColor.white
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        shapeButtonArray = [freestyleButton, lineButton, ovalButton, rectButton, triangleButton, parallelogramButton, eraser]
        colorButtonArray = [redButton, yellowButton, greenButton, blueButton, purpleButton]

        selectedColorTag = 0
        selectedShapeTag = 0

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

        selectedShapeTag = sender.tag

        if sender.tag == 6 {
            ifUsingEaser = true
        } else {
            ifUsingEaser = false
            currentBrush.selectedShape = Brush.Shape(rawValue: sender.tag)!
        }
    }


    @IBAction func colorDidSelect(_ sender: UIButton) {

        selectedColorTag = sender.tag

        let currentColor = colorButtonArray[selectedColorTag].currentTitleColor

        var colorComponet = currentColor.cgColor.components
        currentBrush.red = colorComponet![0]
        currentBrush.green = colorComponet![1]
        currentBrush.blue = colorComponet![2]
        redColorValue = currentBrush.red
        greenColorValue = currentBrush.green
        blueColorValue = currentBrush.blue
    }


    @IBAction func saveArtwork(_ sender: Any) {

        UIGraphicsBeginImageContext(self.imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if UIDevice.current.userInterfaceIdiom == .pad {

            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            let alertController = UIAlertController(title: "Image Saved", message: "You can see your artwork in Photo Library!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        } else {
            let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
            present(activity, animated: true, completion: nil)
        }
    }


    @IBAction func deleteView(_ sender: Any) {

        let alertController = UIAlertController(title: "Delete", message: "Permanently delete your artwork, is this what you intented to do?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Delete", style: .cancel) { (UIAlertAction) in
            self.imageView.layer.sublayers = nil
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let settingsViewController = segue.destination as! SettingsViewController
        // regesteration delegate
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
            self.currentBrush.blue == settingsViewController.blueColorValue {

            // Get new opacty & size
            self.currentBrush.opacty = settingsViewController.opacity
            self.currentBrush.size = settingsViewController.lineWidth

        } else {

            // Get the new color from Setting View
            self.currentBrush.red = settingsViewController.redColorValue
            self.currentBrush.green = settingsViewController.greenColorValue
            self.currentBrush.blue = settingsViewController.blueColorValue

            // remove highlight from color button
            colorButtonArray[selectedColorTag].backgroundColor = UIColor.white
        }
    }
}
