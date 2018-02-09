import Foundation

extension URL {

  var removeTrailingSlash: URL {
    guard absoluteString.hasSuffix("/") else { return self }

    let string = absoluteString.substring(to: absoluteString.characters.index(before: absoluteString.endIndex))
    return URL(string: string)!
  }
}
