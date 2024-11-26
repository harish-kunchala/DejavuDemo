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
        Dejavu.setURLProtocolRegistrationHandler { [weak self] protocolClass in
            guard let self = self else { return }
            let config = URLSessionConfiguration.default
            config.protocolClasses = [protocolClass]
            self.session = URLSession(configuration: config)
        }
        
        Dejavu.setURLProtocolUnregistrationHandler { [weak self] protocolClass in
            self?.session = URLSession(configuration: .default)
        }
        
        let configuration = DejavuConfiguration(
            fileURL: .testDataDirectory.appendingPathComponent("mockData"),
            mode: .cleanRecord
        )
        
        Dejavu.startSession(configuration: configuration)
    }
    
    override func tearDown() {
        Dejavu.endSession()
        session = nil
    }
    
    func testFetchData() async throws {
        let expectation = self.expectation(description: "Fetching data")
        
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(let users):
                XCTAssertFalse(users.isEmpty, "Users should not be empty")
            case .failure(let error):
                XCTFail("Error fetching data: \(error)")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
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
