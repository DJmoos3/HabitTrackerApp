//
//  HabitView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftUI
import SwiftData

struct HabitView: View {
    @Environment(\.modelContext) private var context
    var user: User
    @State private var newHabitName = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
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

            List {
                ForEach(user.dailyHabits) { habit in
                    Text(habit.name)
                }
                .onDelete { offsets in
                    user.removeHabit(at: offsets)
                }
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
