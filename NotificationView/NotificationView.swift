//
//  NotificationView.swift
//  NotificationView
//
//  Created by Hayk Brsoyan on 4/16/19.
//  Copyright © 2019 Hayk Brsoyan. All rights reserved.
//

import UIKit

extension NotificationView {
    enum Style {
        case success
        case error
        case info
        case loading
    }
}

class NotificationView: UIView, UIGestureRecognizerDelegate {
    
    static let animationDuration: TimeInterval = 0.25
    static let timeOfLive: TimeInterval = 3
    static let deltaForRemove: CGFloat = 30
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    private var panGesture = UIPanGestureRecognizer()
    private var longPressGesture = UILongPressGestureRecognizer()
    private var timer: Timer?
    private var contentCenterY: CGFloat!
    private var isDragging = false
    private var removeCompletion: (() -> Void)?
    
    var autoCancel = true
    
    static private var initialFrame: CGRect {
        let height: CGFloat = 70
        let yCoordinate = -(height + UIWindow.topSafeAreaHeight())
        return CGRect(x: 0, y: yCoordinate, width: UIScreen.main.bounds.width, height: height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .gray
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.isUserInteractionEnabled = false
        titleLabel.textColor = UIColor.white
        messageLabel.textColor = UIColor.white
        
        panGesture.addTarget(self, action: #selector(dragAction(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        longPressGesture.addTarget(self, action: #selector(longPressAction(_:)))
        longPressGesture.delegate = self
        addGestureRecognizer(longPressGesture)
    }
    
    static func show(style: Style, titileText: String? = nil, messageText: String? = nil) {
        NotificationView.fromNib(initialFrame).showInWindow(style: style, titileText: titileText, messageText: messageText)
    }
    
    func showInWindow(style: Style, titileText: String?, messageText: String?) {
        let window = UIApplication.shared.keyWindow
        window!.addSubview(self)
        show(style: style, titileText: titileText, messageText: messageText)
    }
    
    private func show(style: Style, titileText: String?, messageText: String?) {
        frame = NotificationView.initialFrame
        switch style {
        case .success:
            imageView.image = UIImage(named: "ic_success")
            imageView.tintColor = UIColor.green
        case .error:
            imageView.image = UIImage(named: "ic_error")
            imageView.tintColor = UIColor.red
        case .info:
            imageView.image = nil
            imageViewWidth.constant = 0
            imageViewLeading.constant = 0
        case .loading:
            let activityIndicator = UIActivityIndicatorView(frame: imageView.frame)
            activityIndicator.color = UIColor.yellow
            imageView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            activityIndicator.startAnimating()
        }
        
        titleLabel.text = titileText
        messageLabel.text = messageText
        
        DispatchQueue.main.async {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.containerView.bounds.height + self.containerView.frame.origin.y)
            self.moveToInitialState(withDuration: NotificationView.animationDuration, yCoordinate: UIWindow.topSafeAreaHeight())
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture || gestureRecognizer == longPressGesture {
            return true
        }
        return false
    }
    
    @objc private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            UIView.animate(withDuration: NotificationView.animationDuration, animations: {
                self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            }, completion: nil)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: NotificationView.animationDuration) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc private func dragAction(_ gesture: UIPanGestureRecognizer) {
        isDragging = true
        if let parentView = superview {
            timer?.invalidate()
            if contentCenterY == nil {
                contentCenterY = convert(center, to: parentView).y
            }
            switch gesture.state {
            case .began:
                UIView.animate(withDuration: 0.5) {
                    self.transform = CGAffineTransform.identity
                }
                isDragging = false
            case .ended:
                if convert(center, to: parentView).y < NotificationView.deltaForRemove {
                    removeWithAnimation()
                } else {
                    let yCoordinate = frame.origin.y < 0 ? 0 : UIWindow.topSafeAreaHeight()
                    moveToInitialState(withDuration: NotificationView.animationDuration, yCoordinate: yCoordinate)
                }
            case .changed:
                let translation = gesture.translation(in: self)
                gesture.setTranslation(CGPoint.zero, in: self)
                
                if gesture.velocity(in: parentView).y > 0 {
                    center = CGPoint(x: center.x, y: center.y + translation.y/3)
                } else {
                    center = CGPoint(x: center.x, y: center.y + translation.y/3)
                }
                
                if convert(center, to: parentView).y < NotificationView.deltaForRemove {
                    if gesture.velocity(in: parentView).y < 0 && abs(gesture.velocity(in: parentView).y) > 600 {
                        gesture.isEnabled = false
                        removeWithAnimation()
                    }
                }
            default: break
            }
        }
    }
    
    // MARK: - Animations
    
    private func moveToInitialState(withDuration: TimeInterval, yCoordinate: CGFloat) {
        if autoCancel {
            timer = Timer.scheduledTimer(timeInterval: NotificationView.timeOfLive, target: self, selector: #selector(removeWithAnimation), userInfo: nil, repeats: false)
        }
        
        UIView.animate(withDuration: withDuration, delay: 0, options: .curveEaseOut, animations: {
            var newFrame = self.frame
            newFrame.origin.y = yCoordinate
            self.frame = newFrame
        }, completion: { (finish) in
            if finish {
                self.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                self.isDragging = false
                if self.removeCompletion != nil {
                    self.removeWith(self.removeCompletion)
                }
            }
        })
    }
    
    func removeWith(_ completion: (() -> Void)?) {
        removeCompletion = completion
        if !isDragging {
            UIView.animate(withDuration: NotificationView.animationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.frame = NotificationView.initialFrame
            }, completion: { (finish) in
                if finish {
                    self.removeFromSuperview()
                    completion?()
                    self.removeCompletion = nil
                }
            })
        }
    }
    
    @objc func removeWithAnimation() {
        UIView.animate(withDuration: NotificationView.animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.frame = NotificationView.initialFrame
        }, completion: { (finish) in
            if finish {
                self.removeFromSuperview()
                self.removeCompletion = nil
            }
        })
    }
}
