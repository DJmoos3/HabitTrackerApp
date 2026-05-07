//
//  CalendarView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    var user: User
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
        VStack(spacing: 30) { //LaztVGrid is for a big vertically scrollable collection of views arranged in a two dimensional layout.
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.gray)
                }
            }

            // Creates a grid of days to be visible onscreen
            LazyVGrid(columns: columns, spacing: 4) {
                       ForEach(0..<(firstWeekdayOfMonth + daysInMonth), id: \.self) { index in
                           if index < firstWeekdayOfMonth {
                               RoundedRectangle(cornerRadius: 8)
                                   .fill(Color.clear)
                                   .frame(height: 45)
                           } else {
                               let day = index - firstWeekdayOfMonth + 1
                               let date = dateFor(day: day)
                               let isToday = isCurrentMonth && day == today
                               let isPast = date < calendar.startOfDay(for: Date())
                               let completed = user.wasCompleted(on: date)

                               ZStack {
                                   RoundedRectangle(cornerRadius: 8)
                                       .fill(dayColor(isToday: isToday, isPast: isPast, completed: completed))
                                       .frame(height: 45)

                                   Text("\(day)")
                                       .font(.callout)
                                       .bold(isToday)
                                       .foregroundColor(isToday || (isPast && completed) ? .white : .primary)
                               }
                           }
                       }
                   }
                   .padding(.horizontal)

                   Spacer()
               }
               .padding(.top)
               .navigationTitle("Calendar")
           }
           func dateFor(day: Int) -> Date {
               var components = DateComponents()
               components.year = calendar.component(.year, from: currentDate)
               components.month = calendar.component(.month, from: currentDate)
               components.day = day
               return calendar.date(from: components) ?? Date()
           }
    //makes the days either red or green if habits have been made and blue for today
           func dayColor(isToday: Bool, isPast: Bool, completed: Bool) -> Color {
               if isToday { return .blue }
               if isPast && completed { return .green }
               if isPast && !completed { return .red }
               return Color.gray.opacity(0.2)
           }

}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    let user = User(name: "Isaac", dailyStreak: 3)
    container.mainContext.insert(user)
    return CalendarView(user: user)
        .modelContainer(container)
}
