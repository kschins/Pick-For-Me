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
        let backgroundColors = [UIColor.yellow,
                                UIColor.orange,
                                UIColor.red,
                                UIColor.green,
                                UIColor.magenta,
                                UIColor.purple,
                                UIColor.cyan,
                                UIColor.blue]
        
        let randomNumber = 2
        backgroundColor = backgroundColors[randomNumber]
        
        // add label based on size
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.text = labelString
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Heavy", size: 23)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
