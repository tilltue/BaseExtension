//
//  ViewController.swift
//  BaseExtension
//
//  Created by wade.hawk on 10/09/2017.
//  Copyright (c) 2017 wade.hawk. All rights reserved.
//

import UIKit
import BaseExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let test = Date()
        print(test.dateString())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

}

