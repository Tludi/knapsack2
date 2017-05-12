//
//  UIViewExtensions.swift
//  knapsack
//
//  Created by manatee on 8/20/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func fadeIn() {
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      self.alpha = 1.0
    }, completion: nil)
  }
  
  func fadeOut() {
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.alpha = 0.0
      }, completion: nil)
  }
  
  func flash() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      self.alpha = 0.0
      }, completion: {
        
        (finished: Bool) -> Void in

        
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        self.alpha = 1.0
          }, completion: nil)
    })
  }
}