//
//  QRBCScannerViewController.swift
//  QRBarcodeScannerDemo
//
//  Created by Sergio Flores Ramirez on 20/11/20.
//

import UIKit
import AVFoundation
import Resolver

class QRBCScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @Injected var viewModel: ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
             return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadatOutput = AVCaptureMetadataOutput()
        
        let size = 300
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        let xPos = (Int(screenWidth) / 2) - (size / 2)
        let yPos = (Int(screenHeight) / 2) - (size / 2)
        let scanRect = CGRect(x: Int(xPos), y: yPos, width: size, height: size)

        let scanAreaView = UIView()
        scanAreaView.layer.borderColor = UIColor.red.cgColor
        scanAreaView.layer.borderWidth = 8
        scanAreaView.frame = scanRect
    
        if captureSession.canAddOutput(metadatOutput) {
            captureSession.addOutput(metadatOutput)
            metadatOutput.rectOfInterest = convertRectOfInterest(rect: scanRect)
            metadatOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadatOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
            
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
        view.addSubview(scanAreaView)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning bot supported", message: "You device does not support scannig a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue, typeCode: readableObject.type.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func found(code: String, typeCode: String) {
        print(code)
        if typeCode == "org.iso.QRCode" {
            viewModel.qrCodeScannedFromScannerCamera.onNext(code)
            return
        }
        viewModel.bcCodeScannerFromScannerCamera.onNext(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func convertRectOfInterest(rect: CGRect) -> CGRect {
        let screenRect = self.view.frame
        let screenWidth = screenRect.width
        let screenHeight = screenRect.height
        let newX = 1 / (screenWidth / rect.minX)
        let newY = 1 / (screenHeight / rect.minY)
        let newWidth = 1 / (screenWidth / rect.width)
        let newHeight = 1 / (screenHeight / rect.height)
        return CGRect(x: newY, y: newX, width: newHeight, height: newWidth)
    }
}
