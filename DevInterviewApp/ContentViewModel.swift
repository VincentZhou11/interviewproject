//
//  ContentViewModel.swift
//  DevInterviewApp
//
//  Created by Vincent Zhou on 9/15/22.
//

import Foundation
import SwiftUI
import CoreData

public class ContentViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext;
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
    @Published var items: [Item] = []
    @Published var nameInput = ""
    @Published var outputName = ""
    @Published var outputAge = ""
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetch()
    }
    
    func fetch() {
        Task {
            do {
                // Create Fetch request
                let fetchRequest = Item.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)]
                // Fetch
                let fetchedItems = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                print("Fetched \(fetchedItems)")
                // Update view
                DispatchQueue.main.async {
                    withAnimation {
                        self.items = fetchedItems
                    }
                }
            }
            catch {
                print("Item fetch error: \(error.localizedDescription)")
            }
        }
    }
    
    func submitName() {
        let urlString = "https://api.agify.io?name=\(nameInput)&country_id=US"
        let url = URL(string: urlString)!

        Task {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("URL response not 200, returned \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return
            }
            
            guard let decoded = try? JSONDecoder().decode(AgeAPIResponse.self, from: data) else {
                print("Cannot decode data")
                return;
            }
            print("Decoded and adding")
            
            DispatchQueue.main.async {
                self.outputName = decoded.name
                self.outputAge = "\(decoded.age)"
                self.addItem(data: decoded)
            }
        }
    }
    
    func addItem(data: AgeAPIResponse) {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.name = data.name
        newItem.age = Int16(data.age)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Adding item error \(nsError), \(nsError.userInfo)")
        }
        
        fetch()
    }
    
    func debugAddItem() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.name = "new person"
        newItem.age = 1

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Adding item error \(nsError), \(nsError.userInfo)")
        }
        
        fetch()
    }

    func deleteItems(offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Deleting item error \(nsError), \(nsError.userInfo)")
        }
        
        fetch()
    }
}
