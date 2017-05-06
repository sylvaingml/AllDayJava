//
//  CoffeeCell.swift
//  AllDayJava
//
//  Created by Sylvain on 03/05/2017.
//  Copyright © 2017 S.G. inTech. All rights reserved.
//

import UIKit


class CoffeeCell: UITableViewCell {
    override var accessibilityElements: [Any]? {
        get {
            return [
                viewWithTag(1) as Any,
                viewWithTag(2) as Any
            ]
        }
        
        set {
            super.accessibilityElements = newValue
        }
    }
}
