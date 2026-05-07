//
//  DateHelper.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-07.
//


import Foundation

struct DateHelper {
    static func daysBetween(_ first: Date, second: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: first)
        let end = calendar.startOfDay(for: second)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }
}