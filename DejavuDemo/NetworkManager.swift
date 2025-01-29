import Foundation

/// Provides conveniences for making network requests.
enum NetworkManager {
    /// Returns a value decoded from JSON data retrieved asynchronously from the given URL.
    /// - Parameters:
    ///   - url: The URL to retrieve.
    ///   - type: The type of the value to decode from the JSON data.
    static func value<T: Decodable>(forDataFrom url: URL, type: T.Type = T.self) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
