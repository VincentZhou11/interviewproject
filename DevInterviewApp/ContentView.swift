//
//  ContentView.swift
//  DevInterviewApp
//
//  Created by Vincent Zhou on 9/15/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject private var vm: ContentViewModel
    
    init(viewContext: NSManagedObjectContext) {
        self.vm = ContentViewModel(viewContext: viewContext)
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Form") {
                    TextField("Name", text: $vm.nameInput)
                    Button {
                        vm.submitName()
                    } label: {
                        Text("Submit")
                    }
                    Button {
                        vm.nameInput = ""
                        vm.outputName = ""
                        vm.outputAge = ""
                    } label: {
                        Text("Clear").foregroundColor(.red)
                    }
                }
                .listRowBackground(Color.clear)
                Section("Result") {
                    if (!vm.outputName.isEmpty) {
                        Text(vm.outputName).font(.title3).underline() + Text(" is predicted to be ").font(.caption) + Text(vm.outputAge).font(.title3).underline()
                    }
                }
                .listRowBackground(Color.clear)
                Section("Recent Queries") {
                    List {
                        ForEach(vm.items) { item in
                            VStack(alignment:.leading) {
                                HStack {
                                    Text(item.name!)
                                    Text("Age: \(item.age)")
                                }
                                
                                Text("\(item.timestamp!, formatter: itemFormatter)").font(.caption)
                            }
                        }
                        .onDelete(perform: vm.deleteItems)
                    }
                }
                .listRowBackground(Color.clear)
            }
//            .background(Color.clear)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: vm.addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
            }
            .fullscreenBackground {
//                LinearGradient(colors: [.blue, .cyan, .black], startPoint: .top, endPoint: .bottom)
                Image("vincent graphic")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle("Ageify")
        }
        
    }

    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewContext: PersistenceController.preview.container.viewContext).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
