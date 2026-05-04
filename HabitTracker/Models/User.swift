//
//  User.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    var id = UUID()
    var name: String
    var dailyHabits: [Habit]
    var dailyStreak: Int
    
    
    mutating func addHabit(_ habit: Habit) {
        dailyHabits.append(habit)
    }

    mutating func removeHabit(at offsets: IndexSet) {
        dailyHabits.remove(atOffsets: offsets)
    }
}
