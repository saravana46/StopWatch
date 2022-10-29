//
//  StopViewModel.swift
//  StopWatchTimer
//
//  Created by Saravana on 29/10/22.
//

import Foundation

protocol StopViewModelDelegate: class{
    func startWatch(start: Bool)
    func pauseWatch(start: Bool)
    func resetWatch(start: Bool)
}

class StopViewModel {
    
    var delegate : StopViewModelDelegate?
    
    func startWatch(start: Bool?){
        self.delegate?.startWatch(start: start ?? true)
    }
    
    func pauseWatch(start: Bool?){
        self.delegate?.pauseWatch(start: start ?? true)
    }
    
    func resetWatch(start: Bool?){
        self.delegate?.resetWatch(start: start ?? true)
    }
    
}
