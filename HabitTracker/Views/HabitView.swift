//
//  HabitView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-05-01.
//

import SwiftUI

struct HabitView: View {
    @State private var habits: [Habit] = []
    @State private var newHabitName: String = ""

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

            List(habits) { habit in
                Text(habit.name)
            }
        }
        .padding(.top)
    }

    func addHabit() {
        //adds new habit and removes text from the text field
        let trimmed = newHabitName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let newHabit = Habit(id: UUID(), name: trimmed, isCompleted: false)
        habits.append(newHabit)
        newHabitName = ""
    }
}

#Preview {
    HabitView()
}
