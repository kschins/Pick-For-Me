//
//  SelectedView.swift
//  Pick For Me
//
//  Created by Kasey Schindler on 6/9/14.
//  Copyright (c) 2014 Kasey Schindler. All rights reserved.
//

import Foundation
import UIKit

class SelectedView: UIView {
    init(frame: CGRect, labelString: String)  {
        super.init(frame: frame);
        
        // background color
        let backgroundColors = [UIColor.yellowColor(), UIColor.orangeColor(), UIColor.redColor(), UIColor.greenColor(),
            UIColor.magentaColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.blueColor()]
        
        let randomNumber = arc4random_uniform(UInt32(backgroundColors.count)).hashValue
        backgroundColor = backgroundColors[randomNumber]
        
        // add label based on size
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.text = labelString
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.font = UIFont(name: "Avenir-Heavy", size: 23)
        addSubview(label)
    }
}