//
//  SegueFromRight.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/23/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit
import QuartzCore

class SegueFromRight: UIStoryboardSegue {
    
    override func perform() {
        // segue slides from right to left
        let src: UIViewController = self.source
        let dst: UIViewController = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        src.navigationController!.view.layer.add(transition, forKey: kCATransition)
        src.navigationController!.pushViewController(dst, animated: false)
    }
}
