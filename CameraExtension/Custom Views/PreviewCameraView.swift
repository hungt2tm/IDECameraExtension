//
//  PreviewCameraView.swift
//  CameraExtension
//
//  Created by If Only on 3/3/18.
//  Copyright © 2018 Gnuh Nav Inc. All rights reserved.
//

import UIKit
import AVFoundation

// Custom View
class PreviewCameraView: UIView {
    // Một View có nhiều layer, mỗi layer lại có layer con...
    // self.layer : CALayer
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return self.layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // Ép kiểu CALayer về AVCaptureVideoPreviewLayer
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
