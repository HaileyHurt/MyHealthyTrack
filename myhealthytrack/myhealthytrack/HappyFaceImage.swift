//
//  VeryHappyFaceImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class HappyFaceImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "happyface"))
        self.image = UIImage(named: "happyface")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "HappyFaceImage"

    }
    
}

