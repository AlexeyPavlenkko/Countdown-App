//
//  Box.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    
    //MARK: - Variables
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: Listener?
    
    //MARK: - Inits
    
    init(_ value: T) {
        self.value = value
    }
    
    //MARK: - Methods
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func removeBinding() {
        self.listener = nil
    }
}
