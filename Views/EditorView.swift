//
//  EditorView.swift
//  journalApp88
//

import SwiftUI

struct EditorView: View {
    // MARK: - Inputs / callbacks
    let originalTitle: String
    let originalContent: String
    var onSave: (String, String) -> Void
    var onCancel: () -> Void

    // MARK: - State
    @State private var title: String
    @State private var content: String
    @State private var showDiscardAlert = false
    @FocusState private var focus: Field?
    @State private var savePulse = false
    enum Field { case title, content }

    init(title: String, content: String,
         onSave: @escaping (String, String) -> Void,
         onCancel: @escaping () -> Void) {
        self.originalTitle = title
        self.originalContent = content
        self._title = State(initialValue: title)
        self._content = State(initialValue: content)
        self.onSave = onSave
        self.onCancel = onCancel
    }

    private enum UI {
        static let side: CGFloat = 20
        static let topPad: CGFloat = 8
        static let minEditorHeight: CGFloat = 260
        static let controlSize: CGFloat = 36
        static let grabberW: CGFloat = 46
        static let grabberH: CGFloat = 5
    }
    private let lavender = Color(red: 0.74, green: 0.67, blue: 0.98)

    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {

                // Grabber
                HStack {
                    Spacer()
                    Capsule()
                        .fill(.white.opacity(0.20))
                        .frame(width: UI.grabberW, height: UI.grabberH)
                    Spacer()
                }
                .padding(.top, 6)

                // Header
                HStack {
                    Button { attemptCancel() } label: {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 1))
                            .frame(width: UI.controlSize, height: UI.controlSize)
                            .overlay(
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.primary)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button {
                        savePulse.toggle()
                        saveNow()
                    } label: {
                        Circle()
                            .fill(lavender)
                            .frame(width: UI.controlSize, height: UI.controlSize)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.85))
                            )
                            .opacity(canSave ? 1 : 0.45)
                    }
                    .disabled(!canSave)
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, UI.side)
                .padding(.top, UI.topPad)

                // Title
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                        .fill(lavender)
                        .frame(width: 3, height: 28)
                        .padding(.leading, UI.side - 3)

                    TextField("Title", text: $title)
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .foregroundStyle(.primary)
                        .focused($focus, equals: .title)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding(.trailing, UI.side)

                Text(dateString(Date()))
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, UI.side)

                // Body
                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("Type your Journal...")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, UI.side + 2)
                            .padding(.top, 12)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $content)
                        .font(.body)
                        .scrollContentBackground(.hidden)
                        .focused($focus, equals: .content)
                        .frame(minHeight: UI.minEditorHeight)
                        .padding(.horizontal, UI.side)
                        .textInputAutocapitalization(.sentences)
                }

                Spacer(minLength: 0)
            }
        }
        .tint(lavender)
        .alert("Are you sure you want to discard changes on this journal?", isPresented: $showDiscardAlert) {
            Button("Discard Changes", role: .destructive) { onCancel() }
            Button("Keep Editing", role: .cancel) { }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                focus = title.isEmpty ? .title : .content
            }
        }
        .sensoryFeedback(.success, trigger: savePulse)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    private var hasUnsaved: Bool {
        title != originalTitle || content != originalContent
    }
    private func attemptCancel() {
        if hasUnsaved && canSave {
            showDiscardAlert = true
        } else {
            onCancel()
        }
    }
    private func saveNow() {
        onSave(title.trimmingCharacters(in: .whitespacesAndNewlines),
               content.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    private func dateString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: d)
    }
}

#Preview {
    EditorView(title: "", content: "") { _,_ in } onCancel: { }
        .preferredColorScheme(.dark)
}

