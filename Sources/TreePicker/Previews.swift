//
//  Previews.swift
//
//
//  Created by Boris Ovodov on 17.04.2024.
//

import Foundation
import SwiftUI

#if DEBUG
struct Location: Hashable, Identifiable {
    var title: String
    var children: [Location]?
    
    var id: String {
        return self.title
    }
}

let locationsTree: [Location] = [
    .init(title: "🇬🇧 United Kingdom", children: [
        .init(title: "London", children: nil),
        .init(title: "Birmingham", children: nil),
        .init(title: "Bristol", children: nil)
    ]),
    .init(title: "🇫🇷 France", children: [
        .init(title: "Paris", children: nil),
        .init(title: "Toulouse", children: nil),
        .init(title: "Bordeaux", children: nil)
    ]),
    .init(title: "🇩🇪 Germany", children: [
        .init(title: "Berlin", children: nil),
        .init(title: "Frankfurt", children: nil),
        .init(title: "Hamburg", children: nil)
    ]),
    .init(title: "🇷🇺 Russia", children: nil)
]

#Preview("ListPreview") {
    ListPreview()
}

#Preview("PickerPreview") {
    PickerPreview()
}

#Preview("TreeOptionalPickerPreview") {
    TreeOptionalPickerPreview()
}

struct ListPreview: View {
    @State private var selectedLocation: Location? // работает только если явно указать `.tag(location)`. Выдаёт объект. Но! Выделяет только листья на iOS.
    @State private var selectedLocationSingle: Location = .init(title: "🇷🇺 Russia", children: nil) // работает только если явно указать `.tag(location)`. Выдаёт объект.
    @State private var selectedLocations = Set<Location>() // работает только если явно указать `.tag(location)`. Выдаёт объект.
    @State private var selectedLocationID: String? // работает. выдаёт значение атрибута, указанного в поле id у List.
    @State private var selectedLocationIDSingle: String = "" // работает. выдаёт значение атрибута, указанного в поле id у List.
    @State private var selectedLocationsID = Set<String>() // работает. выдаёт значение атрибута, указанного в поле id у List.
    
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink {
                    List(locationsTree, id: \.id, children: \.children, selection: $selectedLocation) { dataElement in
                        HStack {
                            Text(dataElement.title)
                        }
                        .tag(dataElement)
                    }
                    .toolbar { EditButton() }
                    
                    Text(selectedLocation?.title ?? "nil")
//                    ForEach(Array(selectedLocations), id: \.self) { selection in
//                        Text(selection.title)
//                    }
                } label: {
                    LabeledContent {
                        Text("self.selectedOptions")
                    } label: {
                        Text("self.label")
                    }
                }
            }
        }
    }
}

struct PickerPreview: View {
    @State private var selectedLocationSingle: Location = .init(title: "🇷🇺 Russia", children: nil) // работает только если явно указать `.tag(location)`. Выдаёт объект.
    @State private var selectedLocationIDSingle: String = "" // выдаёт значение атрибута, указанного в поле id у ForEach.
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("PickerPreview", selection: $selectedLocationIDSingle) {
                    ForEach(locationsTree, id: \.title) { location in
                        Text(location.title)
                    }
                }
                .pickerStyle(.navigationLink)
                
                Text(selectedLocationIDSingle)
            }
        }
    }
}

struct TreeOptionalPickerPreview: View {
    @State private var selectedLocation: Location? = .init(title: "🇷🇺 Russia")
    @State private var selectedLocationID: String? = "🇷🇺 Russia" // работает. выдаёт значение атрибута, указанного в поле id у List.
    
    var body: some View {
        NavigationStack {
            Form {
                TreeOptionalPicker("PickerPreview", data: locationsTree, id: \.id, children: \.children, selection: $selectedLocation) { location in
                    Text(location.id)
                }
                
                Text(selectedLocation?.title ?? "nil")
            }
        }
    }
}
#endif
