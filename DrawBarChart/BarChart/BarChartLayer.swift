//
//  BarChartLayer.swift
//  DrawBarChart
//
//  Created by YuriyFpc on 12/5/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

fileprivate struct BarChartDelegateConstatns {
    static let space: CGFloat = 10
    static let animationDuration: Double = 2
    static let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
}

protocol BarChartDelegate: AnyObject {
    func space() -> CGFloat
    func animationDuration() -> Double
    func insets() -> UIEdgeInsets
}

extension BarChartDelegate {
    func space() -> CGFloat {
        return BarChartDelegateConstatns.space
    }
    
    func animationDuration() -> Double {
        return BarChartDelegateConstatns.animationDuration
    }
    
    func insets() -> UIEdgeInsets {
        return BarChartDelegateConstatns.edgeInsets
    }
}


final class BarChartLayer: CALayer {
    
    private struct Constatns {
        static let space: CGFloat = BarChartDelegateConstatns.space
        static let animationDuration: Double = BarChartDelegateConstatns.animationDuration
        static let edgeInsets: UIEdgeInsets = BarChartDelegateConstatns.edgeInsets

        static let barColor: UIColor = .green
        static let groupKey = "groupKey"
        static let soloKey = "soloKey"
    }
    
    weak var appearanceDelegate: BarChartDelegate!
    var isAnimating: Bool {
        return (animationKeys()?.count ?? 0) > 0
    }
    var enteties: [BarEntity] = [BarEntity]() {
        willSet {
            oldEnteties = enteties
            currentValues = enteties.map({$0.height})
        }
        didSet {
            self.newValues = enteties.map({$0.height})
            if currentValues.count != newValues.count {
                self.animateNumberOfBarsChange()
            } else {
                self.animateBarsHeightChange()
            }
        }
    }
    
    // need for saving entety values for down to 0 animation
    private var oldEnteties: [BarEntity] = [BarEntity]()
    @objc
    private var currentValues = [CGFloat]()
    private var newValues = [CGFloat]()
    private var numberOfBars: Int  {
        return currentValues.count
    }
    private var space: CGFloat {
        return appearanceDelegate?.space() ?? Constatns.space
    }
    private var animationDuration: Double {
        return appearanceDelegate?.animationDuration() ?? Constatns.animationDuration
    }
    private var insets: UIEdgeInsets {
        return appearanceDelegate?.insets() ?? Constatns.edgeInsets
    }
    
    override init(layer: Any) {
        if let base = layer as? BarChartLayer {
            appearanceDelegate = base.appearanceDelegate
            enteties = base.enteties
            oldEnteties = base.oldEnteties
        }
        super.init(layer: layer)
    }
    
    override init() {
        super.init()
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(currentValues) {
            return true
        }
        return super.needsDisplay(forKey:key)
    }
    
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        let con = ctx
        let rect = self.bounds
        
        con.addRect(rect)
        con.setFillColor(UIColor.gray.cgColor)
        con.fillPath()
        
        var pointX: CGFloat = 0
        let bw = barWidth(rect: rect)
        
        for i in 0..<Int(numberOfBars) {
            pointX = insets.left + CGFloat(i) * (bw + space)
            var newHeight: CGFloat!
            newHeight = self.currentValues[i]
            con.addRect(CGRect(x: pointX, y: 0, width: bw, height: makeProcentFor(value: newHeight, rect: rect)))
            debugPrint("I \(i)")
            
            if oldEnteties.count > i {
                con.setFillColor(oldEnteties[i].color.cgColor)
            } else {
                con.setFillColor(enteties[i].color.cgColor)
            }
            con.fillPath()
        }


        UIGraphicsPopContext()
    }
    
    private func isAnimationGrowingDown() -> Bool {
        if animationKeys()?.first == Constatns.groupKey {
            return true
        } else {
            return false
        }
    }
    
    private func animateNumberOfBarsChange() {
        let down = CABasicAnimation(keyPath: #keyPath(currentValues))
        down.duration = 0.5
        down.beginTime = 0
        down.fromValue = currentValues
        down.toValue = currentValues.map({_ in return 0})
        down.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let up = CABasicAnimation(keyPath: #keyPath(currentValues))
        up.duration = animationDuration
        up.beginTime = down.duration
        up.fromValue = newValues.map({_ in return 0})
        up.toValue = newValues
        up.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        currentValues = newValues
        
        let group = CAAnimationGroup()
        group.duration = down.duration + up.duration
        group.animations = [down, up]
        add(group, forKey: Constatns.groupKey)
    }
    
    private func animateBarsHeightChange() {
        let ba = CABasicAnimation(keyPath: #keyPath(currentValues))
        ba.duration = animationDuration
        ba.fromValue = currentValues
        ba.toValue = newValues
        ba.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        currentValues = newValues
        add(ba, forKey: Constatns.soloKey)
    }
    
    private func barWidth(rect: CGRect) -> CGFloat {
        return (rect.width - insets.left - insets.right - space * (CGFloat(numberOfBars) - 1)) / CGFloat(numberOfBars)
    }
    
    private func makeProcentFor(value: CGFloat, rect: CGRect) -> CGFloat {
        return value * rect.height / 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


