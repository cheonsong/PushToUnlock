//
//  ViewController.swift
//  PushToUnlock
//
//  Created by cheonsong on 09/01/2022.
//  Copyright (c) 2022 cheonsong. All rights reserved.
//

import UIKit
import PushToUnlock
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Component
        // We offer five properties that allow customization
        let button = PushToUnlock(width: 200, height: 50)
        button.text       = "Push To Unlock"        // Default: ""
        button.textColor  = .white                  // Default: White
        button.textFont   = .systemFont(ofSize: 15) // Default: SystemFont(18)
        button.background = .black                  // Default: Gray
        button.tint       = .white                  // Default: Red
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Set Constraints
        // You don't have to worry about the size. Just the location, please
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
        
        // Event Handling
        // There are two ways to process an event. Rx and Closure
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

