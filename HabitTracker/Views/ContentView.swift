//
//  ContentView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-04-28.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    @Query private var users: [User]
    @Environment(\.modelContext) private var context

    private var user: User? { users.first }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    //takes yiou to the CalendarView
                    if let user {
                        @Bindable var user = user
                        NavigationLink(destination: CalendarView(user: user)) {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipped()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    //takes you to the HabitView
                    if let user {
                        NavigationLink(destination: HabitView(user: user)) {
                            Image(systemName: "list.bullet.clipboard")
                                .resizable()
                                .frame(width: 70, height: 75)
                                .clipped()
                                .offset(y: -2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                if let user {
                    Text(
                        "Welcome back \(user.name), today is \(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))"
                    )
                    Text("You're on a streak of \(user.dailyStreak) days!")
                    Text("These are your tasks for today!")

                    //was used for debugging to know how the everthing was affected and used
                    Text("Streak: \(user.dailyStreak)")
                    Text("Completed days: \(user.completedDays.count)")
                    Text(
                        "All habits done: \(user.dailyHabits.allSatisfy { $0.isCompleted }.description)"
                    )
                    List(user.dailyHabits) { habit in
                        Text(habit.name)
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding()
            //this checks whether there is a user or not and creates one in case there isn't which is needed for the code to work
            //otherwise it will just have the ProgressView with loading
            .onAppear{
                if users.isEmpty {
                    let newUser = User(name: "Isaac", dailyStreak: 0)
                    context.insert(newUser)
                    try? context.save()
                } else {
                    if let lastDate = user?.lastCompletedDate {
                        let days = DateHelper.daysBetween(
                            lastDate,
                            second: Date()
                        )
                        if days >= 1 {
                            user?.resetDailyHabits()
                            try? context.save()
                        }
                    }
                }

            }
        }
    }
}

#Preview {
    ContentView()
}
