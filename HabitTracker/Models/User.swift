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
    var lastCompletedDate: Date?
    var completedDaysData: String
    
    init(name: String, dailyHabits: [Habit] = [], dailyStreak: Int = 0) {
        self.id = UUID()
        self.name = name
        self.dailyHabits = dailyHabits
        self.dailyStreak = dailyStreak
        self.lastCompletedDate = nil
        self.completedDaysData = ""
    }
    
    // string -> date
    var completedDays: [Date] {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return completedDaysData
                .split(separator: ",")
                .compactMap { formatter.date(from: String($0)) }
        }
    }
    
    // adds a string value of a date in said format
    private func addCompletedDay(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        if completedDaysData.isEmpty {
            completedDaysData = dateString
        } else {
            completedDaysData += ",\(dateString)"
        }
    }
    
    func addHabit(_ habit: Habit) {
        dailyHabits.append(habit)
    }

    func checkAndUpdateStreak() {
        guard !dailyHabits.isEmpty else { return }
        let allCompleted = dailyHabits.allSatisfy { $0.isCompleted }
        guard allCompleted else { return }
        
        let today = Date()
        
        if !completedDays.contains(where: { isSameDay($0, today) }) {
            addCompletedDay(today)
        }
        
        if let lastDate = lastCompletedDate {
            let days = DateHelper.daysBetween(lastDate, second: today)
            if days == 1 {
                dailyStreak += 1
            } else if days == 0 {
                return
            } else {
                dailyStreak = 1
            }
        } else {
            dailyStreak = 1
        }
        lastCompletedDate = today
    }
    
    func resetDailyHabits() {
        let today = Date()
        if let lastDate = lastCompletedDate {
            let days = DateHelper.daysBetween(lastDate, second: today)
            if days > 1 {
                dailyStreak = 0
            }
        }
        dailyHabits.forEach { $0.isCompleted = false }
    }
    
    func wasCompleted(on date: Date) -> Bool {
        completedDays.contains(where: { isSameDay($0, date) })
    }
    
    private func isSameDay(_ first: Date, _ second: Date) -> Bool {
        Calendar.current.isDate(first, inSameDayAs: second)
    }
    
    //Only used for Debugging and checking if the streak works or not
    func toggleCompletedDay(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        var days = completedDaysData.isEmpty ? [] : completedDaysData.split(separator: ",").map(String.init)
        
        if days.contains(dateString) {
            days.removeAll { $0 == dateString }
        } else {
            days.append(dateString)
        }
        completedDaysData = days.joined(separator: ",")
    }
    
    // Recalculates streak from scratch based on completedDaysData
    func recalculateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        // Sort completed days oldest to newest
        let sortedDays = completedDays.sorted()
        guard !sortedDays.isEmpty else {
            dailyStreak = 0
            return
        }

        // Count consecutive days ending today or yesterday
        var streak = 1
        for i in stride(from: sortedDays.count - 1, through: 1, by: -1) {
            let days = DateHelper.daysBetween(sortedDays[i - 1], second: sortedDays[i])
            if days == 1 {
                streak += 1
            } else {
                break
            }
        }

        // Streak only counts if the last completed day is today or yesterday
        let today = Calendar.current.startOfDay(for: Date())
        let lastDay = Calendar.current.startOfDay(for: sortedDays.last!)
        let daysSinceLast = DateHelper.daysBetween(lastDay, second: today)

        dailyStreak = daysSinceLast <= 1 ? streak : 0
    }
}
