# CathayBankTaipei

- 專案架構為 MVVM
- 不使用 套件
- UI 以 code 製作

## TabBar
>客製化 MainTabBarController\
以 enum TabBarTab ，來建立 Tab
```swift
 enum TabBarTab: Int, CaseIterable {
        case products = 0
        case friends
        case home
        case manage
        case setting
    }
```
TODO: 
- zeplin 內缺少部分 selectedImage，先以 tintColor 來替代。
- 僅有實作 FriendsViewController 朋友頁，其他都是空白的。

## FriendsViewController

- UI 設計大致區分幾個區塊

> - User Data View\
主要為 user 的資料、id、imageView 都在這
> - New Friends stackView
> - - 新增好友：預期呈現縮合隱藏的效果
> - - segmentedControl: 以客製化方向，製作


