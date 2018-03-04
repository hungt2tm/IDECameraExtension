//
//  ViewController.swift
//  CameraExtension
//
//  Created by If Only on 3/3/18.
//  Copyright © 2018 Gnuh Nav Inc. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraTypes {
    case Front
    case Back
    case Both
    case None
}

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var previewView: PreviewCameraView!
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: - Variable
    let session = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    var videoOutput = AVCaptureVideoDataOutput()
    var stillImgOutput = AVCaptureStillImageOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorization = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authorization == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    // User cho phép
                    self.configureSession(cameraType: .back)
                    self.session.startRunning()
                }
            })
        } else if authorization == .authorized {
            self.configureSession(cameraType: .back)
            self.session.startRunning()
        }
        
        self.previewView.session = session
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureSession(cameraType: AVCaptureDevice.Position) {
        self.session.beginConfiguration()
        self.session.sessionPreset = .high
        
        let videoDevice = ViewController.deviceWithMediaType(.video, preferringPosition: .back)
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            if self.session.canAddInput(videoDeviceInput) {
                self.session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            }
        } catch {
            print("Camera của bạn đã có vấn đề!!")
        }
        
        if self.session.canAddOutput(self.videoOutput) {
            self.session.addOutput(self.videoOutput)
        } else {
            print("Could not add photo output to the session")
        }
        
        self.stillImgOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        self.session.addOutput(stillImgOutput)
        self.session.commitConfiguration()
    }

    private class func deviceWithMediaType(_ mediaType: AVMediaType, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: mediaType) as [AVCaptureDevice]
        return devices.filter({ $0.position == position }).first
    }
    
    @IBAction func captureAction(_ sender: Any) {
        if let videoConnection = self.stillImgOutput.connection(with: .video) {
            self.stillImgOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                if let sampleBuffer = sampleBuffer, let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer) {
                    self.imgView.image = UIImage(data: imageData)
                }
            })
        }
        
    }
    
}







