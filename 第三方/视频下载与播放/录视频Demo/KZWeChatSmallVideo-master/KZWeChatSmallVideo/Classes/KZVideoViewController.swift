//
//  KZVideoViewController.swift
//  KZWeChatSmallVideo
//
//  Created by HouKangzhu on 16/7/11.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

import UIKit
import AVFoundation

@objc public protocol KZVideoViewControllerDelegate {
    
    optional func videoViewController(videoViewController: KZVideoViewController!, didRecordVideo video:KZVideoModel!)
    
    optional func videoViewControllerDidCancel(videoViewController: KZVideoViewController!)
    
}

private var currentVC:KZVideoViewController? = nil

public class KZVideoViewController: NSObject, KZControllerBarDelegate, AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let view:UIView = UIView(frame:UIScreen.mainScreen().bounds)
    
    private let actionView:UIView! = UIView(frame: viewFrame)
    
    private let topSlideView:KZStatusBar! = KZStatusBar()
    
    private let videoView:UIView! = UIView()
    private let focusView:KZfocusView! = KZfocusView(frame: CGRectMake(0, 0, 60, 60))
    private let statusInfo:UILabel = UILabel()
    private let cancelInfo:UILabel = UILabel()
    
    private let ctrlBar:KZControllerBar! = KZControllerBar()
    
    private var videoSession:AVCaptureSession! = nil
    private var videoPreLayer:AVCaptureVideoPreviewLayer! = nil
    private var videoDevice:AVCaptureDevice! = nil
    private var moveOut:AVCaptureMovieFileOutput? = nil
//    private var videoDataOut:AVCaptureVideoDataOutput? = nil
    
//    AVCaptureVideoDataOutput
    private var currentRecord:KZVideoModel? = nil
    private var currentRecordIsCancel:Bool = false
    
    public var delegate:KZVideoViewControllerDelegate? = nil
    
    func startAnimation() {
        
        self.controllerSetup()
        currentVC = self
        let keyWindow = UIApplication.sharedApplication().delegate?.window!
        keyWindow?.addSubview(self.view)
        self.actionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, kzSCREEN_HEIGHT*0.6)
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { 
            self.actionView.transform = CGAffineTransformIdentity
            self.view.backgroundColor = UIColor( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
            }) { (finished) in
        }
        do {
            try self.setupVideo()
        }
        catch let error as NSError {
            print("error: \(error)")
        }
    }
    
    func endAnimation() {
        UIView.animateWithDuration(0.3, animations: { 
            self.view.backgroundColor = UIColor.clearColor()
            self.actionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, kzSCREEN_HEIGHT*0.6)
            }) { (finished) in
            self.closeView()
        }
    }
    func closeView() {
        self.view.removeFromSuperview()
        currentVC = nil
    }
    
    private func controllerSetup() {
        self.view.backgroundColor = UIColor.clearColor()
        self.setupSubViews()
        // 
        let cancelBtn = UIButton(type: .Custom)
        cancelBtn.titleLabel?.text = "cancel"
        cancelBtn.frame = CGRectMake(0, 0, 60, 60)
        cancelBtn.addTarget(self, action: #selector(KZVideoViewController.cancelDismiss), forControlEvents: .TouchUpInside)
        self.view.addSubview(cancelBtn)
    }
    
    deinit {
        print("videoViewController deinit")
    }
    
    // MARK: - satup Views
    private func setupSubViews() {
        self.actionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.actionView)
        
        let themeColor = kzThemeBlackColor
        
        let topHeight:CGFloat = 20.0
        let buttomHeight:CGFloat = 120.0
        
        let allHeight = actionView.frame.height
        let allWidth = actionView.frame.width
        
        
        self.topSlideView.frame = CGRectMake(0, 0, allWidth, topHeight)
        self.topSlideView.backgroundColor = themeColor
        self.actionView.addSubview(self.topSlideView)
        
        
        self.ctrlBar.frame = CGRectMake(0, allHeight - buttomHeight, allWidth, buttomHeight)
        self.ctrlBar.setupSubViews()
        self.ctrlBar.backgroundColor = themeColor
        self.ctrlBar.delegate = self
        self.actionView.addSubview(self.ctrlBar)
        
        
        self.videoView.frame = CGRectMake(0, CGRectGetMaxY(self.topSlideView.frame), allWidth, allHeight - topHeight - buttomHeight)
        self.actionView.addSubview(self.videoView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(KZVideoViewController.focusAction(_:)))
        self.videoView.addGestureRecognizer(tapGesture)
        
        self.focusView.backgroundColor = UIColor.clearColor()
        
        
        self.statusInfo.frame = CGRectMake(0, self.videoView.frame.maxY - 30, self.videoView.frame.width, 20)
        self.statusInfo.textAlignment = .Center
        self.statusInfo.font = UIFont.systemFontOfSize(14.0)
        self.statusInfo.textColor = UIColor.whiteColor()
        self.statusInfo.hidden = true
        self.actionView.addSubview(self.statusInfo)
        
        self.cancelInfo.frame = CGRectMake(0, 0, 120, 24)
        self.cancelInfo.center = self.videoView.center
        self.cancelInfo.textAlignment = .Center
        self.cancelInfo.textColor = kzThemeWhiteColor
        self.cancelInfo.backgroundColor = kzThemeWaringColor
        self.cancelInfo.hidden = true
        self.actionView.addSubview(self.cancelInfo)
        
    }
    // MARK: - setup Video
    private func setupVideo() throws {
        let devicesVideo = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        let devicesAudio = AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio)
        
        let videoInput = try AVCaptureDeviceInput(device: devicesVideo[0] as! AVCaptureDevice)
        let audioInput = try AVCaptureDeviceInput(device: devicesAudio[0] as! AVCaptureDevice)
        
        self.videoDevice = devicesVideo[0] as! AVCaptureDevice
        
        let moveOut = AVCaptureMovieFileOutput()
        self.moveOut = moveOut
        
