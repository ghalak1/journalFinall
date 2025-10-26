//
//  Untitled.swift
//  journal1
//
//  Created by ghala alismael on 04/05/1447 AH.
//
//
//  EntryRow.swift
//  journalApp88
//

import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry
    var onBookmark: () -> Void

    private enum UI {
        // ===== Card + Typography =====
        static let corner: CGFloat    = 30
        static let padH: CGFloat      = 22
        static let padTop: CGFloat    = 6
        static let padBottom: CGFloat = 16
        static let titleSize: CGFloat = 24
        static let bodySize: CGFloat  = 17
        static let glyphSize: CGFloat = 20
        static let minHeight: CGFloat = 176

        // ===== Text Rhythm =====
        static let titleDateSpacing: CGFloat = 2
        static let bodyTopSpacing: CGFloat   = 12
        static let titleRowOffsetY: CGFloat  = -24  // keeps title hugging top

        // ===== Bookmark (Perfect corner alignment) =====
        static let trailingReserve: CGFloat       = 70
        static let bookmarkHit: CGFloat           = 36
        static let bookmarkTopInset: CGFloat      = -20
        static let bookmarkTrailingInset: CGFloat = 9
    }

    // Colors (بدون Assets)
    private let lavender = Color(red: 0.83, green: 0.78, blue: 1.00) // D4C8FF تقريبًا
    private let cardBase = Color(red: 35/255, green: 35/255, blue: 40/255)
    private let dateGray = Color.white.opacity(0.60)

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // ===== TEXT CONTENT =====
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: UI.titleDateSpacing) {
                        Text(entry.title.isEmpty ? "My Journal" : entry.title)
                            .font(.system(size: UI.titleSize, weight: .semibold, design: .rounded))
                            .foregroundStyle(lavender)

                        // لا نستخدم DateFormatter – نستخدم API الحديث
                        Text(entry.date.formatted(date: .numeric, time: .omitted))
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(dateGray)
                    }
                    Spacer(minLength: 0)
                }
                .offset(y: UI.titleRowOffsetY)

                Text(preview(entry.body))
                    .font(.system(size: UI.bodySize))
                    .foregroundStyle(.white)
                    .lineSpacing(3)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, UI.bodyTopSpacing)
            }
            .padding(.leading, UI.padH)
            .padding(.trailing, UI.padH + UI.trailingReserve)
            .padding(.top, UI.padTop)
            .padding(.bottom, UI.padBottom)

            // ===== BOOKMARK BUTTON =====
            Button(action: onBookmark) {
                Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: UI.glyphSize, weight: .semibold))
                    .foregroundStyle(lavender)
                    .frame(width: UI.bookmarkHit, height: UI.bookmarkHit)
                    .contentShape(Rectangle())
            }
            .padding(.top, UI.bookmarkTopInset)
            .padding(.trailing, UI.bookmarkTrailingInset)
            .buttonStyle(.plain)
        }

        // ===== CARD =====
        .frame(maxWidth: .infinity, minHeight: UI.minHeight, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [cardBase.opacity(0.96), cardBase.opacity(0.86)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 0.8)
        )
        .shadow(color: .black.opacity(0.45), radius: 18, x: 0, y: 8)
        .contentShape(Rectangle())
    }

    // ===== HELPERS =====
    private func preview(_ text: String) -> String {
        text.isEmpty
        ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque volutpat mattis eros."
        : text
    }
}

#Preview {
    EntryRow(
        entry: JournalEntry(
            title: "My Birthday",
            body: "Had cake with friends 🎂",
            isBookmarked: true
        )
    ) { }
    .padding(.horizontal, 20)
    .preferredColorScheme(.dark)
}

