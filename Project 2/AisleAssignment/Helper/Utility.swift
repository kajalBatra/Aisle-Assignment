//
//  Utility.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import Foundation
import UIKit


class AlertUtility {
    static func alertWith(error: String, handler: (()->())? = nil) -> UIAlertController {
        let ac  = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        })
        ac.addAction(ok)
        return ac
    }
    
    static func alertWith(success: String, handler: (()->())? = nil) -> UIAlertController {
        let ac  = UIAlertController(title: "Success", message: success, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        })
        ac.addAction(ok)
        return ac
    }
}


class Loader {
    
    private static var loader: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView(frame: .zero)
        loaderView.frame = CGRect(origin: .zero, size: CGSize(width: 90.0, height: 20.0))
        loaderView.hidesWhenStopped = true
        loaderView.style = .large
        return loaderView
    }()
    
    class func show() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let view = sceneDelegate.window?.rootViewController?.view
        else {return}
        
        loader.center = view.center
        view.addSubview(loader)
        
        DispatchQueue.main.async {
            loader.startAnimating()
        }
    }
    
    class func hide() {
        DispatchQueue.main.async {
            loader.removeFromSuperview()
        }
    }
}
