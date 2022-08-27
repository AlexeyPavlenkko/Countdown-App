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
    private var second = Box(0)
    
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
}
