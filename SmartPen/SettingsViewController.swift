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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sliderRed.value = Float(redColorValue * 255)
        redLabel.text = String(format: "%d", Int(sliderRed.value)) as String
        
        sliderGreen.value = Float(greenColorValue * 255)
        greenLabel.text = String(format: "%d", Int(sliderGreen.value)) as String
        
        sliderBlue.value = Float(blueColorValue * 255)
        blueLabel.text = String(format: "%d", Int(sliderBlue.value)) as String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissView(_ sender: Any) {
 
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    
    @IBAction func brushSize(_ sender: Any) {
    }

    @IBAction func opacity(_ sender: Any) {
    }
    
    @IBAction func redSlider(_ sender: Any) {
        redColorValue = CGFloat(sliderRed.value / 255)
        redLabel.text = String(format: "%d", Int(sliderRed.value)) as String
    }
    
    @IBAction func greenSlider(_ sender: Any) {
        greenColorValue = CGFloat(sliderGreen.value / 255)
        greenLabel.text = String(format: "%d", Int(sliderGreen.value)) as String
    }
    
    @IBAction func blueSlider(_ sender: Any) {
        blueColorValue = CGFloat(sliderBlue.value / 255)
        blueLabel.text = String(format: "%d", Int(sliderBlue.value)) as String
    }
    

    
    
}


