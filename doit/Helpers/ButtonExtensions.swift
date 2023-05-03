//
//  ButtonExtensions.swift
//  doit
//
//  Created by FirasBenAbdallah on 18/4/2023.
//

import UIKit

extension UIButton {
    
    func shakeButton() {
        // Define the animation properties
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
        var timer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true) { (timer) in
            // Change the background color
            self.backgroundColor = UIColor.systemRed
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let myColor = UIColor(named: "AccentColor")
            timer.invalidate()
            self.backgroundColor = myColor
        }
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
        var timer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true) { (timer) in
            // Change the background color
            self.backgroundColor = UIColor.systemRed
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let myColor = UIColor(named: "AccentColor")
            timer.invalidate()
            self.backgroundColor = myColor
        }
    }
            
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2.0
        layer.add(flash, forKey: nil)
        var timer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true) { (timer) in
            // Change the background color
            self.backgroundColor = UIColor.systemRed
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let myColor = UIColor(named: "AccentColor")
            timer.invalidate()
            self.backgroundColor = myColor
        }
    }
}
