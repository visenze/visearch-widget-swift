# ViSearch Swift Widgets SDK
![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)&nbsp;[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;[![CocoaPods](https://img.shields.io/cocoapods/v/ViSearchWidgets.svg)](https://github.com/visenze/visearch-widget-swift)
---

## 1. Overview

Search and monetize your product images with our effective, easy-to-use, and customizable SDK widgets.

We have launched four solutions that would be fit into your various use cases.

- **Find Similar**: Automatically find visually similar items from your inventory with a simple click 
- **You May Also Like**: Recommend products customers may like using visual recognition and custom rules
- **Search by Image**: Search for matching or similar items from your database with built-­in automated object recognition 
- **Search by Color**: Search and discover products by selecting from a vast color spectrum

## 2. Requirements

- iOS 8.0+ 
- Xcode 8.1+
- Swift 3.0+

## 3. Setup

### 3.1 Setup your ViSenze account
In order to use our widgets, please setup your ViSenze account. Please refer to our developer documentation for [set-up instructions](http://developers.visenze.com/setup/#Set-up-your-ViSenze-account).

To use the mobile widgets, you will need to get the API keys (access & secret key) with `search-only` permission. 

### 3.2 Upload your datafeed

For testing, you will need to upload your datafeed in ViSenze [dashboard](https://dashboard.visenze.com/) and [configure schema fields](http://developers.visenze.com/setup/#Configure-schema-fields) . For widgets integration, the schema fields requirements are as below:

|Meta-data|Schema | Type | Required | Searchable| Description | Example|
|---------|-------|------|-----------|-----------|-------------|--------|
|Image Id|im_name|string|Yes|Yes|Unique identifier for the image. Generated automatically in ViSenze dashboard.|red-polka-dress.jpg, 2720f503-a0d9-4516-8803-19052fbf343c |
|Image URL|im_url|string|Yes|No|URL for product image. Generated automatically in ViSenze dashboard.|http://somesite.com/abc.jpg|
|Mobile Image URL| custom | string | No | No | Mobile friendly image url for faster loading in mobile app. If this is not provided, im_url will be used to display product image| http://somesite.com/small-img.png|
|Title|custom| string | Yes | Optional | Product title which will appear below product image | Black dress |
|Description|custom| text | No | Optional | Product description which may appear in product detail page  | Black dress |
|Brand| custom | string | No | Yes | Optional field for displaying in the product card. Can be used for filtering. | Nike, Adidas |
|Category| custom | string | No | Yes | Product category. Can be used for filtering. | Dress, Top, Eyewear, Watch , etc|
|Price| custom | float/int | Yes | Yes | Product original retail price. Can be used for ranged filtering | 49.99 |
| Discount Price | custom | float/int | No | Yes | Discount product price. Can be used for ranged filtering | 40.99 |   
   
## 4. Installation

### 4.1 CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build ViSearchWidgets.

Go to your Xcode project directory to create an empty Podfile:

```
pod init
```

To integrate ViSearchWidgets into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ViSearchWidgets', '~> 0.1'
end
```
You should change version 0.1 to the latest version of ViSearchWidgets. The version numbers can be viewed under the current Github project tags.

Then, run the following command:

```bash
$ pod install
```

### 4.2 Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

Alternately, you can download and run the `Carthage.pkg` file for the latest [release](https://github.com/Carthage/Carthage/releases). 

To integrate ViSearchWidgets into your Xcode project using Carthage:

1. Create a `Cartfile` :

 ```ogdl
 github "visenze/visearch-widget-swift" ~> 0.1
 ```
 You should change version 0.1 to the latest version of ViSearchWidgets. The version numbers can be viewed under the current Github project tags.

2. Run `carthage update --platform iOS --no-use-binaries`. 

 This will fetch dependencies into Carthage/Checkouts folder, then build the framework. 

3. Drag the built `ViSearchWidgets.framework` into your Xcode project.

 * [TODO] Add framework search path


### 4.3 App Permission

- **Add Privacy Usage Description** :

 iOS 10 now requires user permission to access camera and photo library. If your app requires these access, please add description for NSCameraUsageDescription, NSPhotoLibraryUsageDescription in the Info.plist. More details can be found [here](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW24).







