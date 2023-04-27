//
//  ViewController.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/26/23.
//

import UIKit

class ViewController: UIViewController {
    var netBit = NetworkClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        netBit.doRequest()
       
    }


}

