//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-04-28.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Habit.self])
    }
}
