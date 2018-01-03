//
//  VeryHappyFaceImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SadFaceImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "sadface"))
        self.image = UIImage(named: "sadface")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "SadFaceImage"

    }
    
}

