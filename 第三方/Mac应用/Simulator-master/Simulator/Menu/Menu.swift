import Cocoa

struct Menu {

  static func load(_ devices: [Device]) -> [NSMenuItem] {
    var items: [NSMenuItem] = []

    var osInfo: String = ""

    devices.forEach {
      if $0.osInfo != osInfo {
        osInfo = $0.osInfo
        
        if !items.isEmpty {
          items.append(NSMenuItem.separator())
        }
        items.append(Menu.header($0.osInfo))
      }

      items.append(load($0))
    }

    return items
  }

  static func load(_ device: Device) -> NSMenuItem {
    let item = NSMenuItem()
    item.title = device.name
    item.isEnabled = device.isAvailable
    item.state = device.isOpen ? 1 : 0
    item.onStateImage = NSImage(named: "on")
    item.offStateImage = NSImage(named: "off")

    let menu = NSMenu()
    menu.autoenablesItems = false

    let applications = load(device.applications)
    if !applications.isEmpty {
      menu.addItem(NSMenuItem.separator())
      menu.addItem(Menu.header("Applications"))
      applications.forEach {
        menu.addItem($0)
      }
    }

    let appGroups = load(device.appGroups)
    if !appGroups.isEmpty {
      menu.addItem(NSMenuItem.separator())
      menu.addItem(Menu.header("App Groups"))
      appGroups.forEach {
        menu.addItem($0)
      }
    }

    let media = load(device.media)
    if !media.isEmpty {
      menu.addItem(NSMenuItem.separator())
      menu.addItem(Menu.header("Media"))
      media.forEach {
        menu.addItem($0)
      }
    }

    item.submenu = menu
    return item
  }

  private static func load(_ applications: [Application]) -> [NSMenuItem] {
    return applications.map {
      let item = NSMenuItem()
      item.title = $0.name
      item.isEnabled = true
      item.target = $0
      item.action = #selector(Application.handleMenuItem(_:))

      return item
    }
  }

  private static func load(_ appGroups: [AppGroup]) -> [NSMenuItem] {
    return appGroups.map {
      let item = NSMenuItem()
      item.title = $0.bundleIdentifier
      item.isEnabled = true
      item.target = $0
      item.action = #selector(AppGroup.handleMenuItem(_:))

      return item
    }
  }

  private static func load(_ media: [Media]) -> [NSMenuItem] {
    return media.map {
      let item = NSMenuItem()
      item.title = $0.name
      item.isEnabled = true
      item.target = $0
      item.action = #selector(Media.handleMenuItem(_:))

      return item
    }
  }

  // MARK: - Helper

  private static func header(_ title: String) -> NSMenuItem {
    let item = NSMenuItem()
    item.title = title
    item.isEnabled = false

    return item
  }
}
