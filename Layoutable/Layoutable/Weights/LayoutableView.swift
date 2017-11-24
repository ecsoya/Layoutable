//
//  LayoutableView.swift
//  Layoutable
//
//  Created by Ecsoya on 17/03/2017.
//  Copyright © 2017 Soyatec. All rights reserved.
//

import UIKit

open class LayoutableView: UIView {

    public var layout: WeightsLayout? = WeightsLayout() {
        didSet {
            layoutDatas.removeAll(keepingCapacity: false)
            doLayout()
        }
    }

    public var layoutDatas = [UIView: WeightsLayoutData]()

    public init() {
        super.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func doLayout() {
        layout?.layoutDatas = layoutDatas
        layout?.layout(self)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layout?.layoutDatas = layoutDatas
        layout?.layout(self, size: bounds.size)
    }

    public func addSubview(_ view: UIView, layoutData: WeightsLayoutData) {
        super.addSubview(view)
        layoutDatas[view] = layoutData
    }

    override open func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        layoutDatas[subview] = nil
    }
}
