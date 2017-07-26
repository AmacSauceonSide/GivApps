//
//  SlidesPageViewController.swift
//  GivDapps
//
//  Created by Guillermo Colin on 7/25/17.
//  Copyright © 2017 GivDapps. All rights reserved.
//

import UIKit




class SlidesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.delegate = self
        self.dataSource = self
        self.view.backgroundColor = UIColor.white
        
        if let firstVC = SlideViewControllerArray.first{
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    
    
    
    lazy var SlideViewControllerArray:[UIViewController] = {
        return[
            self.slideVCInstance(name: "introSlide1VC"),
            self.slideVCInstance(name: "introSlide2VC"),
            self.slideVCInstance(name: "introSlide3VC"),
            self.slideVCInstance(name: "introSlide4VC"),
        ]
    }()
    
    private func slideVCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }

    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = SlideViewControllerArray.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < SlideViewControllerArray.count else {
            
            return nil
        }
        
        
        return SlideViewControllerArray[nextIndex]
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = SlideViewControllerArray.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return SlideViewControllerArray.last
        }
        
        guard SlideViewControllerArray.count > previousIndex else {
            return nil
        }
        
        return SlideViewControllerArray[previousIndex]
    }
    
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return SlideViewControllerArray.count
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = SlideViewControllerArray.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
