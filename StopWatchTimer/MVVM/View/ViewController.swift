//
//  ViewController.swift
//  StopWatchTimer
//com.app.StopWatchTimer.StopWatchTimer
//  Created by Saravana on 28/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    //var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var bgtask = 0
    var timer = Timer()
    var fractions: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    
    var lapRecorded: String = ""
    
    var timerStarted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    @IBAction func startButtonTabbed(_ sender: Any) {
        if timerStarted == false {
            
            if bgtask == 0 {
                bgtask = 1
                //registerBackgroundTask()
            }
            timerStarted = true
            
            inBackground()
            
            startButton.isEnabled = false
            resetButton.isEnabled = true
            pauseButton.isEnabled = true
        }
    }
    
    @IBAction func pauseButtonTabbed(_ sender: Any) {
        if timerStarted == true {
            timerStarted = false
            timer.invalidate()
            pauseButton.isEnabled = false
            startButton.isEnabled = true
            resetButton.isEnabled = true
            
            if bgtask == 1{
                //endBackgroundTask()
                bgtask = 0
            }
        }
    }
    
    @IBAction func resetbuttonTabbed(_ sender: Any) {
        
        timer.invalidate()
        
         fractions = 0
         seconds = 0
         minutes = 0
        
         timerStarted = false
        
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
        
        timerLabel.text = "00:00.00"
        
        if bgtask == 1{
            //endBackgroundTask()
            bgtask = 0
        }
    }
    
}

extension ViewController {
    
    func initialLoads(){
        
        titleLabel.text = "Stop Timer"
        pauseButton.setTitle("Pause", for: .normal)
        startButton.setTitle("Start", for: .normal)
        resetButton.setTitle("Reset", for: .normal)
        startButton.setBorder()
        pauseButton.setBorder()
        resetButton.setBorder()
        
        pauseButton.isEnabled = false
        startButton.isEnabled = true
        resetButton.isEnabled = false
        
    }
    
    func inBackground() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        fractions += 1
        
        if fractions == 100 {
            fractions = 0
            seconds += 1
        }
        
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        
        
        let fracStr: String = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secStr: String = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minStr: String = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        timerLabel.text = "\(minStr):\(secStr).\(fracStr)"
    }
    
}
