//
//  Utilities.swift
//  twitter-clone
//
//  Created by Fernando Marins on 20/04/22.
//

import Foundation
import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage?) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        
        imageView.image = image
        view.addSubview(imageView)
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.anchor(left: view.leftAnchor,
                         paddingLeft: 8,
                         bottom: view.bottomAnchor,
                         paddingBottom: 8,
                         width: 24,
                         height: 24)
        
        let divisorView = UIView()
        divisorView.backgroundColor = .white
        view.addSubview(divisorView)
        divisorView.anchor(left: view.leftAnchor,
                           paddingLeft: 8,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor,
                           height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }
    
    func attributedButon(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
    func createButton(imageName: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
