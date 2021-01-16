//
//  ViewController+AlertMessage.swift
//  FitnessApp
//
//  Created by Tigran  Simonyan on 10/13/20.
//  Copyright © 2020 On-line Retail Delivery Limited. All rights reserved.
//

import UIKit

extension ViewController {
    
    /// This function shows alert message with given `text` for given `duration`.
    ///
    /// ```
    /// If there is already presented alert message, this function will show that one, and then show new alert message with given parameters
    /// ```
    ///
    /// - Parameter text: Alert message
    /// - Parameter backgroundColor: Alert view background color. Default value is `black`
    /// - Parameter textColor: Alert message text color. Default value is `white`
    /// - Parameter duration: Alert message presenting duration. Default value is `3` seconds
    func showAlertMessage(with text: String,
                          backgroundColor: UIColor = .black,
                          textColor: UIColor = .white,
                          duration: TimeInterval = 3) {
        hideAlertMessage { [self] in
            guard let mainWindow = AppDelegate.shared.window else { return }
            let topOffset = mainWindow.safeAreaInsets.top

            let mainViewFrameWidth = mainWindow.frame.width
            let backgroundViewHeight: CGFloat = 60 + topOffset
            let backgroundViewWidth = traitCollection.horizontalSizeClass == .regular ? mainViewFrameWidth / 2 : mainViewFrameWidth
            let backgroundViewFrame = CGRect(x: 0,
                                             y: -backgroundViewHeight,
                                             width: backgroundViewWidth,
                                             height: backgroundViewHeight)
            let backgroundView = UIView(frame: backgroundViewFrame)
            backgroundView.backgroundColor = backgroundColor
            
            let messageLabel = UILabel()
            messageLabel.textColor = textColor
            messageLabel.text = text
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 2
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(messageLabel)
            
            NSLayoutConstraint.activate([
                messageLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
                messageLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                messageLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.85),
            ])
            
            alertMessageView = backgroundView
            
            mainWindow.addSubview(alertMessageView!)
            
            UIView.animate(withDuration: 1) {
                let backgroundViewNewFrame = CGRect(x: 0,
                                                    y: 0,
                                                    width: backgroundViewWidth,
                                                    height: backgroundViewHeight)
                self.alertMessageView?.frame = backgroundViewNewFrame
                mainWindow.layoutIfNeeded()
            } completion: { animated in
                if animated {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        self.hideAlertMessage()
                    }
                }
            }

        }
    }
    
    private func hideAlertMessage(completion: (() -> Void)? = nil) {
        guard let alertView = alertMessageView else {
            completion?()
            return
        }
        UIView.animate(withDuration: 1) {
            let frame = CGRect(x: 0,
                               y: -alertView.frame.height,
                               width: alertView.bounds.width,
                               height: alertView.bounds.height)
            alertView.frame = frame
            self.view.layoutIfNeeded()
        } completion: { animated in
            if animated {
                alertView.removeFromSuperview()
                self.alertMessageView = nil
                completion?()
            }
        }
    }
}
