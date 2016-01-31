//
//  ShowSplashScreen.swift
//  Bop
//
//  Created by Tanvir Pathan on 2016-01-31.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

import UIKit

class ShowSplashScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(Selector("showNavController"), withObject: nil, afterDelay: 2)
    }
    
    func showNavController()
    {
        performSegueWithIdentifier("showSplashScreen", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
