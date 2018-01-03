//
//  FruitImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class FruitImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "flatfruit"))
        self.image = UIImage(named: "flatfruit")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "FruitImage"

    }
}
