//
//  UIView+Additions.swift
//  NotificationView
//
//  Created by Hayk Brsoyan on 4/16/19.
//  Copyright © 2019 Hayk Brsoyan. All rights reserved.
//

import UIKit

extension UIResponder {
    static var id: String {
        return String(describing: self)
    }
}

extension UIView {
    
    static func fromNib() -> Self {
        return loadNibHelper(nil)
    }
    
    static func fromNib(_ frame: CGRect) -> Self {
        return loadNibHelper(frame)
    }
    
    static func loadNibHelper<T: UIView>(_ frame: CGRect?) -> T {
        let views = Bundle.main.loadNibNamed(id, owner: self, options: nil)
        let view = views!.first as! T
        if frame != nil {
            view.frame = frame!
        }
        return view
    }
    
    func addSubviewWithLayoutToBottom(subview: UIView, height: CGFloat) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func addSubviewWithLayoutToBounds(subview: UIView) {
        addSubview(subview)
        addConstraintToBounds(view: subview)
    }
    
    func insterSubviewWithLayoutToBounds(subview: UIView, at index: Int) {
        insertSubview(subview, at: index)
        addConstraintToBounds(view: subview)
    }
    
    private func addConstraintToBounds(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func transitionAnimation(type: CATransitionType, duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = type
        animation.duration = duration
        layer.add(animation, forKey: nil)
    }
    
    func fadeAnimation() {
        transitionAnimation(type: .fade, duration: 0.2)
    }
}

extension UIWindow {
    static func bottomSafeAreaHeight() -> CGFloat {
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                bottomSafeAreaHeight = window.safeAreaInsets.bottom
            }
        }
        return bottomSafeAreaHeight
    }
    
    static func topSafeAreaHeight() -> CGFloat {
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                bottomSafeAreaHeight = window.safeAreaInsets.top
            }
        }
        return bottomSafeAreaHeight
    }
}
