//
//  ViewController.swift
//  QRScannerApp
//
//  Created by Sandeep kumar on 10/09/23.
//

import UIKit
import AVFoundation
import CoreImage

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    @IBOutlet weak var QrScanView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.QrScanView.layer.borderWidth = 1
        self.QrScanView.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha: 1).cgColor
    }
    
    @IBAction func ScanCodeTapped(_ sender: Any) {
        setupCamera()
        
    }
    
    
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
           AlertView(message: "No Video Camera Available for scan", title: "Camera"
           )
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                return
            }
        } catch {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        QrScanView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            captureSession.stopRunning()
            
            if let qrCodeImage = generateQRCodeImage(from: metadataObject.stringValue ?? ""),let StringValue = metadataObject.stringValue {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let qrCodeDisplayVC = storyboard.instantiateViewController(withIdentifier: "QRCodeDisplayViewController") as? QRCodeDisplayViewController {
                    qrCodeDisplayVC.qrCodeImage = qrCodeImage
                    qrCodeDisplayVC.outputText = StringValue
                    navigationController?.pushViewController(qrCodeDisplayVC, animated: true)
                }
            }
        }
    }
    
    func generateQRCodeImage(from qrCodeData: String) -> UIImage? {
        let data = qrCodeData.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func AlertView(message : String,title : String ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
         }
         alertController.addAction(okAction)
         present(alertController, animated: true, completion: nil)
     }
 
        
        
    
}

