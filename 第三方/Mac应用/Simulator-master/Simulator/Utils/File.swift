import Cocoa

struct File {

  static func directories(_ path: URL) -> [String] {
    let results = try? FileManager.default
      .contentsOfDirectory(atPath: path.path)
      .filter {
        return isDirectory(path.appendingPathComponent("\($0)").path, name: $0)
      }

    return results ?? []
  }

  static func isDirectory(_ path: String, name: String) -> Bool {
    var flag = ObjCBool(false)
    FileManager.default.fileExists(atPath: path, isDirectory: &flag)

    return flag.boolValue && !name.hasPrefix(".")
  }
}
