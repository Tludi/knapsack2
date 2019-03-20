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
    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.alpha = 1.0
    }, completion: nil)
  }
  
  func fadeOut() {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
      self.alpha = 0.0
      }, completion: nil)
  }
  
  func flash() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.alpha = 0.0
      }, completion: {
        
        (finished: Bool) -> Void in

        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
        self.alpha = 1.0
          }, completion: nil)
    })
  }
}
