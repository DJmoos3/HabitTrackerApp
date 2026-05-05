//
//  ContentView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-04-28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query private var users: [User]
    @Environment(\.modelContext) private var context

    private var user: User? { users.first }

    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink(destination: CalendarView()) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipped()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
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
                    Text("Welcome back \(user.name), today is Friday the 1st of May")
                    Text("You're on a streak of \(user.dailyStreak) days!")
                    Text("These are your tasks for today!")
                    List(user.dailyHabits) { habit in
                        Text(habit.name)
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding()
            .onAppear {
                if users.isEmpty {
                    let newUser = User(name: "Isaac", dailyStreak: 0)
                    context.insert(newUser)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
