//
//  SettingsViewController.swift
//  SmartPen
//
//  Created by CK on 19/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var brushImage: UIImageView!
    @IBOutlet weak var brushLabel: UILabel!
    @IBOutlet weak var brushSlider: UISlider!
    
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacitySlider: UISlider!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    var redColorValue: CGFloat = 0.0
    var greenColorValue: CGFloat = 0.0
    var blueColorValue: CGFloat = 0.0

    var opacity: CGFloat = 0.0
    var lineWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        brushSlider.value = Float(lineWidth)
        brushLabel.text = String(format: "%.1f", lineWidth)

        opacitySlider.value = Float(opacity)
        opacityLabel.text = String(format: "%.1f", opacity)

        sliderRed.value = Float(redColorValue * 255)
        redLabel.text = String(format: "%d", Int(sliderRed.value)) as String
        
        sliderGreen.value = Float(greenColorValue * 255)
        greenLabel.text = String(format: "%d", Int(sliderGreen.value)) as String
        
        sliderBlue.value = Float(blueColorValue * 255)
        blueLabel.text = String(format: "%d", Int(sliderBlue.value)) as String

        drawPreview()
        
    }


    override func viewWillDisappear(_ animated: Bool) {
        drawPreview()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func dismissView(_ sender: Any) {
 
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    
    @IBAction func brushSize(_ sender: Any) {
        lineWidth = CGFloat(brushSlider.value)
        brushLabel.text = String(format: "%.1f", lineWidth)

        drawPreview()
    }

    @IBAction func opacity(_ sender: Any) {
        opacity = CGFloat(opacitySlider.value)
        opacityLabel.text = String(format: "%.1f", opacity)

        drawPreview()
    }
    
    @IBAction func redSlider(_ sender: Any) {
        redColorValue = CGFloat(sliderRed.value / 255)
        redLabel.text = String(format: "%d", Int(sliderRed.value)) as String

        drawPreview()
    }
    
    @IBAction func greenSlider(_ sender: Any) {
        greenColorValue = CGFloat(sliderGreen.value / 255)
        greenLabel.text = String(format: "%d", Int(sliderGreen.value)) as String

        drawPreview()
    }
    
    @IBAction func blueSlider(_ sender: Any) {
        blueColorValue = CGFloat(sliderBlue.value / 255)
        blueLabel.text = String(format: "%d", Int(sliderBlue.value)) as String

        drawPreview()
    }
    
    func drawPreview() {

        UIGraphicsBeginImageContext(brushImage.frame.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(lineWidth)

        context?.setStrokeColor(red: redColorValue, green: greenColorValue, blue: blueColorValue, alpha: opacity)
        context?.move(to: CGPoint(x: 90.0, y: 90.0))
        context?.addLine(to: CGPoint(x: 90.0, y: 90.0))
        context?.strokePath()

        brushImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        brushImage.backgroundColor = UIColor(patternImage: UIImage(named: "brushBackground.png")!)
    }
}


