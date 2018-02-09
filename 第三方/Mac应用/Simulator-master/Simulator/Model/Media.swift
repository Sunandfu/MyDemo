import Cocoa

class Media: NSObject {

  var name: String = ""
  var location: URL?

  // MARK: - Load

  static func load(_ path: URL) -> [Media] {
    let directory = path.appendingPathComponent("/data/Media/DCIM")

    return File.directories(directory)
    .map {
      let media = Media()
      media.name = $0
      media.location = directory.appendingPathComponent($0)

      return media
    }
  }

  func handleMenuItem(_ item: NSMenuItem) {
    guard let location = location else { return }
    NSWorkspace.shared().open(location)
  }
}
