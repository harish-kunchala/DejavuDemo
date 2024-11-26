//
//  ContentView.swift
//  DejavuDemo
//
//  Created by Harish Kumar Reddy Kunchala on 11/26/24.
//

import SwiftUI

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}

struct ContentView: View {
    @State private var users: [User] = []
    @State private var errorMessage: IdentifiableError?

    var body: some View {
        NavigationView {
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Users")
            .onAppear(perform: fetchUsers)
            .alert(item: $errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
