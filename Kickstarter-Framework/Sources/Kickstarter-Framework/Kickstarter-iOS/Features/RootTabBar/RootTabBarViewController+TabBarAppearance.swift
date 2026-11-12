import AlamofireImage
import KDS
import Library
import Prelude
import UIKit

extension RootTabBarViewController {
  private func configureFloatingTabBarItems(with data: TabBarItemsData) {
    guard let items = self.tabBar.items, items.isEmpty == false else { return }

    data.items.forEach { item in
      switch item {
      case let .home(index):
        self.setFloatingTabBarIcon(imageName: "floating-tabbar-icon-home", at: index)

      case let .search(index):
        self.setFloatingTabBarIcon(imageName: "floating-tabbar-icon-search", at: index)

      case let .profile(_, index):
        /// Only override profile icon if logged out
        guard data.isLoggedIn == false else { break }

        self.setFloatingTabBarIcon(imageName: "floating-tabbar-icon-profile", at: index)

      case .activity:
        break
      }
    }

    /// Remove labels + center icons
    items.forEach {
      $0.title = nil
      $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
  }

  private func setFloatingTabBarIcon(imageName name: String, at index: Int) {
    guard let item = self.tabBarItem(atIndex: index),
          let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) else { return }

    item.image = image
    item.selectedImage = image
  }

  func setTabBarItemStyles(withData data: TabBarItemsData) {
    self.lastTabBarItemsData = data
    data.items.forEach { item in
      switch item {
      case let .home(index):
        _ = self.tabBarItem(atIndex: index) ?|> homeTabBarItemStyle
      case let .activity(index):
        _ = self.tabBarItem(atIndex: index) ?|> activityTabBarItemStyle
      case let .search(index):
        _ = self.tabBarItem(atIndex: index) ?|> searchTabBarItemStyle
      case let .profile(avatarUrl, index):
        _ = self.tabBarItem(atIndex: index)
          ?|> profileTabBarItemStyle(isLoggedIn: data.isLoggedIn)

        self.setProfileImage(with: data, avatarUrl: avatarUrl, index: index)
      }
    }

    if self.isFloatingTabBarEnabled {
      /// Run last so it overwrites the default tab-bar icons/titles
      self.configureFloatingTabBarItems(with: data)
    }
  }

  func setProfileImage(with data: TabBarItemsData, avatarUrl: URL?, index: Int) {
    guard
      data.isLoggedIn == true,
      let avatarUrl = avatarUrl,
      let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    else { return }

    let hash = avatarUrl.absoluteString.hashValue
    let imagePath = "\(dir)/tabbar-avatar-image-\(hash).dat"
    let imageUrl = URL(fileURLWithPath: imagePath)

    if let imageData = try? Data(contentsOf: imageUrl) {
      let (defaultImage, selectedImage) = tabbarAvatarImageFromData(
        imageData,
        isFloatingTabBarEnabled: self.isFloatingTabBarEnabled
      )

      _ = self.tabBarItem(atIndex: index)
        ?|> profileTabBarItemStyle(isLoggedIn: true)
        ?|> UITabBarItem.lens.image .~ defaultImage
        ?|> UITabBarItem.lens.selectedImage .~ selectedImage
    } else {
      let sessionConfig = URLSessionConfiguration.default
      let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: .main)
      let dataTask = session.dataTask(with: avatarUrl) { [weak self] avatarData, _, _ in
        guard let self = self, let avatarData = avatarData else { return }
        try? avatarData.write(to: imageUrl, options: [.atomic])

        let (defaultImage, selectedImage) = tabbarAvatarImageFromData(
          avatarData,
          isFloatingTabBarEnabled: self.isFloatingTabBarEnabled
        )
        _ = self.tabBarItem(atIndex: index)
          ?|> profileTabBarItemStyle(isLoggedIn: true)
          ?|> UITabBarItem.lens.image .~ defaultImage
          ?|> UITabBarItem.lens.selectedImage .~ selectedImage
      }
      dataTask.resume()
    }
  }

  func isTabBarItemLastItem(for index: Int) -> Bool {
    guard let tabBarItemEndIndex = self.tabBar.items?.endIndex else {
      return false
    }

    return tabBarItemEndIndex - 1 == index
  }

  func tabBarItem(atIndex index: Int) -> UITabBarItem? {
    if (self.tabBar.items?.count ?? 0) > index {
      if let item = self.tabBar.items?[index] {
        return item
      }
    }
    return nil
  }

  func applyFloatingTabBar(enabled: Bool) {
    guard self.isFloatingTabBarEnabled != enabled else { return }

    self.isFloatingTabBarEnabled = enabled

    if enabled {
      guard (self.tabBar is FloatingTabBar) == false else { return }

      /// Replace the UITabBarController’s tab bar with our custom subclass.
      /// UITabBarController has a read-only tabBar property and Apple doesn't provide a public setter or override for it so we need to do it via key-value coding.
      let customTabBar = FloatingTabBar()
      self.setValue(customTabBar, forKey: "tabBar")
      self.bindStyles()
    } else {
      guard let standardTabBar = self.standardTabBar, self.tabBar is FloatingTabBar else { return }

      self.setValue(standardTabBar, forKey: "tabBar")
      self.bindStyles()
    }
  }
}

private func tabbarAvatarImageFromData(
  _ data: Data,
  isFloatingTabBarEnabled: Bool
) -> (defaultImage: UIImage?, selectedImage: UIImage?) {
  let avatar = UIImage(data: data, scale: UIScreen.main.scale)?
    .af.imageRoundedIntoCircle()
    .af.imageAspectScaled(toFit: tabBarAvatarSize)
  avatar?.af.inflate()

  let deselectedImage = strokedRoundImage(
    fromImage: avatar,
    size: tabBarAvatarSize,
    color: isFloatingTabBarEnabled ? .clear : tabBarDeselectedColor
  )
  let selectedImage = strokedRoundImage(
    fromImage: avatar,
    size: tabBarAvatarSize,
    color: isFloatingTabBarEnabled ? Colors.FloatingTabBar.profileIconBorderColor
      .uiColor() : tabBarSelectedColor,
    lineWidth: 2.0
  )

  return (defaultImage: deselectedImage, selectedImage: selectedImage)
}

private func strokedRoundImage(
  fromImage image: UIImage?,
  size: CGSize,
  color: UIColor,
  lineWidth: CGFloat = 2.0
) -> UIImage? {
  UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
  defer { UIGraphicsEndImageContext() }

  let innerRect = CGRect(x: 1.0, y: 1.0, width: size.width - 2.0, height: size.height - 2.0)
  image?.draw(in: innerRect)
  let circle = UIBezierPath(ovalIn: innerRect)
  color.setStroke()
  circle.lineWidth = lineWidth
  circle.stroke()

  return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
}

