//
//  WaterImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/9/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class WaterImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "flatwater"))
        self.image = UIImage(named: "flatwater")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "WaterImage"
    }
    
}
