//
//  ViewController.swift
//  DrawBarChart
//
//  Created by YuriyFpc on 12/4/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = DrawBarChart()
        v.delegate = self
        view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        v.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        v.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        v.heightAnchor.constraint(equalToConstant: 300).isActive = true
        v.setNeedsLayout()
    }
    
}

extension ViewController: BarChartDelegate {
    
    func space() -> CGFloat {
        return 2.0
    }
}

