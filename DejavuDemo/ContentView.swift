//
//  ContentView.swift
//  DejavuDemo
//
//  Created by Harish Kumar Reddy Kunchala on 11/26/24.
//

import SwiftUI

// Main view for displaying the list of users.
struct ContentView: View {
    // State variables to hold the list of users and any error messages.
    @State private var result: Result<[User], Error>?
    @State private var isShowingAlert = false
    
    var users: [User] {
        guard case let .success(users) = result else {
            return []
        }
        return users
    }
    
    var error: Error? {
        guard case let .failure(error) = result else {
            return nil
        }
        return error
    }
    
    var body: some View {
        NavigationView {
            // List to display users' names and emails.
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Users")
            // Fetch users when the view appears.
            .task {
                guard result == nil else { return }
                let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
                do {
                    let users: [User] = try await NetworkManager.value(forDataFrom: url)
                    result = .success(users)
                } catch {
                    result = .failure(error)
                    isShowingAlert = true
                }
            }
            .alert("Error", isPresented: $isShowingAlert, presenting: error) { _ in
                // OK action included by default.
            } message: { error in
                Text("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}

// User model conforming to Codable and Identifiable protocols.
// This allows the model to be easily decoded from JSON and used in SwiftUI lists.
struct User: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
