//
//  ContentView.swift
//  Materials
//
//  Created by Tim on 05.03.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var colorSchemeString = "System"
    @State var selectedTab = 0
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                MaterialsView(colorSchemeString: $colorSchemeString, selectedTab: $selectedTab).navigationTitle("Materials").navigationDocument(URL(string: "https://google.com")!).tabItem{
                    Label("Materials", systemImage: "square.fill")}.tag(0)
                VStack {
                    Form {
                        Text("I don't know what else to add to this App yet, if you got ideas, hit me up!")
                        Section("Socials") {
                            Link("GitHub (@timi2506)", destination: URL(string: "https://github.com/timi2506")!)
                            Link("Twitter (@timi2506)", destination: URL(string: "https://x.com/timi2506")!)
                            Link("Support Me", destination: URL(string: "https://timi2506.is-a.dev/donate/")!)
                        }
                    } .formStyle(GroupedFormStyle())
                }.navigationTitle("More").tabItem{
                    Label("More", systemImage: "gear")}.tag(1)
            }
#if os(iOS)
            .tabViewStyle(.page)
#elseif os(macOS)
            .tabViewStyle(DefaultTabViewStyle())
#endif
            .toolbar{
                Menu(content: {
                    Picker("Theme", systemImage: "apple.logo", selection: $colorSchemeString, content:{
                        Label("System", systemImage: "circle.lefthalf.filled").tag("System")
                        Label("Light", systemImage: "sun.max.fill").tag("Light")
                        Label("Dark", systemImage: "moon.fill").tag("Dark")
                    })
                }) {
                    Image(systemName: colorSchemeString == "System" ? "circle.lefthalf.filled" : colorSchemeString == "Dark" ? "moon.fill" : "sun.max.fill")
                }.tint(.primary)
            }
        } .preferredColorScheme(colorSchemeString == "System" ? .none : colorSchemeString == "Dark" ? .dark : .light)
    }
}
struct MaterialsView: View {
    @Binding var colorSchemeString: String
    @Binding var selectedTab: Int
    @State var cornerRadius: CGFloat = 0
    @State var scale: CGFloat = 1
    @State var materialScale: CGFloat = 1
    @State var materialCornerRadius: CGFloat = 0
    @State var color: Color = .primary
    @State var rectangleOffset: CGSize = CGSize(width: 0, height: 0)
    @State var lastRectangleOffset: CGSize = CGSize(width: 0, height: 0)
    @State var materialOffset: CGSize = CGSize(width: 0, height: 0)

    @State var lastMaterialOffset: CGSize = CGSize(width: 0, height: 0)
    @State var material: Material = .ultraThinMaterial
    @State var materialText: String = ".ultraThinMaterial"
    let materials: [String] = [
        ".ultraThinMaterial",
        ".thinMaterial",
        ".regularMaterial",
        ".thickMaterial",
        ".ultraThickMaterial",
    ]
    @State var alwaysTrue = true
    @State var materialBorder = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .scale(scale)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(color)
                    .offset(rectangleOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                rectangleOffset = CGSize(width: lastRectangleOffset.width + gesture.translation.width, height: lastRectangleOffset.height + gesture.translation.height)
                                
                            }
                            .onEnded {_ in
                                lastRectangleOffset = rectangleOffset
                            }
                    )
                RoundedRectangle(cornerRadius: materialCornerRadius)
                    .scale(materialScale)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(material)
                    .offset(materialOffset)
                    .background(
                        RoundedRectangle(cornerRadius: materialCornerRadius)
                            .scale(materialScale)
                            .stroke(color.opacity(materialBorder ? 1 : 0))
                            .offset(materialOffset)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                materialOffset = CGSize(width: lastMaterialOffset.width + gesture.translation.width, height: lastMaterialOffset.height + gesture.translation.height)
                                
                            }
                            .onEnded {_ in
                                lastMaterialOffset = materialOffset
                            }
                    )
            } .frame(height: 300)
            Spacer()
        }
        .popover(isPresented: $alwaysTrue) {
            VStack {
                Text("TIP: YOU CAN MOVE THE RECTANGLE AND MATERIAL").font(.caption).foregroundStyle(.gray).padding(.top).padding(.horizontal)
                List {
                    Section("Material") {
                        Button("Reset Position") {
                            materialOffset = CGSize(width: 0, height: 0)
                            lastMaterialOffset = CGSize(width: 0, height: 0)
                        }
                        Toggle("Border", isOn: $materialBorder)
                        HStack {
                            Text("Corner Radius")
                            Slider(
                                value: $materialCornerRadius,
                                in: 0...100
                            )
                            Text(materialCornerRadius.rounded(.down).description)
                        } .contextMenu(menuItems: {
                            Button("Copy", systemImage: "document.on.clipboard") {
                                copy(materialCornerRadius.description)
                            }
                        }) {
                            Text(materialCornerRadius.description).padding()
                        }
                        HStack {
                            Text("Scale")
                            Slider(
                                value: $materialScale,
                                in: 1...3
                            )
                        }
                        Picker("Material", selection: $materialText) {
                            ForEach(materials, id: \.self) { material in
                                Text(material)
                            }
                        } .onChange(of: materialText) { newValue in
                            if newValue == ".ultraThinMaterial" {
                                material = .ultraThinMaterial
                            } else if newValue == ".thinMaterial" {
                                material = .thinMaterial
                            } else if newValue == ".regularMaterial" {
                                material = .regularMaterial
                            } else if newValue == ".thickMaterial" {
                                material = .thickMaterial
                            } else if newValue == ".ultraThickMaterial" {
                                material = .ultraThickMaterial
                            }
                        }
                    }
                    Section("Rectangle") {
                        Button("Reset Position") {
                            rectangleOffset = CGSize(width: 0, height: 0)
                            lastRectangleOffset = CGSize(width: 0, height: 0)
                        }
                        HStack {
                            Text("Corner Radius")
                            Slider(
                                value: $cornerRadius,
                                in: 0...100
                            )
                            Text(cornerRadius.rounded(.down).description)
                        } .contextMenu(menuItems: {
                            Button("Copy", systemImage: "document.on.clipboard") {
                                copy(cornerRadius.description)
                            }
                        }) {
                            Text(cornerRadius.description).padding()
                        }
                        HStack {
                            Text("Scale")
                            Slider(
                                value: $scale,
                                in: 1...3
                            )
                        }
                        ColorPicker("Color", selection: $color)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250),.medium, .large])
            .presentationBackgroundInteraction(
                .enabled(upThrough: .medium)
            )
            .presentationCornerRadius(25)
            .interactiveDismissDisabled(true)
            .preferredColorScheme(colorSchemeString == "System" ? .none : colorSchemeString == "Dark" ? .dark : .light)
#if os(macOS)
            .frame(minWidth: 250, minHeight: 250)
#endif
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 0 {
                alwaysTrue = true
            } else {
                alwaysTrue = false
            }
        }
    }
}

func copy(_ string: String) {
#if os(iOS)
    UIPasteboard.general.string = string
#elseif os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(string, forType: .string)
#endif
}
#Preview {
    ContentView()
}
