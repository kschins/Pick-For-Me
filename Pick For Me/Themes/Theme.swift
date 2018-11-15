//
//  Theme.swift
//  Pick For Me
//
//  Created by Kasey Schindler on 10/26/18.
//  Copyright © 2018 Kasey Schindler. All rights reserved.
//

import UIKit

protocol Theme {
    /// the color for the background and text
    var primaryColor: UIColor { get }
    
    /// the color for the bottom buttons
    var buttonColor: UIColor { get }
    
    /// the color for the cell background of an option
    var cellColor: UIColor { get }
}
