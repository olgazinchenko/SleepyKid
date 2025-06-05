//
//  SleepyKidTests.swift
//  SleepyKidTests
//
//  Created by ozinchenko.dev on 23/05/2025.
//

import CoreData
import XCTest

@testable import SleepyKid

final class SleepyKidTests: XCTestCase {
    // MARK: - Properties
    private var persistentContainer: NSPersistentContainer!
    private var context: NSManagedObjectContext!

    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create an in-memory persistent store for testing
        persistentContainer = NSPersistentContainer(name: "SleepyKid")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load test store: \(error)")
            }
        }

        context = persistentContainer.viewContext
        // Override the app's persistent container for testing
        AppDelegate.persistentContainer = persistentContainer
    }

    override func tearDownWithError() throws {
        context = nil
        persistentContainer = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests
    func testSaveAndRetrieveKid() throws {
        // Given
        let kid = Kid(
            id: UUID(),
            name: "Test Kid",
            birthDate: Date(),
            sleeps: []
        )

        KidPersistent.deleteAll()

        // When
        KidPersistent.save(kid)
        let retrievedKids = KidPersistent.fetchAll()

        // Then
        XCTAssertEqual(retrievedKids.count, 1, "Should have exactly one kid")
        XCTAssertEqual(retrievedKids.first?.name, "Test Kid", "Kid name should match")
        XCTAssertEqual(retrievedKids.first?.id, kid.id, "Kid ID should match")
    }

    func testFetchPerformance() throws {
        KidPersistent.deleteAll()

        for i in 0..<100 {
            let kid = Kid(
                id: UUID(),
                name: "Test Kid \(i)",
                birthDate: .now,
                sleeps: []
            )
            KidPersistent.save(kid)
        }

        measure {
            _ = KidPersistent.fetchAll()
        }
    }

    func testSavePerformance() throws {
        let kids = (0..<100).map {
            Kid(
                id: UUID(),
                name: "Test Kid \($0)",
                birthDate: .now,
                sleeps: []
            )
        }
        
        KidPersistent.deleteAll()
        
        measure {
            for kid in kids {
                KidPersistent.save(kid)
            }
        }
    }

}
