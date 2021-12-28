//
//  PageViewController.swift
//  FoodPin
//
//  Created by 羅壽之 on 2021/12/27.
//

import UIKit

protocol PageIndexDelegate: AnyObject {
    func didUpdatePageIndex(currentIndex: Int)
}

class PageViewController: UIPageViewController {
    
    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide", "Search and locate your favourite restaurant on Maps", "Find restaurants shared by your friends and other foodies"]
    
    var currentIndex = 0

    // Reference pointer pointed to the walkthrough view controller
    weak var walkthroughDelegate: PageIndexDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self

        // Show the first page by default
        if let startingViewController = contentViewController(at: 0) {
        setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

    }
    
    func contentViewController(at index: Int) -> ContentViewController? {
        // page index range check
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController {
            
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    // triggered by the next button
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    

}


extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //get the current page index
        var index = (viewController as! ContentViewController).index
        index -= 1   // get the previous page index
        
        return contentViewController(at: index)  //Create a contentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
}


// capture the page change events
extension PageViewController: UIPageViewControllerDelegate {
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? ContentViewController {
                
                // update the current page index after the page change is done
                currentIndex = contentViewController.index
                // update the page indicator (controll)
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
            
        }
    }

}
    
