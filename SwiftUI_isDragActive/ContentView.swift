//
//  ContentView.swift
//  SwiftUI_isDragActive
//
//  Created by Chuck Hartman on 11/11/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selection = Set<Node>()
    @FocusState private var isListFocused: Bool
    @State private var isDragActive = false  // <<<<
    var body: some View {
        VStack {
            List(nodes, id: \.self , children: \.children, selection: self.$selection) { node in
                NodeView(node: node)
            }
            .focused($isListFocused)
            Text("isDragActive: \(isDragActive.description)")
        }
        .dropDestination(for: Node.self) { _, _ in
            return false
        } isTargeted: { isDragActive = $0 }   // <<<<
        .onChange(of: isDragActive) { _, newValue in
            if newValue == true {
                print("Drag started")
                isListFocused = false
            }
            if newValue == false {
                print("Drag ended")
                isListFocused = true
            }
        }
        .environment(\.isDragActive, $isDragActive)  // <<<<
    }
}

struct NodeView: View {
    var node: Node
    @State private var isTargeted = false
    @Environment(\.isDragActive) private var isDragActive  // <<<<
    var body: some View {
        Text(node.name)
            .listRowBackground(RoundedRectangle(cornerRadius: 5, style: .circular)
                .padding(.horizontal, 10)
                .foregroundColor(isTargeted ? Color(nsColor: .selectedContentBackgroundColor) : Color.clear)
            )
            .draggable(node)
            .dropDestination(for: Node.self) { droppedNodes, _ in
                for droppedNode in droppedNodes {
                    print("\(droppedNode.name) dropped on: \(node.name)")
                }
                return true
            } isTargeted: {
                isTargeted = $0
                isDragActive.wrappedValue = $0  // <<<<
            }
    }
}

struct DragActive: EnvironmentKey {  // <<<<
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isDragActive: Binding<Bool> {  // <<<<
        get { self[DragActive.self] }
        set { self[DragActive.self] = newValue }
    }
}

let nodes: [Node] = [
    .init(name: "Clothing", children: [
        .init(name: "Hoodies"), .init(name: "Jackets"), .init(name: "Joggers"), .init(name: "Jumpers"),
        .init(name: "Jeans", children: [.init(name: "Regular", children: [.init(name: "Size 34"), .init(name: "Size 32"), ] ), .init(name: "Slim") ] ), ] ),
    .init(name: "Shoes", children: [.init(name: "Boots"), .init(name: "Sandals"), .init(name: "Trainers"), ] ),
    .init(name: "Socks", children: [.init(name: "Crew"), .init(name: "Dress"), .init(name: "Athletic"), ] ),
]

struct Node: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var children: [Node]? = nil
}

extension Node: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .node)
    }
}

extension UTType {
    // Add a "public.data" Exported Type Identifier for this on the Info tab for the Target's Settings
    static var node: UTType { UTType(exportedAs: "com.experiment.node") }
}

#Preview {
    ContentView()
}
