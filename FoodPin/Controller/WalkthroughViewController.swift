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

    var walkthroughPageViewController: PageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    // MARK: - Action methods

    @IBAction func skipButtonTapped(sender: UIButton) {
        //UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
                
            case 2:
                //UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default: break
                
            }
        }
        
        updateUI()
    }
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
            default: break
            }
            
            pageControl.currentPage = index
        }
    }
     
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? PageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
        
}


extension WalkthroughViewController: PageIndexDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
}
