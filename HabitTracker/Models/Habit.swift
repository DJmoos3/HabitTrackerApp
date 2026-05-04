//
//  Habit.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import Foundation

struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var isCompleted: Bool
}
