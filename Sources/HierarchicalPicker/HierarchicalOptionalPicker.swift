//
//  HierarchicalOptionalPicker.swift
//
//
//  Created by Boris Ovodov on 08.04.2024.
//

import Foundation
import SwiftUI


/// A control for selecting single option from a set of hierarchical values.
@available(macOS 14.0, iOS 17.0, visionOS 1.0, *)
@MainActor public struct HierarchicalOptionalPicker<Label: View, SelectionValue: Hashable, Content: View, RowContent: View, NilRowContent: View, Data: RandomAccessCollection> : View {
    
    /// A binding to a selected value.
    private var selection: Binding<SelectionValue?>
    
    /// A view builder that creates the view for a single row in pickers options.
    private var rowContent: (Data.Element) -> RowContent
    
    /// A view that describes the purpose of selecting an option.
    private var label: Label
    
    /// A view for a row that present `nil` selected value.
    private var nilRowContent: NilRowContent
    
    /// The data for populating the list.
    private var data: Data
    
    /// A key path to a property whose non-`nil` value gives the children of `data`. A non-`nil` but empty value denotes a node capable of having children that is currently childless, such as an empty directory in a file system. On the other hand, if the property at the key path is `nil`, then `data` is treated as a leaf node in the tree, like a regular file in a file system.
    private var children: KeyPath<Data.Element, Data?>
    
    /// The content and behavior of the view.
    @MainActor public var body: some View {
        Text("Hello World")
    }
    
    // TODO: add init<S: StringProtocol>(_ title: S, ...) initializers.
    // TODO: resolve problem about non usable id keypath. Others don't use it too: https://github.com/Cosmo/OpenSwiftUI/blob/master/Sources/OpenSwiftUI/Views/ForEach.swift
    
    /// Creates a hierarchical picker that computes its options on demand from an underlying collection of identifiable data, optionally allowing users to select a single element. Picker displays a custom label.
    @MainActor public init(data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, @ViewBuilder label: () -> Label) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, NilRowContent == Text, Data.Element : Identifiable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = Text(nilRowDefaultTitle)
        self.label = label()
        self.data = data
        self.children = children
    }
    
    /// Creates a hierarchical picker that computes its options on demand from an underlying collection of identifiable data, optionally allowing users to select a single element. Picker displays a custom label and a custom clear selection row.
    @MainActor public init(data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, @ViewBuilder label: () -> Label, @ViewBuilder nilRowContent: () -> NilRowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data.Element : Identifiable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = nilRowContent()
        self.label = label()
        self.data = data
        self.children = children
    }
    
    /// Creates a hierarchical picker that computes its options on demand from an underlying collection of identifiable data, optionally allowing users to select a single element. Picker generates its label from a localized string key.
    @MainActor public init(_ titleKey: LocalizedStringKey, data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Label == Text, NilRowContent == Text, Data.Element : Identifiable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = Text(nilRowDefaultTitle)
        self.label = Text(titleKey)
        self.data = data
        self.children = children
    }
    
    /// Creates a hierarchical picker that computes its options on demand from an underlying collection of identifiable data, optionally allowing users to select a single element. Picker generates its label from a localized string key and displays a custom clear selection row.
    @MainActor public init(_ titleKey: LocalizedStringKey, data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, @ViewBuilder nilRowContent: () -> NilRowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Label == Text, Data.Element : Identifiable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = nilRowContent()
        self.label = Text(titleKey)
        self.data = data
        self.children = children
    }


    /// Creates a hierarchical picker that identifies its options based on a key path to the identifier of the underlying data, optionally allowing users to select a single element. Picker displays a custom label.
    @MainActor public init<ID>(data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, @ViewBuilder label: () -> Label) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, NilRowContent == Text, ID : Hashable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = Text(nilRowDefaultTitle)
        self.label = label()
        self.data = data
        self.children = children
    }
    
    /// Creates a hierarchical picker that identifies its options based on a key path to the identifier of the underlying data, optionally allowing users to select a single element. Picker displays a custom label and a custom clear selection row.
    @MainActor public init<ID>(data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, @ViewBuilder label: () -> Label, @ViewBuilder nilRowContent: () -> NilRowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, ID : Hashable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = nilRowContent()
        self.label = label()
        self.data = data
        self.children = children
    }
    
    /// Creates a hierarchical picker that identifies its options based on a key path to the identifier of the underlying data, optionally allowing users to select a single element. Picker generates its label from a localized string key.
    @MainActor public init<ID>(_ titleKey: LocalizedStringKey, data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Label == Text, NilRowContent == Text, ID : Hashable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = Text(nilRowDefaultTitle)
        self.label = Text(titleKey)
        self.data = data
        self.children = children
    }
    
    /// Creates a hierarchical picker that identifies its options based on a key path to the identifier of the underlying data, optionally allowing users to select a single element. Picker generates its label from a localized string key and displays a custom clear selection row.
    @MainActor public init<ID>(_ titleKey: LocalizedStringKey, data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, @ViewBuilder nilRowContent: () -> NilRowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Label == Text, ID : Hashable {
        self.selection = selection
        self.rowContent = rowContent
        self.nilRowContent = nilRowContent()
        self.label = Text(titleKey)
        self.data = data
        self.children = children
    }
}
