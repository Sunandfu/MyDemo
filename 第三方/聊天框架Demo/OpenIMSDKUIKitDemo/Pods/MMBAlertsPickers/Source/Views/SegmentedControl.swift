import UIKit

final public class SegmentedControl: UISegmentedControl {
    
    public typealias Action = (Int) -> Swift.Void
    
    internal var action: Action?
    
    public func action(new: Action?) {
        if action == nil {
            addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        }
        action = new
    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        action?(segment.selectedSegmentIndex)
    }
}
