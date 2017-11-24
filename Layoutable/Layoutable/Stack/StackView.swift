//
//  StackView.swift
//  Layoutable
//
//  Created by Ecsoya on 17/05/2017.
//  Copyright © 2017 Soyatec. All rights reserved.
//

import UIKit

open class StackView: UIView {

    open var topView: UIView? {
        didSet {
            layoutSubviews()
        }
    }

    open var hideBottomViews = true {
        didSet {
            layoutSubviews()
        }
    }

    override open var frame: CGRect {
        didSet {
            layoutIfNeeded()
        }
    }

    override open func layoutSubviews() {
        for subview in subviews {
            subview.frame = self.bounds
            if hideBottomViews {
                subview.isHidden = true
            }
        }
        if hideBottomViews {
            if let visibleView = topView, let superview = visibleView.superview, superview == self {
                visibleView.isHidden = false
            }
        }
    }
}
