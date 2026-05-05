//
//  Habit.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftData
import Foundation

@Model
class Habit {
    var id: UUID
    var name: String
    var isCompleted: Bool
    
    init(name: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isCompleted = isCompleted
    }
}
