# ViSearch Swift Widgets SDK
![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)

---

## 1. Overview

ViSearch is an API that provides accurate, reliable and scalable image search. ViSearch API provides two services (Data API and Search API) to let the developers prepare image database and perform image searches efficiently. ViSearch API can be easily integrated into your web and mobile applications. For more details, see [ViSearch Documentation](http://developers.visenze.com/).

The ViSearch Swift Widgets SDK is an open source software to provide easy integration of ViSearch Search API with your iOS applications.

>Current stable version: <In development>

>Supported iOS version: iOS 8.x and higher

## 2. Setup

### 2.1 Run the Demo

### 2.2 Set up Xcode project

### 2.3 Import ViSearch Swift Widgets SDK

#### 2.3.1 Using CocoaPods

First you need to install the CocoaPods Ruby gem:

```
# Xcode 7 + 8
sudo gem install cocoapods --pre
```

Then go to your project directory to create an empty Podfile

```
cd /path/to/Demo
pod init
```

Edit the Podfile as follow:

```
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ViSearchWidgets', '~>1.0'
end
...
```

Install the ViSearch SDK:

```
pod install
```

The Demo.xcworkspace project should be created.

#### 2.3.2 Using Carthage

* [TODO] Add framework search path

#### 2.3.3 Using Manual Approach

### 2.4 Add Privacy Usage Description

iOS 10 now requires user permission to access camera and photo library. If your app requires these access, please add description for NSCameraUsageDescription, NSPhotoLibraryUsageDescription in the Info.plist. More details can be found [here](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW24).

## 3. Initialization

## 4. Solutions





