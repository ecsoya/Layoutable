//
//  SliderEditor.swift
//  Layoutable
//
//  Created by Ecsoya on 16/05/2017.
//  Copyright © 2017 Soyatec. All rights reserved.
//

import UIKit

public protocol SliderEditorDelegate {
    func valueChanged(_ value: CGFloat, sender: SliderEditor)
}

open class SliderEditor: LayoutableView, UITextFieldDelegate {

    let MIN_TEXT_WIDTH = CGFloat(46) // width of "100%"

    public enum Style {
        case plain // label - slider - text, lined horizontally.
        case stack // label
        // slider - text, label displayed on the top of slider
    }

    open var labelText: String? {
        didSet {
            updateLabel()
        }
    }

    open var minimumValue: CGFloat? {
        didSet {
            if let value = minimumValue {
                slider.minimumValue = Float(value)
            }
        }
    }

    open var maximumValue: CGFloat? {
        didSet {
            if let value = maximumValue {
                slider.maximumValue = Float(value)
            }
        }
    }

    open var value: CGFloat? {
        set {
            updateEditor(newValue)
        }
        get {
            return getResult(slider.value)
        }
    }

    open var percentage: Bool = true  {
        didSet {
            updateText()
        }
    }

    open var decimals: Int = 2 {
        didSet {
            updateText()
        }
    }

    open var showTextBorder: Bool = true {
        didSet {
            updateTextBorder()
        }
    }

    open var delegate: SliderEditorDelegate?

    private var style: Style = Style.plain

    open var label = UILabel()
    open var slider = UISlider()
    private var text = UITextField()
    private var view = LayoutableView()

    override open var frame: CGRect {
        didSet {
            adjustLayout()
        }
    }

    override convenience init() {
        self.init(frame: CGRect.zero, style: Style.plain)
    }

    convenience public init(style: Style) {
        self.init(frame: CGRect.zero, style: style)
    }

    public init(frame: CGRect, style: Style) {
        self.style = style
        super.init(frame: frame)

        createEditor()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createEditor() {
        self.layout = WeightsLayout()

        text.textAlignment = .center
        updateTextBorder()

        text.keyboardType = .numberPad
        text.delegate = self

        slider.addTarget(self, action: #selector(performValueChanged), for: .valueChanged)

        view.layout = WeightsLayout()

        if style == .plain {
            self.addSubview(label, layoutData: WeightsLayoutData(alignment: .left))
            self.addSubview(slider)
            self.addSubview(text)
        } else {
            self.addSubview(label, layoutData: WeightsLayoutData(alignment: .left))

            self.view.addSubview(slider)
            self.view.addSubview(text)
            self.addSubview(view)
        }
        adjustLayout()
    }

    private func updateTextBorder() {
        if showTextBorder {
            text.layer.borderColor = UIColor.lightGray.cgColor
            text.layer.borderWidth = 0.5
            text.layer.cornerRadius = 4
        } else {
            text.layer.borderColor = UIColor.clear.cgColor
            text.layer.borderWidth = 0
            text.layer.cornerRadius = 0
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let value = getValueFromText() {
            self.value = value
        }
    }

    private func getValueFromText() -> CGFloat? {
        var newValue: CGFloat?
        if let value = self.text.text, let result = getFormatter().number(from: value) {
            if percentage, let max = maximumValue {
                newValue = getResult(result.floatValue / 100 * Float(max))
            } else {
                newValue = getResult(result.floatValue)
            }
        }
        if let val = newValue, let min = minimumValue, let max = maximumValue {
            if val <= max && val >= min {
                return val
            }
        }
        return nil
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let _ = getValueFromText() {
            textField.resignFirstResponder()
            return true
        }
        return false
    }

    @objc private func performValueChanged() {
        updateText()
        delegate?.valueChanged(getResult(slider.value), sender: self)
    }

    private func updateEditor(_ value: CGFloat?) {
        if let newValue = value {
            slider.value = Float(newValue)
        }
        updateText()
    }

    private func getResult(_ value: Float) -> CGFloat {
        if let string = getResultString(value) {
            if let value = getFormatter().number(from: string) {
                return CGFloat(value.floatValue)
            }
        }
        return CGFloat(slider.value)
    }

    private func getFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = decimals > 0
        formatter.alwaysShowsDecimalSeparator = decimals > 0
        formatter.numberStyle = decimals > 0 ? .decimal : .none
        formatter.roundingMode = .ceiling
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        return formatter
    }

    private func getResultString(_ value: Float) -> String? {
        return getFormatter().string(from: NSNumber(value: value))
    }

    private func updateText() {
        let result = getResult(slider.value)
        if percentage {
            text.text = "\(Int(result / CGFloat(slider.maximumValue) * 100))%"
        } else {
            text.text = getResultString(slider.value)
        }
        adjustLayout()
    }

    private func updateLabel() {
        label.text = labelText
        adjustLayout()
    }

    private func adjustLayout() {
        let size = self.bounds.size
        if size.width <= 0 || size.height <= 0 {
            return
        }
        let x1 = max(label.sizeThatFits(size).width + 2, label.frame.width)
        let x2 = max(max(text.sizeThatFits(size).width + 2, text.frame.width), MIN_TEXT_WIDTH)
        if style == .plain {
            self.layout?.horizontal = true
            self.layout?.weights = [Int(x1), Int(size.width - x1 - x2), Int(x2)]
            self.doLayout()
        } else {
            self.layout?.horizontal = false
            self.layout?.weights = [1, 1]
            self.doLayout()

            self.view.layout?.horizontal = true
            self.view.layout?.weights = [Int(size.width - x2), Int(x2)]
            self.view.doLayout()
        }
    }
    
}
