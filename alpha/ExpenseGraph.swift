//
//  ExpenseGraph.swift
//  alpha
//
//  Created by Ezra Bathini on 2/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import Material


struct ExpenseSlice {
    var color: UIColor
    var value: CGFloat
    var title: String
    
    init(value: CGFloat, title: String) {
        self.value = value
        self.title = title
        self.color = MaterialColor.orange.lighten2
    }
}

struct Radius {
    var inner: CGFloat = 0
    var outer: CGFloat = 10
}


@IBDesignable class ExpenseGraph: UIView {
    var total: CGFloat!
    

    
    var slices: [ExpenseSlice]!
        
//        = [] {
//        didSet {
//            total = 0
//            for slice in slices {
//                total = slice.value + total
//            }
//        }
//    }
    
    var expenses: [String: Float] = [:] {
        didSet {
            total = 0
            slices.removeAll()
            for expense in expenses {
                let slice = ExpenseSlice(value: CGFloat(expense.1), title: expense.0)
                slices.append(slice)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.contentMode = .Redraw
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = .Redraw
    }
    
    var radius: Radius = Radius()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        var startValue: CGFloat = 0
        var startAngle: CGFloat = 0
        var endValue: CGFloat = 0
        var endAngle: CGFloat = 0
        
        for (index, slice) in slices.enumerate() {
            
            startAngle = (startValue * 2 * CGFloat(M_PI)) - CGFloat(M_PI_2)
            endValue = startValue + (slice.value / self.total)
            endAngle = (endValue * 2 * CGFloat(M_PI)) - CGFloat(M_PI_2)
            
            let path = UIBezierPath()
            path.moveToPoint(center)
            path.addArcWithCenter(center, radius: radius.outer, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            var color = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)

            color = slice.color
            color.setFill()
            path.fill()
            
            // add white border to slice
            UIColor.whiteColor().setStroke()
            path.stroke()
            
            // increase start value for next slice
            startValue += slice.value / self.total
        }
    }
}