//
//  DejavuDemoTests.swift
//  DejavuDemoTests
//
//  Created by Harish Kumar Reddy Kunchala on 11/26/24.
//

import XCTest
import Dejavu
@testable import DejavuDemo

final class DejavuDemoTests: XCTestCase {
    var session: URLSession!

    override func setUpWithError() throws {
        // Register Dejavu's URL protocol to intercept network requests.
        Dejavu.setURLProtocolRegistrationHandler { [weak self] protocolClass in
            guard let self else { return }
            let config = URLSessionConfiguration.default
            config.protocolClasses = [protocolClass]
            self.session = URLSession(configuration: config)
        }
        
        // Unregister Dejavu's URL protocol after tests.
        Dejavu.setURLProtocolUnregistrationHandler { [weak self] protocolClass in
            self?.session = URLSession(configuration: .default)
        }
        
        // Configure Dejavu with the path to store recorded data and the mode.
        let configuration = DejavuConfiguration(
            fileURL: .testDataDirectory.appending(component: "mockData"),
            mode: .cleanRecord
        )
        
        // Start Dejavu session with the specified configuration.
        Dejavu.startSession(configuration: configuration)
    }
    
    override func tearDown() {
        // End Dejavu session after tests.
        Dejavu.endSession()
        session = nil
    }
    
    func testFetchDataSuccessfullyReturnsUsers() async throws {
        // Define the URL for the network request.
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        // Perform the network request using the configured session.
        let (data, response) = try await session.data(from: url)
        
        // Verify the response status code.
        if let httpResponse = response as? HTTPURLResponse {
            XCTAssertEqual(httpResponse.statusCode, 200, "Expected status code 200")
        }
        
        // Decode the received data into an array of User objects.
        let users = try JSONDecoder().decode([User].self, from: data)
        
        // Assert that the users array matches the expected data.
        XCTAssertEqual(
            users,
            [
                User(id: 1, name: "Leanne Graham", email: "Sincere@april.biz"),
                User(id: 2, name: "Ervin Howell", email: "Shanna@melissa.tv"),
                User(id: 3, name: "Clementine Bauch", email: "Nathan@yesenia.net"),
                User(id: 4, name: "Patricia Lebsack", email: "Julianne.OConner@kory.org"),
                User(id: 5, name: "Chelsey Dietrich", email: "Lucio_Hettinger@annie.ca"),
                User(id: 6, name: "Mrs. Dennis Schulist", email: "Karley_Dach@jasper.info"),
                User(id: 7, name: "Kurtis Weissnat", email: "Telly.Hoeger@billy.biz"),
                User(id: 8, name: "Nicholas Runolfsdottir V", email: "Sherwood@rosamond.me"),
                User(id: 9, name: "Glenna Reichert", email: "Chaim_McDermott@dana.io"),
                User(id: 10, name: "Clementina DuBuque", email: "Rey.Padberg@karina.biz")
            ]
        )
    }
}

extension URL {
    static let testDataDirectory: URL = {
#if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
        if let plistPath: String = Bundle.main.object(forInfoDictionaryKey: "MOCKED_DATA") as? String, !plistPath.isEmpty {
            return URL(filePath: plistPath)
        } else {
            fatalError(
                """
                You must set up a custom path in Xcode > Settings > Locations > Custom Paths named
                `MOCKED_DATA` that points to the location of the test data.
                """
            )
        }
#else
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(component: "Data/")
#endif
    }()
}
