//
//  ViewController.swift
//  Bop
//
//  Created by Tanvir Pathan on 2016-01-30.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var counter = 0;
    var gameScore = 0;
    var high = 0;
    var random = 0;
    var timer = NSTimer()
    
    @IBOutlet weak var counterField: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    
    @IBOutlet weak var highScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("val") != nil{
            high = NSUserDefaults.standardUserDefaults().objectForKey("val") as! Int
            highScore.text = "Highscore: \(high)"
        }
        
        //let stringKey = NSUserDefaults.standardUserDefaults()
        //highScore.text = stringKey.stringForKey("saveStringKey")
        
    }
    
    @IBAction func start(sender: UIButton) {
        timer.invalidate()
        randomGen()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.12, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        gameStatus.text = "You are doing great!"
    }
   
    
    //Game Buttons
    @IBAction func end(sender: AnyObject) {
        if random != 1{
            gameFailed()
        }
        counter = 0;
        gameScore++;
        randomGen()
    }
    
    @IBAction func end2(sender: AnyObject) {
        if random != 2{
            gameFailed()
        }
        counter = 0;
        gameScore++;
        randomGen()
    }
    
    @IBAction func end3(sender: AnyObject) {
        if random != 3{
            gameFailed()
        }
        counter = 0;
        gameScore++;
        randomGen()
    }
    
    @IBAction func end4(sender: AnyObject) {
        if random != 4{
            gameFailed()
        }
        counter = 0;
        gameScore++;
        randomGen()
    }
    
    @IBOutlet weak var ranNumLabel: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomGen(){
        random = Int(arc4random_uniform(UInt32(5)))
        if random == 0{
            random++;
        }
    }
    func timerAction(){
        
        counterField.text = "\(counter)"
        ranNumLabel.text = "\(random)"
        if counter >= 7 {
            gameFailed()
        }
        ++counter
        
    }
    
    func gameFailed(){
        
        if gameScore > high {
            high = gameScore;
            
            
            NSUserDefaults.standardUserDefaults().setObject(high, forKey: "val")
            NSUserDefaults.standardUserDefaults().synchronize()
            print("updated")
            highScore.text = "Highscore: \(high)"
            
    
           var alert = UIAlertController(title: "NEW HIGHSCORE!", message: "This has been saved.", preferredStyle: UIAlertControllerStyle.Alert)
           alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
           self.presentViewController(alert, animated: true, completion: nil)
        }
        gameStatus.text = "Score: \(gameScore)"
        gameScore = 0
        timer.invalidate()
        counter = -1;
        counterField.text = "\(counter + 1)"
        ranNumLabel.text = "~"
    }


}

