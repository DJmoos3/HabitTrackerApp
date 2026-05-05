//
//  CalendarView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftUI

struct CalendarView: View {
    let currentDate = Date()
    let calendar = Calendar.current

    private var monthTitle: String {
        currentDate.formatted(.dateTime.day().month(.wide).year())
    }

    //Uses the current date to go through this months days to see which weekday it is
    //It also changes so the calendar doesn't start on sunday but rather monday
    private var firstWeekdayOfMonth: Int {
        var components = DateComponents()
        components.year = calendar.component(.year, from: currentDate)
        components.month = calendar.component(.month, from: currentDate)
        components.day = 1
        let firstDay = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstDay)
        return (weekday + 5) % 7 
    }

    private var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentDate)!.count
    }

    private var today: Int {
        calendar.component(.day, from: Date())
    }

    private var isCurrentMonth: Bool {
        calendar.isDate(currentDate, equalTo: Date(), toGranularity: .month)
    }

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack(spacing: 30) {
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.gray)
                }
            }

            // Creates a grid of days to be visible onscreen
            LazyVGrid(columns: columns, spacing: 8) {

                ForEach(0..<(firstWeekdayOfMonth + daysInMonth), id: \.self) {
                    index in
                    if index < firstWeekdayOfMonth {
                        // makes the colour of non current days into clear
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .frame(height: 45)
                    } else {
                        // And this makes the current day into blue with a white number
                        let day = index - firstWeekdayOfMonth + 1
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    isCurrentMonth && day == today
                                        ? Color.blue
                                        : Color.gray.opacity(0.2)
                                )
                                .frame(height: 45)

                            Text("\(day)")
                                .font(.callout)
                                .bold(isCurrentMonth && day == today)
                                .foregroundColor(
                                    isCurrentMonth && day == today
                                        ? .white
                                        : .primary
                                )
                        }
                    }
                }
            }
            .padding(2)

            Spacer()
        }
        .padding(.top, 50)
    }
}

#Preview {
    CalendarView()
}
