//
//  LayoutContainer.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 20.06.2022.
//

import Foundation
import UIKit

/**
 My humble SnapKit
 */
class LayoutContainer {
    var view: UIView
    var constraints = [NSLayoutConstraint]()
    
    init(_ view: UIView) {
        self.view = view
    }
    
    func add(_ constraint: NSLayoutConstraint) -> Self {
        constraints.append(constraint)
        return self
    }
    
    fileprivate func apply(dimension: NSLayoutDimension, to: NSLayoutDimension? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil) -> Self {
        if to == nil && constant == nil {
            fatalError("You must use UIView or constant value")
        }
        if let view = to, let constant = constant {
            let c = dimension.constraint(equalTo: view, multiplier: multiplier ?? 1, constant: constant)
            return add(c)
        } else if let view = to {
            let c = dimension.constraint(equalTo: view, multiplier: multiplier ?? 1)
            return add(c)
        } else if let constant = constant {
            let c = dimension.constraint(equalToConstant: constant)
            return add(c)
        }
        return self
    }
    
    fileprivate func apply(xAnchor: NSLayoutXAxisAnchor, to: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, constant: CGFloat? = nil) -> Self {
        if to == nil {
            fatalError("You must use UIView or constant value")
        }
        if let view = to {
            let c = xAnchor.constraint(equalTo: view, constant: constant ?? 0)
            return self.add(c)
        }
        return self
    }
    
    fileprivate func apply(yAnchor: NSLayoutYAxisAnchor, to: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, constant: CGFloat? = nil) -> Self {
        if to == nil {
            fatalError("You must use UIView or constant value")
        }
        if let view = to {
            let c = yAnchor.constraint(equalTo: view, constant: constant ?? 0)
            return self.add(c)
        }
        return self
    }
    
    func commit() {
        NSLayoutConstraint.activate(constraints)
    }
}

extension UIView {
    func curb() -> LayoutContainer {
        self.translatesAutoresizingMaskIntoConstraints = false
        return LayoutContainer(self)
    }
}

extension LayoutContainer {
    fileprivate func setWidth(to: UIView? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil) -> Self {
        return apply(dimension: view.widthAnchor, to: to?.widthAnchor, constant: constant, multiplier: multiplier)
    }
    
    fileprivate func setHeight(to: UIView? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil) -> Self {
        return apply(dimension: view.heightAnchor, to: to?.heightAnchor, constant: constant, multiplier: multiplier)
    }
    
    fileprivate func setLeft(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(xAnchor: view.leftAnchor, to: to?.leftAnchor, constant: constant)
    }
    
    fileprivate func setRight(to: UIView? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil) -> Self {
        return apply(xAnchor: view.rightAnchor, to: to?.rightAnchor, constant: constant)
    }
    
    fileprivate func setLeading(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(xAnchor: view.leadingAnchor, to: to?.leadingAnchor, constant: constant)
    }
    
    fileprivate func setTrailing(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(xAnchor: view.trailingAnchor, to: to?.trailingAnchor, constant: constant)
    }
    
    fileprivate func setCenterX(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(xAnchor: view.centerXAnchor, to: to?.centerXAnchor, constant: constant)
    }
    
    fileprivate func setCenterY(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(yAnchor: view.centerYAnchor, to: to?.centerYAnchor, constant: constant)
    }
    
    fileprivate func setTop(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(yAnchor: view.topAnchor, to: to?.topAnchor, constant: constant)
    }
    
    fileprivate func setBottom(to: UIView? = nil, constant: CGFloat? = nil) -> Self {
        return apply(yAnchor: view.bottomAnchor, to: to?.bottomAnchor, constant: constant)
    }
}

extension LayoutContainer {
    func setWidth(to: UIView, constant: CGFloat) -> Self {
        return apply(dimension: view.widthAnchor, to: to.widthAnchor, constant: constant, multiplier: 1)
    }
    
    func setHeight(to: UIView, constant: CGFloat) -> Self {
        return apply(dimension: view.heightAnchor, to: to.heightAnchor, constant: constant, multiplier: 1)
    }
    
