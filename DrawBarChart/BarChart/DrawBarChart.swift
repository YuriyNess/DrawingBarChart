//
//  DrawBarChart.swift
//  DrawBarChart
//
//  Created by YuriyFpc on 12/5/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

class DrawBarChart: UIView {
    
    private let chartLayer: BarChartLayer// = BarChartLayer()
    
    weak var delegate: BarChartDelegate? {
        didSet {
            chartLayer.appearanceDelegate = delegate
        }
    }
    
    override init(frame: CGRect) {
        chartLayer = BarChartLayer()
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartLayer.frame = self.bounds
        chartLayer.setNeedsDisplay()
    }
    
    func setChartEnteties(_ enteties: [BarEntity]) {
        chartLayer.enteties = enteties
    }
    
    private func setup() {
        layer.addSublayer(chartLayer)        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc
    private func handleTap() {
        if !chartLayer.isAnimating {
            chartLayer.enteties = createBunchOfEnteties()
        }
    }
    
    private func randColor() -> UIColor {
        switch Int.random(in: 0...4) {
        case 0:
            return .blue
        case 1:
            return .red
        case 2:
            return .green
        case 3:
            return .brown
        case 4:
            return .orange
        default:
            return .gray
        }
    }
    
    private func createBunchOfEnteties() -> [BarEntity] {
        return (0...Int.random(in: 3...5)).map({_ in BarEntity(height: CGFloat.random(in: 1...100), color: randColor())})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
