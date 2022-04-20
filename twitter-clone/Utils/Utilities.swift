//
//  Utilities.swift
//  twitter-clone
//
//  Created by Fernando Marins on 20/04/22.
//

import Foundation
import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        
        imageView.image = image
        view.addSubview(imageView)
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.anchor(left: view.leftAnchor,
                         paddingLeft: 8, bottom:
                         view.bottomAnchor,
                         paddingBottom: 8,
                         width: 24,
                         height: 24)
        
        return view
    }
    
}