//        self.videoDataOut = AVCaptureVideoDataOutput()
//        self.videoDataOut?.videoSettings = [kCVPixelBufferPixelFormatTypeKey:NSNumber(unsignedInt: kCVPixelFormatType_32BGRA)]
//        self.videoDataOut?.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
//        self.videoWriter = AVAssetWriter()
        
        let session = AVCaptureSession()
        if session.canSetSessionPreset(AVCaptureSessionPreset352x288) {
            session.canSetSessionPreset(AVCaptureSessionPreset352x288)
        }
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        if session.canAddInput(audioInput) {
            session.addInput(audioInput)
        }
        if session.canAddOutput(moveOut) {
            session.addOutput(moveOut)
        }
//        if session.canAddOutput(self.videoDataOut) {
//            session.addOutput(self.videoDataOut)
//        }
        self.videoSession = session
        
        self.videoPreLayer = AVCaptureVideoPreviewLayer(session: session)
        self.videoPreLayer.frame = self.videoView.bounds
        self.videoPreLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoView.layer.addSublayer(self.videoPreLayer)
        
        session.startRunning()
    }
    
    
    // MARK: - Actions
    // 聚焦
    func focusAction(sender:UITapGestureRecognizer) {
        let point = sender.locationInView(self.videoView)
        self.focusView.center = point
        self.videoView.addSubview(self.focusView)
        self.videoView.bringSubviewToFront(self.focusView)
        
        if self.videoDevice.accessibilityElementIsFocused() && self.videoDevice.isFocusModeSupported(.AutoFocus) {
            do {
                try self.videoDevice.lockForConfiguration()
                self.videoDevice.focusMode = .AutoFocus
                self.videoDevice.focusPointOfInterest = point
                self.videoDevice.unlockForConfiguration()
            }
            catch let error as NSError {
                print("error: \(error)")
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.focusView.removeFromSuperview()
        }
    }
    
    func cancelDismiss() {
        self.videoSession.stopRunning()
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.endAnimation()
    }
    
    //MARK: - controllerBarDelegate
    
    func videoDidStart(controllerBar: KZControllerBar!) {
        print("视频录制开始了")
        self.currentRecord = KZVideoUtil.createNewVideo()
        self.currentRecordIsCancel = false
        let outUrl = NSURL(fileURLWithPath: self.currentRecord!.totalVideoPath)
        self.moveOut?.startRecordingToOutputFileURL(outUrl, recordingDelegate: self)
        
//        self.videoDataOut.
        self.topSlideView.isRecoding = true
        
        self.statusInfo.textColor = kzThemeTineColor
        self.statusInfo.text = "↑上移取消"
        self.statusInfo.hidden = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.statusInfo.hidden = true
        })
    }
    
    func videoDidEnd(controllerBar: KZControllerBar!) {
        print("视频录制结束了")
        self.moveOut?.stopRecording()
        self.topSlideView.isRecoding = false
        
//        self.delegate?.videoViewController!(self, didRecordVideo: self.currentRecord!)
//        self.endAnimation()
    }
    
    func videoDidCancel(controllerBar: KZControllerBar!) {
        print("视频录制已经取消了")
        self.moveOut?.stopRecording()
        self.currentRecordIsCancel = true
        self.delegate?.videoViewControllerDidCancel!(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            KZVideoUtil.deletefile(self.currentRecord!.totalVideoPath)
        })
    }
    
    func videoWillCancel(controllerBar: KZControllerBar!) {
        print("视频录制将要取消")
        if !self.cancelInfo.hidden {
            return
        }
        self.cancelInfo.text = "松手取消"
        self.cancelInfo.hidden = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.cancelInfo.hidden = true
        })
    }
    
    func videoDidRecordSEC(controllerBar: KZControllerBar!) {
        print("视频录制又过了一秒")
        self.topSlideView.isRecoding = true
    }
    
    func videoDidClose(controllerBar: KZControllerBar!) {
        print("关闭界面")
        self.cancelDismiss()
    }
    
    func videoOpenVideoList(controllerBar: KZControllerBar!) {
        print("查看视频列表")
        let listVideoVC = KZVideoListViewController()
        listVideoVC.selectBlock = { (listVC, selectVideo) in
            self.currentRecord = selectVideo
            self.delegate?.videoViewController!(self, didRecordVideo: selectVideo)
            self.closeView()
        }
        listVideoVC.showAniamtion()
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate -
    public func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print("视频已经开始录制......")
    }
    
    public func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        print("视频完成录制......")
        if !currentRecordIsCancel {
            KZVideoUtil.saveThumImage(outputFileURL, second: 1)
            self.delegate?.videoViewController!(self, didRecordVideo: self.currentRecord!)
            self.endAnimation()
        }
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
        let len = CVPixelBufferGetDataSize(pixelBuffer)
        
        let pixel = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let pxPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        
        
        var newPixelBuffer: CVPixelBuffer? = nil
        
        let newWidth = 480
        let newHeight = 480*height/width
        let options = [kCVPixelBufferCGImageCompatibilityKey as String:NSNumber(bool:true), kCVPixelBufferCGBitmapContextCompatibilityKey as String:NSNumber(bool:true)]
        let status = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, newWidth, newHeight, kCVPixelFormatType_32BGRA, pixel, pxPerRow, nil, nil, options, &newPixelBuffer)
        
        let description = CMSampleBufferGetFormatDescription(sampleBuffer)
        var newBuffer:CMSampleBuffer? = nil
        
        if status == kCVReturnSuccess {
            CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, newPixelBuffer!, true, nil, nil, description!, nil, &newBuffer)
        }

        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        print("width : \(width)\theight : \(height)\nlen : \(len)80")
    }
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didDropSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
    }
    
    /*
    // MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = KZTransitionManager()
        transition.transitionType = .Present
        return transition
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = KZTransitionManager()
        transition.transitionType = .Dismiss
        return transition
    }
     */
}
