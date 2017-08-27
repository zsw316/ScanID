//
//  ViewController.swift
//  ScanID
//
//  Created by Ashley Han on 26/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            tesseract.maximumRecognitionTime = 60.0
            tesseract.image = UIImage(named: "id")?.g8_blackAndWhite()
            tesseract.recognize()
            
            textView.text = tesseract.recognizedText
            textView.isEditable = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

