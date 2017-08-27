//
//  ScannerViewController.swift
//  ScanID
//
//  Created by Ashley Han on 26/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: BaseViewController {

    var backButton: UIButton!
    var flashButton: UIButton!
    
    var scannerView: ScannerView!
    
    var captureSession: AVCaptureSession!
    var captureOutput: AVCapturePhotoOutput!
    var captureInput: AVCaptureDeviceInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var isCaptureSessionRunning: Bool = false
    
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.initNavigation()
        self.initSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.startCaptureSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - init navigation
    func initNavigation() {
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.init(named: "back-button"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(ScannerViewController.didTapBackButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Flash button
        flashButton = UIButton(type: .custom)
        flashButton.setImage(UIImage.init(named: "light-off"), for: .normal)
        flashButton.setImage(UIImage.init(named: "light-on"), for: .selected)
        flashButton.sizeToFit()
        flashButton.addTarget(self, action: #selector(ScannerViewController.didTapFlashButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: flashButton)
    }
    
    func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapFlashButton() {
        flashButton.isSelected = !flashButton.isSelected
    }
    
    // MARK: - init subviews
    func initSubviews() {
        self.initCamera()
        self.intScannerView()
        self.initCapturePhotoButton()
    }
    
    func intScannerView() {
        let rectSize: CGSize = CGSize(width: 320.0, height: 220.0)
        let offsetY: CGFloat = -50
        scannerView = ScannerView(frame: self.view.frame, rectSize: rectSize, offsetY: offsetY)
        scannerView.backgroundColor = UIColor.clear
        scannerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scannerView)
    }
    
    func initCapturePhotoButton() {
        let capturePhotoButton = UIButton(type: .custom)
        capturePhotoButton.setImage(UIImage.init(named: "capture"), for: .normal)
        capturePhotoButton.sizeToFit()
        capturePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        capturePhotoButton.addTarget(self, action: #selector(ScannerViewController.capturePhoto(_:)), for: .touchUpInside)
        view.addSubview(capturePhotoButton)
        
        // Constraints
        view.addConstraint(NSLayoutConstraint(item: capturePhotoButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: capturePhotoButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    }
    
    // MARK: - init camara
    func initCamera() {
        self.requestAuthorization { (granted: Bool) in
            self.performSelector(onMainThread: #selector(ScannerViewController.requestAuthorizationFinished), with: NSNumber.init(value: granted), waitUntilDone: false)
        }
        
        self.captureSession = AVCaptureSession()
        self.captureSession.beginConfiguration()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            captureInput = try AVCaptureDeviceInput.init(device: captureDevice)
            if self.captureSession.canAddInput(captureInput) {
                self.captureSession.addInput(captureInput)
            }
        } catch let error as NSError {
            print("captureInput error: %s", error)
        }
        
        captureOutput = AVCapturePhotoOutput()
//        captureOutput.isHighResolutionCaptureEnabled = true
        if(self.captureSession.canAddOutput(captureOutput)){
            self.captureSession.addOutput(captureOutput);
            previewLayer = AVCaptureVideoPreviewLayer();
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait;
            previewLayer.frame = self.view.bounds
            self.view.layer.addSublayer(previewLayer);
        }
        
        self.captureSession.commitConfiguration()
        self.startCaptureSession()
    }
    
    func requestAuthorization(handler: @escaping (Bool) -> Void) -> Void {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: handler)
        } else {
            handler(status == .authorized)
        }
    }
    
    func requestAuthorizationFinished(granted: NSNumber) {
        if granted.boolValue {
            
        } else {
            print("request authorization failed")
        }
    }
    
    // MARK: capture photo
    @objc private func capturePhoto(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
//        photoSettings.isHighResolutionPhotoEnabled = true
        
        if self.captureInput.device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        if !photoSettings.availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        captureOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    fileprivate func startCaptureSession() {
        if isCaptureSessionRunning {
            return
        }
        
        isCaptureSessionRunning = true
        self.captureSession.startRunning()
    }
    
    fileprivate func stopCaptureSession() {
        if !isCaptureSessionRunning {
            return
        }
        
        isCaptureSessionRunning = false
        self.captureSession.stopRunning()
    }
    
    override func navigationBarBgImage() -> UIImage? {
        return UIImage.init()
    }
    
    override func showShadowImage() -> Bool {
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func cropImage(originalImage: UIImage, cameraRect: CGRect, scanRect: CGRect) -> UIImage
    {
        let posX = (scanRect.origin.y / cameraRect.size.height) * originalImage.size.height
        let posY = (scanRect.origin.x / cameraRect.size.width) * originalImage.size.width
        let width = (scanRect.height / cameraRect.size.height) * originalImage.size.height
        let height = (scanRect.width / cameraRect.size.width) * originalImage.size.width
        
        let image = UIImage.init(cgImage: (originalImage.cgImage?.cropping(to: CGRect(x: posX, y: posY, width: width, height: height)))!)
        return UIImage.init(cgImage: (image.cgImage)!, scale: 1.0, orientation: .right)
    }
}

extension ScannerViewController: AVCapturePhotoCaptureDelegate {
    // MARK: - AVCapturePhotoCaptureDelegate Methods
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                
                if let image: UIImage = UIImage(data: dataImage) {
                    self.stopCaptureSession()
                    self.capturedImage = self.cropImage(originalImage: image, cameraRect: self.scannerView.frame, scanRect: self.scannerView.scanRect)
                    let recognizerController = DriverRecognizerViewController()
                    recognizerController.image = self.capturedImage
                    self.navigationController?.pushViewController(recognizerController, animated: true)
                }
            }
        }
        
    }
}

