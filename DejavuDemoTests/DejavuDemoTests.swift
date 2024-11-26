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
            guard let self = self else { return }
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
            fileURL: .testDataDirectory.appendingPathComponent("mockData"),
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
    
    func testFetchData() async throws {
        // Define the URL for the network request.
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        // Perform the network request using the configured session.
        let (data, _) = try await session.data(from: url)
        
        // Decode the received data into an array of User objects.
        let users = try JSONDecoder().decode([User].self, from: data)
        
        // Assert that the users array is not empty.
        XCTAssertFalse(users.isEmpty, "Users should not be empty")
    }
}

extension URL {
    static let testDataDirectory: URL = {
#if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
        if let plistPath: String = Bundle.main.object(forInfoDictionaryKey: "MOCKED_DATA") as? String, !plistPath.isEmpty {
            return URL(fileURLWithPath: plistPath)
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
            .appendingPathComponent("Data", isDirectory: true)
#endif
    }()
}
