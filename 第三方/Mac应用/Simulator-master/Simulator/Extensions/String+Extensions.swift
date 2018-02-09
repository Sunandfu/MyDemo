import Cocoa

extension String {

  func remove(_ string: String) -> String {
    return replacingOccurrences(of: string, with: "")
  }
}
