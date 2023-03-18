//
//  Extensions.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 18/03/23.
//

import UIKit

extension UIImageView {
    
    func setImage(string: String?) {
        if let imageString = string,
           let url = URL(string: imageString),
           let data = try? Data(contentsOf: url) {
            image = UIImage(data: data)
        }
    }
    
    func addBlur() {
        let effect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(effectView)
    }
}
