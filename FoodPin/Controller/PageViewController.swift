//
//  PageViewController.swift
//  FoodPin
//
//  Created by 羅壽之 on 2021/12/27.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide", "Search and locate your favourite restaurant on Maps", "Find restaurants shared by your friends and other foodies"]
    
    var currentIndex = 0

    //weak var walkthroughDelegate: PageIndexDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

   

}
