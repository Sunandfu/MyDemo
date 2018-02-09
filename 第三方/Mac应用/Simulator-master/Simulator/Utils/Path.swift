import Cocoa

struct Path {

  static var library: URL {
    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
    return URL(fileURLWithPath: path)
  }

  static var devices: URL {
    return library.appendingPathComponent("Developer/CoreSimulator/Devices")
  }
}
