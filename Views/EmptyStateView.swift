//
//  EmptyStateView.swift
//  journalApp88
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("open")
                .font(.system(size: 72))
                .foregroundStyle(.secondary)

            Text("Begin Your Journal")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)

            Text("Craft your personal diary — tap the plus to begin.")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
        .preferredColorScheme(.dark)
}

