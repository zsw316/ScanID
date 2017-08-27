//
//  DriverRecognizerViewController.swift
//  ScanID
//
//  Created by Ashley Han on 26/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DriverRecognizerViewController: BaseViewController {

    var imageView: UIImageView!
    var tableView: UITableView!
    var image: UIImage!
    
    var activityIndicator: CustomActivityIndicator!
    
    var entity: DriverLicenseEntity?
    
    var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        self.initSubviews()
        self.initNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.recognizeDriver(image: self.image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSubviews() {
        let imageViewHeight: CGFloat = 250.0
        let tableViewOffset: CGFloat = 10.0
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: imageViewHeight))
        imageView.image = image
        view.addSubview(imageView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: imageViewHeight + tableViewOffset, width: self.view.frame.width, height: self.view.frame.height - tableViewOffset - imageViewHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        activityIndicator = CustomActivityIndicator(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    
    func initNavigation() {
        self.title = "Identity Recognition"
        
        saveButton = UIButton(type: .custom)
        saveButton.setImage(UIImage.init(named: "save-enable"), for: .normal)
        saveButton.setImage(UIImage.init(named: "save-disable"), for: .disabled)
        saveButton.sizeToFit()
        saveButton.addTarget(self, action: #selector(DriverRecognizerViewController.didTapSaveButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        saveButton.isEnabled = false
    }
    
    // MARK: Reconginze text using Tesseract OCR
    func recognizeDriver(image: UIImage) -> Void {
        
        startRecognize()
        
        let tesseractOperation: G8RecognitionOperation = G8RecognitionOperation(language: "eng")
        tesseractOperation.tesseract.engineMode = .tesseractCubeCombined
        tesseractOperation.tesseract.pageSegmentationMode = .auto
        tesseractOperation.tesseract.maximumRecognitionTime = 60.0
        tesseractOperation.tesseract.image = image.g8_blackAndWhite()
        tesseractOperation.recognitionCompleteBlock = {(tesseract: G8Tesseract!)->Void in
            self.performSelector(onMainThread: #selector(DriverRecognizerViewController.endRecognize(tesseract:)), with: tesseract, waitUntilDone: false)
        }
        
        let queue: OperationQueue = OperationQueue()
        queue.addOperation(tesseractOperation)
    }
    
    func recognitionCompeteBlock(tesseract: G8Tesseract) -> Void {
        self.performSelector(onMainThread: #selector(DriverRecognizerViewController.endRecognize(tesseract:)), with: tesseract, waitUntilDone: false)
    }
    
    func startRecognize() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func endRecognize(tesseract: G8Tesseract) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
        self.parseRecognizedText(text: tesseract.recognizedText)
    }
    
    func parseRecognizedText(text: String) {
        
        print("recognized text: \(text)")
        let (isValidLicense, familyName, firstNames, dateOfBirth, license, version, address) = text.parseDriverLicence()
        if isValidLicense {
            self.entity = DriverLicenseEntity(familyName: familyName, firstNames: firstNames, dateOfBirth: dateOfBirth, license: license, version: version, address: address)
            saveButton.isEnabled = true
            self.tableView.reloadData()
        } else {
            let alertController: UIAlertController = UIAlertController(title: "Warning", message: "Not valid NZ Driver Licence", preferredStyle: .alert)
            let retakeAction = UIAlertAction(title: "Retake", style: .default, handler: { (action: UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            })
            let cancelAction = UIAlertAction(title: "Cacel", style: .cancel, handler: nil)
            alertController.addAction(retakeAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didTapSaveButton() {
        let driverId = DriverLicenceService.saveDriverLicence(entity: self.entity!, image: self.imageView.image!)
        var alertTitle = ""
        var alertMessage = ""
        let okAction: UIAlertAction!
        
        if driverId != 0 {
            alertTitle = "Success"
            alertMessage = "Save driver licence done"
            okAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
                self.saveButton.isEnabled = false
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            alertTitle = "Error"
            alertMessage = "Save driver licence failed"
            okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        }
        
        let alertController: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DriverRecognizerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Family Name"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.familyName
            }
        case 1:
            cell.textLabel?.text = "First Names"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.firstNames
            }
        case 2:
            cell.textLabel?.text = "Date of Birth"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.dateOfBirth
            }
        case 3:
            cell.textLabel?.text = "Licence"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.lincese
            }
        case 4:
            cell.textLabel?.text = "Version"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.version
            }
        case 5:
            cell.textLabel?.text = "Address"
            if let entity = self.entity {
                cell.detailTextLabel?.numberOfLines = 4
                cell.detailTextLabel?.text = entity.address
            }
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 80.0
        }
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Identity Information"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension DriverRecognizerViewController: G8TesseractDelegate {
    func progressImageRecognition(for tesseract: G8Tesseract!) {
    }
}
