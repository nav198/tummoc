//
//  ToastView.swift
//  tummoc
//
//  Created by nav on 28/07/24.
//

import Foundation
import UIKit


func showToast(_ message: String, _ textColor: UIColor = UIColor.systemBackground, _ bgColor: UIColor = UIColor.label) {
    DispatchQueue.main.async {
        if message.count > 0 {
            guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }

            let bottomPadding = window.safeAreaInsets.bottom

            let messageLbl = UILabel()
            messageLbl.textAlignment = .center
            messageLbl.backgroundColor = bgColor
            messageLbl.textAlignment = .center
            messageLbl.textColor = textColor
            messageLbl.font = UIFont.systemFont(ofSize: 17, weight: .bold)  
            messageLbl.text = message
            messageLbl.numberOfLines = 0
            messageLbl.alpha = 1
            messageLbl.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: CGFloat.greatestFiniteMagnitude)
            messageLbl.sizeToFit()
            let textSize: CGSize = messageLbl.intrinsicContentSize
            let labelWidth = min(textSize.width, window.frame.width - 60)
            messageLbl.frame = CGRect(x: 20, y: window.frame.height - (90 + bottomPadding), width: labelWidth + 30, height: messageLbl.frame.height + 20)
            messageLbl.center.x = window.center.x
            messageLbl.layer.cornerRadius = 10
            messageLbl.layer.masksToBounds = true
            window.addSubview(messageLbl)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 1.8, animations: {
                    messageLbl.alpha = 0
                }) { _ in
                    messageLbl.removeFromSuperview()
                }
            }
        }
    }
}

