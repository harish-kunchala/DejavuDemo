import Foundation

// NetworkManager is a singleton class responsible for handling network requests.
class NetworkManager {
    // Shared instance of NetworkManager to ensure a single instance throughout the app.
    static let shared = NetworkManager()
    
    // Private initializer to prevent the creation of multiple instances.
    private init() {}

    // Method to fetch data from a specified URL.
    // The completion handler returns a Result type with either an array of User objects or an Error.
    func fetchData(completion: @escaping (Result<[User], Error>) -> Void) {
        // URL of the API endpoint.
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        // Create a data task to perform the network request.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if there was an error in the network request.
            if let error = error {
                // If there was an error, pass it to the completion handler.
                completion(.failure(error))
                return
            }
            
            // Ensure that data was received.
            guard let data = data else {
                // If no data was received, pass a custom error to the completion handler.
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Attempt to decode the received data into an array of User objects.
                let users = try JSONDecoder().decode([User].self, from: data)
                // If successful, pass the array of users to the completion handler.
                completion(.success(users))
            } catch {
                // If decoding fails, pass the error to the completion handler.
                completion(.failure(error))
            }
        }
        // Start the network request.
        task.resume()
    }
}

// User model conforming to Codable and Identifiable protocols.
// This allows the model to be easily decoded from JSON and used in SwiftUI lists.
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
