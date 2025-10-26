//
//  SplashView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 16) {
                Image("book") // or "JournalIcon" if you have that
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("Journali")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Your thoughts, your story")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
        }
        .overlay(NavigationStarter())
    }
}

private struct NavigationStarter: View {
    @State private var showHome = false
    var body: some View {
        Color.clear
            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showHome = true } }
            .fullScreenCover(isPresented: $showHome) { HomeView() }
    }
}

#Preview {
    SplashView().preferredColorScheme(.dark)
}

