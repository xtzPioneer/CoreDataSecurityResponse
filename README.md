# CoreDataSecurityResponse
> 保证应用不因 Core Data 的原因导致意外崩溃是对开发者的起码要求。本文将介绍可能在视图中产生严重错误的原因，如何避免，以及在保证视图对数据变化实时响应的前提下如何为使用者提供更好、更准确的信息。由于本文会涉及大量前文中介绍的技巧和方法，因此最好一并阅读。  
> ——[【肘子的Swift笔记：SwiftUI 与 Core Data —— 安全地响应数据】](https://www.fatbobman.com/posts/modern-Core-Data-Respond-Data-safely/)
## 要求
- macOS 13.0
- Xcode 14.0
- swift 5.7
## 支持的平台
- iOS 16.0
- tvOS 16.0
- watchOS 9.0
- macOS 13.0
- macCatalyst 16.0
## Swift Package Manager 安装
[Swift 包管理器](https://swift.org/package-manager/) 是一个用于自动分发 Swift 代码的工具，并集成到 `swift` 编译器中。

设置好 Swift 包后，添加 CoreDataSecurityResponse 作为依赖项就像将其添加到 `Package.swift` 的 `dependencies` 值中一样简单。

```swift
dependencies: [
    .package(url: "https://github.com/xtzPioneer/CoreDataSecurityResponse.git", .upToNextMajor(from: "0.1.0")),
]
```
## 演示
[CoreDataSecurityResponse Demo](https://github.com/fatbobman/Todo)

## 特别感谢
[【@东坡肘子】](https://github.com/fatbobman)  
[【肘子的Swift笔记】](https://www.fatbobman.com)  
[【肘子的Swift笔记：SwiftUI 与 Core Data —— 安全地响应数据】](https://www.fatbobman.com/posts/modern-Core-Data-Respond-Data-safely/)  
[【Todo Demo】](https://github.com/fatbobman/Todo)  
## 许可证

CoreDataSecurityResponse 是根据麻省理工学院许可证发布的。[见许可证](https://github.com/xtzPioneer/CoreDataSecurityResponse/blob/main/LICENSE)有关详细信息。