    func setLeft(to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.leftAnchor, to: to.leftAnchor, constant: constant)
    }
    
    func setRight(to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.rightAnchor, to: to.rightAnchor, constant: constant)
    }
    
    func setLeading(to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.leadingAnchor, to: to.leadingAnchor, constant: constant)
    }
    
    func setTrailing(to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.trailingAnchor, to: to.trailingAnchor, constant: constant)
    }
    
    func setCenterX(to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.centerXAnchor, to: to.centerXAnchor, constant: constant)
    }
    
    func setCenterY(to: UIView, constant: CGFloat) -> Self {
        return apply(yAnchor: view.centerYAnchor, to: to.centerYAnchor, constant: constant)
    }
    
    func setTop(to: UIView, constant: CGFloat) -> Self {
        return apply(yAnchor: view.topAnchor, to: to.topAnchor, constant: constant)
    }
    
    func setTop(toBottom to: UIView, constant: CGFloat) -> Self {
        return apply(yAnchor: view.topAnchor, to: to.bottomAnchor, constant: constant)
    }
    
    func setBottom(to: UIView, constant: CGFloat) -> Self {
        return apply(yAnchor: view.bottomAnchor, to: to.bottomAnchor, constant: constant)
    }
    
    func setBottom(toTop to: UIView, constant: CGFloat) -> Self {
        return apply(yAnchor: view.bottomAnchor, to: to.topAnchor, constant: constant)
    }
    
    func setLeading(toTrailing to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.leadingAnchor, to: to.trailingAnchor, constant: constant)
    }
    
    func setTrailing(toLeading to: UIView, constant: CGFloat) -> Self {
        return apply(xAnchor: view.trailingAnchor, to: to.leadingAnchor, constant: constant)
    }
}

extension LayoutContainer {
    func setWidth(to: UIView) -> Self {
        return apply(dimension: view.widthAnchor, to: to.widthAnchor, constant: 0, multiplier: 1)
    }
    
    func setHeight(to: UIView) -> Self {
        return apply(dimension: view.heightAnchor, to: to.heightAnchor, constant: 0, multiplier: 1)
    }
    
    func setLeft(to: UIView) -> Self {
        return apply(xAnchor: view.leftAnchor, to: to.leftAnchor, constant: 0)
    }
    
    func setRight(to: UIView) -> Self {
        return apply(xAnchor: view.rightAnchor, to: to.rightAnchor, constant: 0)
    }
    
    func setLeading(to: UIView) -> Self {
        return apply(xAnchor: view.leadingAnchor, to: to.leadingAnchor, constant: 0)
    }
    
    func setTrailing(to: UIView) -> Self {
        return apply(xAnchor: view.trailingAnchor, to: to.trailingAnchor, constant: 0)
    }
    
    func setCenterX(to: UIView) -> Self {
        return apply(xAnchor: view.centerXAnchor, to: to.centerXAnchor, constant: 0)
    }
    
    func setCenterY(to: UIView) -> Self {
        return apply(yAnchor: view.centerYAnchor, to: to.centerYAnchor, constant: 0)
    }
    
    func setTop(to: UIView) -> Self {
        return apply(yAnchor: view.topAnchor, to: to.topAnchor, constant: 0)
    }
    
    func setTop(toBottom to: UIView) -> Self {
        return apply(yAnchor: view.topAnchor, to: to.bottomAnchor)
    }
    
    func setBottom(to: UIView) -> Self {
        return apply(yAnchor: view.bottomAnchor, to: to.bottomAnchor)
    }
    
    func setBottom(toTop to: UIView) -> Self {
        return apply(yAnchor: view.bottomAnchor, to: to.topAnchor)
    }
    
    func setLeading(toTrailing to: UIView) -> Self {
        return apply(xAnchor: view.leadingAnchor, to: to.trailingAnchor)
    }
    
    func setTrailing(toLeading to: UIView) -> Self {
        return apply(xAnchor: view.trailingAnchor, to: to.leadingAnchor)
    }
}

// only constants
extension LayoutContainer {
    func setWidth(_ constant: CGFloat) -> Self {
        return apply(dimension: view.widthAnchor, to: nil, constant: constant, multiplier: 1)
    }
    
    func setHeight(_ constant: CGFloat) -> Self {
        return apply(dimension: view.heightAnchor, to: nil, constant: constant, multiplier: 1)
    }
    
    func set(width: CGFloat, height: CGFloat) -> Self {
        return setWidth(width).setHeight(height)
    }
    
    func square(_ w: CGFloat) -> Self {
        return setWidth(w).setHeight(w)
    }
    
    func setCenter(view: UIView) -> Self {
        return setCenterX(to: view).setCenterY(to: view)
    }
    
    func fit(view: UIView, offset: CGFloat) -> Self {
        return setWidth(to: view, constant: -2 * offset).setHeight(to: view, constant: -2 * offset).setCenter(view: view)
    }
    
    func fit(view: UIView) -> Self {
        return fit(view: view, offset: 0)
    }
}
