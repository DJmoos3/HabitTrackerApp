//
//  HabitView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftData
import SwiftUI

struct HabitView: View {
    @Environment(\.modelContext) private var context
    var user: User
    @State private var newHabitName = ""
    
    
    // this is only for testing so the streak is added correctly and works
    private var lastSevenDays: [Date] {
        (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: Date())
        }
    }
    //

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                //this part is where the habit is written down and added
                TextField("New habit...", text: $newHabitName)
                    .font(.title2.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(height: 55)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray, lineWidth: 2)
                    )

                Button(action: addHabit) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipped()
                }
                .disabled(
                    newHabitName.trimmingCharacters(in: .whitespaces).isEmpty
                )
            }
            .padding(.horizontal)
            
            // Debug streak section to be removed
            
            Button("Reset debug data") {
                user.completedDaysData = ""
                user.dailyStreak = 0
                user.lastCompletedDate = nil
                try? context.save()
            }
            .foregroundColor(.red)
            
                      VStack(alignment: .leading, spacing: 8) {
                          Text("DEBUG — Toggle completed days")
                              .font(.caption)
                              .foregroundColor(.gray)
                          Text("Streak: \(user.dailyStreak) | Completed days: \(user.completedDaysData)")
                              .font(.caption)
                              .foregroundColor(.gray)

                          ScrollView(.horizontal) {
                              HStack {
                                  ForEach(lastSevenDays, id: \.self) { date in
                                      let completed = user.wasCompleted(on: date)
                                      Button(action: {
                                          user.toggleCompletedDay(date)
                                          user.recalculateStreak()
                                          try? context.save()
                                      }) {
                                          VStack {
                                              Text(date.formatted(.dateTime.day().month()))
                                                  .font(.caption)
                                              Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                                                  .foregroundColor(completed ? .green : .gray)
                                          }
                                          .padding(8)
                                          .background(Color.gray.opacity(0.1))
                                          .cornerRadius(8)
                                      }
                                      .buttonStyle(PlainButtonStyle())
                                  }
                              }
                          }
                      }
                      .padding(.horizontal)
            //end of debug
            
            
            //Creates the list of habits and so forth
            List {
                ForEach(user.dailyHabits) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Button(action: {
                            habit.isCompleted.toggle()
                            try? context.save()
                        }) {
                            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(habit.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } 
                .onDelete { offsets in
                    offsets.sorted().reversed().forEach { index in
                        let habit = user.dailyHabits[index]
                        context.delete(habit)  // This removes the habit from the SwiftData memory
                        //user.dailyHabits.remove(at: index)  // And this removes from the list in the UI and from the user
                    }
                    try? context.save()
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }

    //adds new habit and then removes text from the text field
    func addHabit() {
        let trimmed = newHabitName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let habit = Habit(name: trimmed)
        context.insert(habit)
        user.addHabit(habit)
        try? context.save()
        newHabitName = ""
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    let user = User(name: "Isaac", dailyStreak: 0)
    container.mainContext.insert(user)
    return HabitView(user: user)
        .modelContainer(container)
}
