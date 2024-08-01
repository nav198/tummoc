//
//  ViewController.swift
//  tummoc
//
//  Created by nav on 24/07/24.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = DashBoardViewController()
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
            vc.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }

}

