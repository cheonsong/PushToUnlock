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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set UI
        let button = PushToUnlock(width: 200, height: 50)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Set Constraints
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
        
        // Binding
        let disposeBag = DisposeBag()
        
        button.isSuccess
            .bind(onNext: {
                print("Success")
                // add code...
            })
            .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

