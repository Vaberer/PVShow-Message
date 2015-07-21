# PVShow Message
![Font Awesome Swift](https://github.com/Vaberer/Font-Awesome-Swift/blob/master/resources/opensource_matters.png)

Follow me: [@vaberer](https://twitter.com/vaberer)

I like &#9733;. Do not forget to &#9733; this super convenient library.

Simple library to show custom messages with a touch event. Fully customizable via properties. If any message is currently showing and you want to show another message, it will wait until a previous message will dismiss.


Works perfectly in **portrait**, **landscape** mode and with **constraints**.



<p align="center">
  <img height="480" src="https://github.com/Vaberer/PVShow-Message/blob/master/resources/pvshow_message.gif"/>
</p>

## Requirements

- iOS 8.0+ 
- Xcode 6.3

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate PVShow Message into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'PVShow-Message', '~> 1.0.0'
```

Then, run the following command:

```bash
$ pod install
```
Do not forget to import to your swift files where you want to use this library:
```swift
import PVShow_Message
```

### Manually

1. Copy `PVShowMessage.swift` file into your project


## Usage


### Show Message

```Swift
    PVShowMessage.instance.showMessage(text: "All data has been updated\nYou have fresh data")
```

### Customize your message view via these properties
```Swift
        PVShowMessage.cBackgroundColor = UIColor.blackColor()
        PVShowMessage.cBorderColor = UIColor.lightGrayColor()
        PVShowMessage.cBorderWidth = 3
        PVShowMessage.cCornerRadius = 0
        PVShowMessage.cFontName = "HelveticeNeue-Light"
        PVShowMessage.cFontSize = 40
        PVShowMessage.cTextColor = UIColor.lightTextColor()
        PVShowMessage.cPositionFromEdge = 200
        PVShowMessage.cExtraShowTimeForMessage = 3
        PVShowMessage.cInitialPosition = .Top
        PVShowMessage.cAnimationDuration = 1.5
```



### Touch event via Delegation

You can attach any identifier to the message view and it will be returned to you via a delegate method
```Swift
    PVShowMessage.instance.showMessage(text: "My Text", identifier: 10)
```

Tell a message view who is delegate in a `viewWillAppear` method

```Swift
override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PVShowMessage.instance.delegate = self
    }
```


Implement `PVShowMessageDelegate`

```Swift
    func didTapToMessage(identifier: AnyObject?) {
        
        println("Tapped to a message with identifier: \(identifier)")
    }
```


### Removing messages froma a queue

All messages which are going to be shown will be removed from a queue
```Swift
    PVShowMessage.instance.removeAllMessages()
```


## Author

Patrik Vaberer, patrik.vaberer@gmail.com<br/>
<a target="_blank" href="https://sk.linkedin.com/in/vaberer">LinkedIn</a><br>
<a target="_blank" href="http://vaberer.me">Blog</a>


### Licence

PVShow Message is available under the MIT license. See the LICENSE file for more info.

