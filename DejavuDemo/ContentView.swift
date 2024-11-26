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
    @State private var users: [User] = []
    @State private var errorMessage: IdentifiableError?

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
            .onAppear(perform: fetchUsers)
            // Show an alert if there's an error.
            .alert(item: $errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Function to fetch users from the network.
    func fetchUsers() {
        NetworkManager.shared.fetchData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                case .failure(let error):
                    self.errorMessage = IdentifiableError(message: "Error fetching users: \(error.localizedDescription)")
                }
            }
        }
    }
}

// Preview provider for SwiftUI previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Struct to wrap error messages in an identifiable type.
struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
