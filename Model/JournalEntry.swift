//
//  JournalEntry.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI  // لا نستخدم Foundation

/// Your basic note model (in-memory for now)
struct JournalEntry: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var body: String
    var date: Date
    var isBookmarked: Bool

    init(
        id: UUID = UUID(),
        title: String = "",
        body: String = "",
        date: Date = Date(),
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.isBookmarked = isBookmarked
    }
}

// إذا تبين صيغة قصيرة للتاريخ، استخدمي مباشرة:
// entry.date.formatted(date: .numeric, time: .omitted)

