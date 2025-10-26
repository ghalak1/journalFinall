//
//  Untitled.swift
//  journal1
//
//  Created by ghala alismael on 04/05/1447 AH.
//

//
//  HomeViewModel.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI   // بدّلنا Foundation بـ SwiftUI
import Combine

enum HomeSort: String, CaseIterable {
    case byDate = "Entry Date"
    case byBookmark = "Bookmark"
}

final class HomeViewModel: ObservableObject {

    // State the View reads
    @Published var entries: [JournalEntry] = []
    @Published var searchText: String = ""
    @Published var sort: HomeSort = .byDate
    @Published var showingDeleteConfirmFor: JournalEntry? = nil

    // Derived filtered list
    var filteredEntries: [JournalEntry] {
        var list = entries

        // search
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            list = list.filter {
                $0.title.lowercased().contains(q) || $0.body.lowercased().contains(q)
            }
        }

        // sort
        switch sort {
        case .byDate:
            list = list.sorted { $0.date > $1.date }
        case .byBookmark:
            list = list.sorted {
                if $0.isBookmarked == $1.isBookmarked { return $0.date > $1.date }
                return $0.isBookmarked && !$1.isBookmarked
            }
        }
        return list
    }

    // Seed with a couple examples (set to false for a pure empty state)
    init(seedWithSamples: Bool = false) {
        if seedWithSamples {
            entries = [
                JournalEntry(title: "My Birthday", body: "Had cake with friends 🎂", date: Date().addingTimeInterval(-86400), isBookmarked: true),
                JournalEntry(title: "Today’s Journal", body: "Learned SwiftUI MVVM and Liquid Glass.", date: Date().addingTimeInterval(-86400*2)),
                JournalEntry(title: "Great Day", body: "Walked, studied, and relaxed.", date: Date().addingTimeInterval(-86400*3))
            ]
        }
    }

    // Intents
    func createEmptyEntry() -> JournalEntry {
        let new = JournalEntry()
        entries.insert(new, at: 0)
        return new
    }

    func save(_ entry: JournalEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
        } else {
            entries.insert(entry, at: 0)
        }
    }

    func toggleBookmark(id: UUID) {
        guard let i = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[i].isBookmarked.toggle()
    }

    func requestDelete(_ entry: JournalEntry) {
        showingDeleteConfirmFor = entry
    }

    func confirmDelete() {
        guard let target = showingDeleteConfirmFor else { return }
        entries.removeAll { $0.id == target.id }
        showingDeleteConfirmFor = nil
    }
}
