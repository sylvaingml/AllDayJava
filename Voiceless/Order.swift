//
//  Order.swift
//  AllDayJava
//
//  Created by Sylvain on 02/05/2017.
//  Copyright © 2017 S.G. inTech. All rights reserved.
//

import Foundation


enum DrinkType {
    case Expresso(String, Float)
    case Americano(String, Float)
    case Cappuccino(String, Float)
}

enum BakeType {
    case Cookie
    case Muffin
    case Scone
}


class Catalog {
    var drink: [DrinkType]
    
    init() {
        drink = [
            .Expresso("Expresso", 2.5),
            .Americano("Café Américain", 3.5),
            .Cappuccino("Cappuccino", 5.0)
        ]
    }
}


struct Order {
    public var date: Date?
    public var drinkType: DrinkType?
    public var bakery: [BakeType: Int] = [:]
}

