//
//  VegetableImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class VegetableImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "flatveggie"))
        self.image = UIImage(named: "flatveggie")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "VegetableImage"

    }
}
