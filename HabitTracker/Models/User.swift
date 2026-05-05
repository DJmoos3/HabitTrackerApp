//
//  User.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftData
import Foundation

@Model
class User {
    var id: UUID
    var name: String
    var dailyHabits: [Habit]
    var dailyStreak: Int
    
    init(name: String, dailyHabits: [Habit] = [], dailyStreak: Int = 0) {
        self.id = UUID()
        self.name = name
        self.dailyHabits = dailyHabits
        self.dailyStreak = dailyStreak
    }
    
    func addHabit(_ habit: Habit) {
        dailyHabits.append(habit)
    }

    func removeHabit(at offsets: IndexSet) {
        offsets.sorted().reversed().forEach { index in
            dailyHabits.remove(at: index)
        }
    }
}
