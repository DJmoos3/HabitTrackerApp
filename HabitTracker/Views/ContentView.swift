//
//  ContentView.swift
//  HabitTracker
//
//  Created by Isaac Strandh on 2026-04-28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: CalendarView()) {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipped()
                }
                .buttonStyle(PlainButtonStyle())
                .buttonStyle(PlainButtonStyle())
                Text("Today is Friday the 1st of May")
                Text("You're on a streak of 3 days!")
                Text("These are your Tasks for today!")
                List{
                    // Where to put the list of habits of today
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
