//
//  CDTaskViewModel.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.
//

import Foundation

class CDTaskViewModel {
    
    //MARK: - Variables
    
    private var cdtask: CDTask!
    private let taskTypes: [CDTaskType] = [
        CDTaskType(symbolName: "star", typeName: "Priority"),
        CDTaskType(symbolName: "iphone", typeName: "Develop"),
        CDTaskType(symbolName: "gamecontroller", typeName: "Gaming"),
        CDTaskType(symbolName: "wand.and.rays.inverse", typeName: "Editing")
    ]
    
    private var selectedIndex = -1 {
        didSet {
            //set cdtask type here
            cdtask.taskType = taskTypes[selectedIndex]
        }
    }
    
    private var hours = Box(0)
    private var minutes = Box(0)
    private var seconds = Box(0)
    
    //MARK: - Init
    
    init() {
        //sets dummy cdtask model by default
        cdtask = CDTask(name: "", description: "", second: 0, taskType: .init(symbolName: "", typeName: ""), timeStamp: 0)
    }
    
    //MARK: - Methods
    
    func setSelectedIndex(to value: Int) {
        self.selectedIndex = value
    }
    
    func setCDTaskName(to value: String) {
        self.cdtask.name = value
    }
    
    func setCDTaskDescription(to value: String) {
        self.cdtask.description = value
    }
    
    func getSelectedIndex() -> Int {
        self.selectedIndex
    }
    
    func getTask() -> CDTask {
        self.cdtask
    }
    
    func getTaskTypes() -> [CDTaskType] {
        self.taskTypes
    }
    
    func setHours(to value: Int) {
        
        self.hours.value = value
    }
    
    func setMinutes(to value: Int) {
        var newMinutes = value
        
        if value >= 60 {
            newMinutes -= 60
            hours.value += 1
        }
        
        self.minutes.value = newMinutes
    }
    
    func setSeconds(to value: Int) {
        var newSeconds = value
        
        if value >= 60 {
            newSeconds -= 60
            minutes.value += 1
        }
        
        if minutes.value >= 60 {
            minutes.value -= 60
            hours.value += 1
        }
        
        self.seconds.value = newSeconds
    }
    
    func getHours() -> Box<Int> {
        return self.hours
    }
    
    func getMinutes() -> Box<Int> {
        return self.minutes
    }
    
    func getSeconds() -> Box<Int> {
        return self.seconds
    }
    
    func computeSeconds() {
        self.cdtask.second = (hours.value * 3600) + (minutes.value * 60) + seconds.value
        self.cdtask.timeStamp = Date().timeIntervalSince1970
    }
    
    func isTaskValid() -> Bool {
        if !cdtask.name.isEmpty && !cdtask.description.isEmpty && selectedIndex != -1 && (seconds.value > 0 || minutes.value > 0 || hours.value > 0) {
            return true
        }
        return false
    }
    
}
