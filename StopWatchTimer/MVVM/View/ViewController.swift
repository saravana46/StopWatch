//
//  ViewController.swift
//  StopWatchTimer
//
//  Created by Saravana on 28/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
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
    var watchlist : watchModel?
    var stopViewModel = StopViewModel()
    
    var timerStarted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        stopViewModel.delegate = self
        initialLoads()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @IBAction func startButtonTabbed(_ sender: Any) {
        watchlist = watchModel()
        watchlist?.start = true
        if let start = watchlist {
            stopViewModel.startWatch(start: start.start)
        }
    }
    
    @IBAction func pauseButtonTabbed(_ sender: Any) {
        watchlist = watchModel()
        watchlist?.start = true
        if let start = watchlist {
            stopViewModel.pauseWatch(start: start.start)
        }
    }
    
    @IBAction func resetbuttonTabbed(_ sender: Any) {
        watchlist = watchModel()
        watchlist?.start = true
        if let start = watchlist {
            stopViewModel.resetWatch(start: start.start)
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
    
    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        
        if timerStarted{
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBgTimer), userInfo: nil, repeats: true)
        }
    }
    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        
        if timerStarted{
            inBackground()
        }
        
    }
    
    func inBackground() {
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateBgTimer(){
        self.updateTimer(true)
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
    
    func endBackgroundTask() {
        
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
    @objc func updateTimer(_ bgRun:Bool = false){
        
        if !bgRun{
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
            
        }else{
            
            seconds += 1
            if seconds == 60 {
                seconds = 0
                minutes += 1
            }
            
            let fracStr: String = fractions > 9 ? "\(fractions)" : "0\(fractions)"
            let secStr: String = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            let minStr: String = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            
            timerLabel.text = "\(minStr):\(secStr).\(fracStr)"
            
            
        }
        print(timerLabel.text)
    }
    
}

extension ViewController: StopViewModelDelegate {
    func pauseWatch(start: Bool) {
        if start {
            if timerStarted == true {
                timerStarted = false
                timer.invalidate()
                pauseButton.isEnabled = false
                startButton.isEnabled = true
                resetButton.isEnabled = true
                
                if bgtask == 1{
                    endBackgroundTask()
                    bgtask = 0
                }
            }
        }
    }
    
    func resetWatch(start: Bool) {
        if start{
            timer.invalidate()
            
            fractions = 0
            seconds = 0
            minutes = 0
            
            timerStarted = false
            
            startButton.isEnabled = true
            pauseButton.isEnabled = false
            resetButton.isEnabled = false
            
            timerLabel.text = "00:00:00"
            
            if bgtask == 1{
                endBackgroundTask()
                bgtask = 0
            }
        }
    }
    
    func startWatch(start: Bool) {
        if start {
            if timerStarted == false {
                
                if bgtask == 0 {
                    bgtask = 1
                    registerBackgroundTask()
                }
                timerStarted = true
                
                inBackground()
                
                startButton.isEnabled = false
                resetButton.isEnabled = true
                pauseButton.isEnabled = true
            }
        }
    }
}
