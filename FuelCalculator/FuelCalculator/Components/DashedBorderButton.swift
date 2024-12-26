//
//  DashedBorderButton.swift
//  FuelCalculator
//
//  Created by Dmitriy Opryatnov on 14.08.24.
//

import UIKit

class DashedBorderButton: UIButton {
    
    private var borderLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorderLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorderLayer()
    }
    
    private func setupBorderLayer() {
        borderLayer = CAShapeLayer()
        borderLayer?.strokeColor = UIColor(resource: .gold1).cgColor
        borderLayer?.fillColor = nil
        borderLayer?.lineDashPattern = [3, 3]
        borderLayer?.lineWidth = 1
        layer.addSublayer(borderLayer!)
        layer.cornerRadius = 17
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: 17).cgPath
        borderLayer?.frame = bounds
    }
}
