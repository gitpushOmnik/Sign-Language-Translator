//
//  TranslatorViewController.swift
//  SignLanguageTranslator
//
//  Created by Omkar Nikhal.
//

import UIKit
import CoreML
import AVFoundation
import Vision

class TranslatorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var captureSession = AVCaptureSession()
    private let dataOutput = AVCaptureVideoDataOutput()
    private var captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: AVCaptureDevice.Position.front)
    
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.outputLabel.text = "Loading up camera..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCamera()
    }
    
    func configureCamera() {
        captureSession.sessionPreset = .photo
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(captureInput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
        self.outputLabel.text = ""
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        
        defer { captureSession.commitConfiguration() }
        
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
        
        for device in devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let signLanguageModel = try? VNCoreMLModel(for: SignLanguageClassifier(configuration:  MLModelConfiguration()).model) else {return}
        
        let imageRequest =  VNCoreMLRequest(model: signLanguageModel) { (request, err) in
            
            guard let results = request.results as? [VNClassificationObservation] else {return}
            
            guard let topResult = results.first else {return}
            
            var confidence = (topResult.confidence * 100).rounded(.awayFromZero)
            
            confidence = ((confidence/50) * 100).rounded(.awayFromZero)
            
            if(confidence > 80) {
                DispatchQueue.main.async {
                    
                    self.outputLabel.text = topResult.identifier
                }
            }
        }
        
        do{
            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([imageRequest])
        } catch{
            print("Error performing \(error)")
        }
    }
    
}

