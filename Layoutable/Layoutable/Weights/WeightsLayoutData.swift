//
//  WeightsLayoutData.swift
//  Layoutable
//
//  Created by Ecsoya on 31/03/2017.
//  Copyright © 2017 Soyatec. All rights reserved.
//

import UIKit

public class WeightsLayoutData {

    public var width: CGFloat = 0
    public var height: CGFloat = 0

    public var alignment: WeightsLayoutAlignment = .fill

    public init(width: CGFloat = 0, height: CGFloat = 0, alignment: WeightsLayoutAlignment = .fill) {
        self.width = width
        self.height = height
        self.alignment = alignment
    }
}

public enum WeightsLayoutAlignment {
    case fill, left, center, right, top, bottom
}
