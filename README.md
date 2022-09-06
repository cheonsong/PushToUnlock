# PushToUnlock

[![CI Status](https://img.shields.io/travis/cheonsong/PushToUnlock.svg?style=flat)](https://travis-ci.org/cheonsong/PushToUnlock)
[![Version](https://img.shields.io/cocoapods/v/PushToUnlock.svg?style=flat)](https://cocoapods.org/pods/PushToUnlock)
[![License](https://img.shields.io/cocoapods/l/PushToUnlock.svg?style=flat)](https://cocoapods.org/pods/PushToUnlock)
[![Platform](https://img.shields.io/cocoapods/p/PushToUnlock.svg?style=flat)](https://cocoapods.org/pods/PushToUnlock)   
![ezgif com-gif-maker-3](https://user-images.githubusercontent.com/59193640/188588004-c98f8a5c-50f0-4d68-add4-09d06807d22a.gif)
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

  - iOS 9.0+
  - Swift 5.0
  
## Installation

PushToUnlock is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PushToUnlock'
```

## Get Started
### Set Component
We offer five properties that allow customization
```Swift
let button = PushToUnlock(width: 200, height: 50)
button.text       = "Push To Unlock"        // Default: ""
button.textColor  = .white                  // Default: White
button.textFont   = .systemFont(ofSize: 15) // Default: SystemFont(18)
button.background = .black                  // Default: Gray
button.tint       = .white                  // Default: Red
```

### Set Constraints
You don't have to worry about the size. Just the location, please
```Swift
view.addSubview(button)
button.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.init(item: button,
                        attribute: .centerX,
                        relatedBy: .equal,
                        toItem: self.view,
                        attribute: .centerX,
                        multiplier: 1.0,
                        constant: 0).isActive = true
NSLayoutConstraint.init(item: button,
                        attribute: .centerY,
                        relatedBy: .equal,
                        toItem: self.view,
                        attribute: .centerY,
                        multiplier: 1.0,
                        constant: 0).isActive = true
```

### Event Handler
There are two ways to handle an event. Rx and Closure
```Swift 
// Rx
button.isSuccess
    .subscribe(onNext: {
        print("Rx Success")
        // add code...
    })
    .disposed(by: disposeBag)
    
// Closure
button.completion = {
    print("Closure Success")
    // add code...
}
```

## Properties

| Property                                                | Explanation                                          | Default Value      |
| ------------------------------------------- | ------------------------------------------ | :-----------------: |
```text      : String``` | Text Property | "" |
```textColor : UIColor``` | TextColor Property | UIColor.white |
```textFont  : UIFont``` | TextFont Property | UIFont.systemFont.(of:18) |
```background: UIColor``` | Backgound Color | UIColor.gray |
```tint      : UIColor``` | Swipe Button Color | UIColor.red |

## Author

cheonsong, qkrcjsthd@gmail.com

## License

PushToUnlock is available under the MIT license. See the LICENSE file for more info.
