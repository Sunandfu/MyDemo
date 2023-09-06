//
//  Camera.swift
//  Alerts&Pickers
//
//  Created by Lex on 05.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation
import AVFoundation

public final class Camera {
    
    public enum CameraError: Error {
        case accessDenied
    }
    
    public enum StreamError: Error {
        case deviceUnsupported
        case sessionStartFailed
    }
    
    public static func requestAccess(_ requestGranted: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            requestGranted(granted)
        }
    }
    
    public static var authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    public enum CameraResult {
        case success(PreviewStream)
        case error(error: Error)
    }
    
    public enum StreamResult {
        case stream(PreviewStream)
        case error(error: Error)
    }
    
    public final class PreviewStream: Equatable {
        
        public let device: AVCaptureDevice
        
        public let input: AVCaptureDeviceInput
        
        public let session: AVCaptureSession
        
        internal let queue: DispatchQueue
        
        public init(device: AVCaptureDevice, input: AVCaptureDeviceInput, session: AVCaptureSession, queue: DispatchQueue) {
            self.session = session
            self.input = input
            self.device = device
            self.queue = queue
        }
        
        public func startIfNeeded() {
            guard !session.isRunning else {
                return
            }
            self.queue.async {
                self.session.startRunning()
            }
        }
        
        /// Completion handler performs on separate thread
        public static func create(_ completionHandler: @escaping (StreamResult)->()) {
            let queue = createQueue()
            queue.async {
                let session = AVCaptureSession()
                
                session.beginConfiguration()
                
                guard let device = createDevice() else {
                    completionHandler(.error(error: StreamError.deviceUnsupported))
                    return
                }
                
                guard let preset = definePreset(session: session, device: device) else {
                    completionHandler(.error(error: StreamError.deviceUnsupported))
                    return
                }
                
                session.sessionPreset = preset
                
                let input: AVCaptureDeviceInput
                do {
                    input = try AVCaptureDeviceInput.init(device: device)
                }
                catch {
                    completionHandler(.error(error: error))
                    return
                }
                
                guard session.canAddInput(input) else {
                    completionHandler(.error(error: StreamError.sessionStartFailed))
                    return
                }
                
                session.addInput(input)
                
                session.commitConfiguration()
                
                session.startRunning()
                
                let stream = PreviewStream.init(device: device, input: input, session: session, queue: queue)
                print("Create camera stream. Device \(device), input \(input), session \(session)")
                
                completionHandler(.stream(stream))
            }
        }
        
        private static func definePreset(session: AVCaptureSession, device: AVCaptureDevice) -> AVCaptureSession.Preset? {
            
            let desiredPresets: [AVCaptureSession.Preset] = [.medium, .low, .high]
            for preset in desiredPresets {
                if session.canSetSessionPreset(preset) && device.supportsSessionPreset(preset) {
                    return preset
                }
            }
            return nil
        }
        
        private static func createQueue() -> DispatchQueue {
            return DispatchQueue.init(label: "CameraQueue \(arc4random())",
                                      qos: .background,
                                      attributes: [],
                                      autoreleaseFrequency: .workItem,
                                      target: nil)
        }
        
        private static func createDevice() -> AVCaptureDevice? {
            return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        }
        
        public static func == (lhs: PreviewStream, rhs: PreviewStream) -> Bool {
            return lhs.session === rhs.session && lhs.input === rhs.input && lhs.device == rhs.device
        }
        
    }
    
}
