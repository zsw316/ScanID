//
//  ScannerView.swift
//  ScanID
//
//  Created by Ashley Han on 26/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class ScannerView: UIView {

    private var rectSize: CGSize = CGSize(width: 320.0, height: 220.0)
    
    private var offsetY: CGFloat = -50.0
    
    var scanRect: CGRect {
        let minX: CGFloat = (self.frame.width - self.rectSize.width) / 2.0
        let minY: CGFloat = (self.frame.height - self.rectSize.height)/2.0 + self.offsetY
        
        return CGRect(x: minX, y: minY, width: rectSize.width, height: rectSize.height)
    }
    
    init(frame: CGRect, rectSize: CGSize, offsetY: CGFloat) {
        super.init(frame: frame)
        
        self.rectSize = rectSize
        self.offsetY = offsetY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            print("UIGraphicsGetCurrentContext failed")
            return
        }
    
        let minX: CGFloat = (self.frame.width - self.rectSize.width) / 2.0
        let maxX: CGFloat = minX + self.rectSize.width
        let minY: CGFloat = (self.frame.height - self.rectSize.height)/2.0 + self.offsetY
        let maxY: CGFloat = minY + self.rectSize.height
        
        let topRect = CGRect(x: 0, y: 0, width: self.frame.width, height: minY)
        let bottomRect = CGRect(x: 0, y: maxY, width: self.frame.width, height: self.frame.height - maxY)
        let leftRect = CGRect(x: 0, y: minY, width: minX, height: self.rectSize.height)
        let rightRet = CGRect(x: maxX, y: minY, width: self.frame.width - maxX, height: self.rectSize.height)
        
        context.beginPath()
        
        context.addRect(topRect)
        context.addRect(bottomRect)
        context.addRect(leftRect)
        context.addRect(rightRet)
        context.closePath()

        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        context.fillPath()
        
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.white.cgColor)
        context.addRect(CGRect(x: minX, y: minY, width: self.rectSize.width, height: self.rectSize.height))
        context.strokePath()
    }
}
