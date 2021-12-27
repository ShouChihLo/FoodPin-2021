//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by 羅壽之 on 2021/12/27.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton!

    //var walkthroughPageViewController: PageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

   

}
