import Cocoa

class AppGroup: NSObject {

  var bundleIdentifier: String = ""
  var location: URL?

  // MARK: - Load

  static func load(_ path: URL) -> [AppGroup] {
    let directory = path.appendingPathComponent("/data/Containers/Shared/AppGroup")
    return File.directories(directory)
    .map {
      let appGroup = AppGroup()
      appGroup.location = directory.appendingPathComponent($0)

      let plistPath = appGroup.location!.appendingPathComponent("/.com.apple.mobile_container_manager.metadata.plist")
      let json = NSDictionary(contentsOf: plistPath)

      appGroup.bundleIdentifier = json?.string("MCMMetadataIdentifier") ?? ""

      return appGroup
    }.filter {
      return !$0.bundleIdentifier.contains("com.apple")
    }
  }

  func handleMenuItem(_ item: NSMenuItem) {
    guard let location = location else { return }
    NSWorkspace.shared().open(location)
  }
}
