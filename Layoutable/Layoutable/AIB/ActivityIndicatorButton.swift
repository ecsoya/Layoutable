//
//  ActivityIndicatorButton.swift
//  Layoutable
//
//  Created by Ecsoya on 27/04/2017.
//  Copyright © 2017 Soyatec. All rights reserved.
//

import UIKit

open class ActivityIndicatorButton: UIButton {

    open let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

    private var isBusy: Bool = false

    private var image: UIImage?

    private var title: String?

    override init(frame: CGRect) {
        super.init(frame: frame)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.blue
        addSubview(activityIndicator)

        setBusy(isBusy)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.frame = self.bounds
    }

    open func setBusy(_ isBusy: Bool) {
        if self.isBusy == isBusy {
            return
        }
        self.isBusy = isBusy
        if isBusy {
            self.isUserInteractionEnabled = false
            self.image = image(for: .normal)
            self.title = title(for: .normal)
            self.setTitle(nil, for: .normal)
            self.setImage(nil, for: .normal)
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            if image != nil {
                self.setImage(image, for: .normal)
            }
            if title != nil {
                self.setTitle(title, for: .normal)
            }
            self.isUserInteractionEnabled = true
        }
    }

    deinit {
        self.image = nil
        self.title = nil
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isBusy {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}
