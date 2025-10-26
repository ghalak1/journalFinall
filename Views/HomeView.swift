//
//  HomeView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var vm = HomeViewModel(seedWithSamples: true)
    @State private var showEditor = false
    @State private var editingEntry: JournalEntry? = nil
    @State private var showDeleteAlert = false

    // Layout tokens
    private enum UI {
        static let headerTop: CGFloat   = 6
        static let headerSide: CGFloat  = 20
        static let rowSide: CGFloat     = 20
        static let firstRowTop: CGFloat = 17
        static let rowBottom: CGFloat   = 2
        static let pillHPad: CGFloat    = 16
        static let pillVPad: CGFloat    = 10
        static let pillYOffset: CGFloat = -2
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if vm.filteredEntries.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        Section {
                            ForEach(vm.filteredEntries) { entry in
                                EntryRow(entry: entry) {
                                    vm.toggleBookmark(id: entry.id)
                                }
                                .onTapGesture {
                                    editingEntry = entry
                                    showEditor = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        vm.requestDelete(entry)
                                        showDeleteAlert = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .padding(.horizontal, UI.rowSide)
                                .padding(.top, UI.firstRowTop)
                                .padding(.bottom, UI.rowBottom)
                            }

                            // small buffer so last card clears the search bar
                            Color.clear
                                .frame(height: 18)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .listSectionSpacing(.custom(0))
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }

        // Bottom search
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search", text: $vm.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundStyle(.primary)
                    .tint(Color(red: 0.74, green: 0.67, blue: 0.98))
                Image(systemName: "mic.fill").foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.06), lineWidth: 1)
                    .allowsHitTesting(false)
            )
            .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 8)
            .padding(.horizontal, UI.headerSide)
            .padding(.bottom, 8)
        }

        // Delete confirm
        .alert("Delete Journal?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { vm.confirmDelete() }
        } message: {
            Text("Are you sure you want to delete this journal?")
        }

        // Editor
        .sheet(isPresented: $showEditor) {
            EditorView(
                title: editingEntry?.title ?? "",
                content: editingEntry?.body ?? "",
                onSave: { title, content in
                    var updated = editingEntry ?? JournalEntry()
                    updated.title = title
                    updated.body  = content
                    updated.date  = Date()
                    vm.save(updated)
                    showEditor = false
                },
                onCancel: {
                    if let e = editingEntry, e.title.isEmpty && e.body.isEmpty {
                        vm.requestDelete(e); vm.confirmDelete()
                    }
                    showEditor = false
                }
            )
            .presentationDetents([.large])
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("Journal")
                .font(.system(.largeTitle, design: .rounded).bold())
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            // Glass pill controls (بدون GlassHelpers)
            HStack(spacing: 14) {
                Menu {
                    Picker("Sort", selection: $vm.sort) {
                        Text("Sort by Bookmark").tag(HomeSort.byBookmark)
                        Text("Sort by Entry Date").tag(HomeSort.byDate)
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.primary)
                        .accessibilityLabel("Sort")
                }
                .buttonStyle(.plain)

                Button {
                    let new = vm.createEmptyEntry()
                    editingEntry = new
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.primary)
                        .accessibilityLabel("Add Entry")
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, UI.pillVPad)
            .padding(.horizontal, UI.pillHPad)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            )
            .overlay(
                Capsule()
                    .inset(by: 1.5)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.22), .white.opacity(0.05), .clear],
                            startPoint: .top, endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.30), radius: 16, x: 0, y: 10)
            .offset(y: UI.pillYOffset)
        }
        .padding(.top, UI.headerTop)
        .padding(.horizontal, UI.headerSide)
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

