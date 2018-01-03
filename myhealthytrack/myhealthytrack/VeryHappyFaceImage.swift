//
//  VeryHappyFaceImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/12/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class VeryHappyFaceImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "veryhappyface"))
        self.image = UIImage(named: "veryhappyface")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "VeryHappyFaceImage"

    }
    
}


