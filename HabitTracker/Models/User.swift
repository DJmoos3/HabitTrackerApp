//
//  User.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import Foundation

struct User: Identifiable {
    var id: UUID
    var name: String
    var dailyHabits: [Habit]
    var dailyStreak: Int
}
