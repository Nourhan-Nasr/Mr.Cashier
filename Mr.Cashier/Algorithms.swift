//
//  Algorithms.swift
//  Mr.Cashier
//
//  Created by Shimaa Hassan on 4/22/19.
//  Copyright © 2019 Shimaa Hassan. All rights reserved.
//

import Foundation
import UIKit

typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}
extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}
//
let activityIndecator: UIActivityIndicatorView = UIActivityIndicatorView()
func setupActivityLoading(vc: UIViewController, mainView: UIView){
    //                        activity indecator
    activityIndecator.center = vc.view.center
    activityIndecator.hidesWhenStopped = true
    activityIndecator.style = UIActivityIndicatorView.Style.gray
    activityIndecator.transform = CGAffineTransform(scaleX: 4, y: 4)
    mainView.addSubview(activityIndecator)
}
