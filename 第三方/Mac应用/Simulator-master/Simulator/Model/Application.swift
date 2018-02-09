import Cocoa

class Application: NSObject {

  var name: String = ""
  var icon: NSImage?
  var bundleIdentifier: String = ""
  var udid: String = ""
  var path: URL?

  lazy var location: URL? = self.loadDataLocation()

  // MARK: - Load

  static func load(_ path: URL) -> [Application] {
    let directory = path.appendingPathComponent("data/Containers/Bundle/Application")
    return File.directories(directory)
    .map {
      let application = Application()
      application.path = path
      application.loadInfo(directory.appendingPathComponent($0))

      return application
    }
  }

  // Can also use xcrun simctl get_app_container
  func loadInfo(_ bundleLocation: URL) {
    guard let app = File.directories(bundleLocation).first,
      let json = NSDictionary(contentsOf: bundleLocation.appendingPathComponent("\(app)/Info.plist"))
    else { return }

    name = json.string("CFBundleName") 
    bundleIdentifier = json.string("CFBundleIdentifier") 
  }

  func loadDataLocation() -> URL? {
    guard let path = path else { return nil }
    let directory = path.appendingPathComponent("data/Containers/Data/Application")

    let plist = ".com.apple.mobile_container_manager.metadata.plist"
    for udid in File.directories(directory) {
      let dataPath = directory.appendingPathComponent(udid)
      let plistPath = dataPath.appendingPathComponent(plist)
      guard let json = NSDictionary(contentsOf: plistPath)
        else { continue }

      let metaDataIdentifier = json.string("MCMMetadataIdentifier")
      guard metaDataIdentifier == bundleIdentifier else { continue }

      return dataPath
    }


    return nil
  }

  func handleMenuItem(_ item: NSMenuItem) {
    guard let location = location else { return }
    NSWorkspace.shared().open(location)
  }
}
