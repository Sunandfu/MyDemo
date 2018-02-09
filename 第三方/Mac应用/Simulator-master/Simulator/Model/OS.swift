import Cocoa

enum OS: String {
  case tvOS = "tvOS"
  case iOS = "iOS"
  case watchOS = "watchOS"
  case unknown = "unknown"

  var order: Int {
    switch self {
    case .iOS:
      return 0
    case .tvOS:
      return 1
    case .watchOS:
      return 2
    default:
      return 3
    }
  }
}
