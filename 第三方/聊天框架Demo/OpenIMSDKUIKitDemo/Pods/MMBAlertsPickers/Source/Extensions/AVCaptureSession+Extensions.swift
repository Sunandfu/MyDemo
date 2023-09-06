import Foundation
import AVFoundation

internal extension AVCaptureSession {
    
    @discardableResult func setPresetsAlertnately(_ presets: [Preset]) -> Bool {
        for preset in presets {
            if canSetSessionPreset(preset) {
                sessionPreset = preset
                return true
            }
        }
        return false
    }
    
}
