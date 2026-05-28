//
//  AsyncImageViewModelTests.swift
//  QuickHatchUI
//
//  Created by Daniel Koster on 5/28/26.
//
import Foundation
import QuickHatchCore
import Testing
import QuickHatchUI

private enum MockError: Error {
    case someError
}
// Mock provider to control success and failure states
actor MockFindImageDataProvider: FindImageDataProvidable {
    var shouldFail = false
    var mockData = "mock-image-data".data(using: .utf8)!
    
    func execute(_ url: String) async throws -> Data {
        if shouldFail {
            throw MockError.someError
        }
        return mockData
    }
}

@Suite("AsyncImageViewModel Tests")
struct AsyncImageViewModelTests {
    
    @Test("Initialization triggers automatic image loading")
    func test_init_triggersImageLoad() async throws {
        // Arrange
        let provider = MockFindImageDataProvider()
        
        // Act
        let viewModel = await AsyncImageViewModel(dataProvider: provider, url: "https://example.com")
        
        // Give the background Task in init a moment to execute
        try await Task.sleep(nanoseconds: 300)
        
        // Assert
        let expectedData = await provider.mockData
        await #expect(viewModel.data == expectedData)
    }
    
    @Test("Explicit reload successfully updates data")
    func test_reload_success_updatesData() async {
        // Arrange
        let provider = MockFindImageDataProvider()
        // Start with nil data to isolate the reload call
        let viewModel = await AsyncImageViewModel(data: nil, dataProvider: provider, url: "https://example.com")
        
        // Act
        await viewModel.reload()
        
        // Assert
        let expectedData = await provider.mockData
        await #expect(viewModel.data == expectedData)
    }
    
    @Test("DataProvider failure leaves data as default")
    func test_reload_failure_catchesError() async {
        // Arrange
        let provider = MockFindImageDataProvider()
        await provider.setShouldFail(true) // Helper or direct property change if mutable
        
        let initialData = "initial-data".data(using: .utf8)
        let defaultData = "default-data".data(using: .utf8)
        let viewModel = await AsyncImageViewModel(data: initialData,
                                                  defaultData: defaultData,
                                                  dataProvider: provider,
                                                  url: "https://example.com")
        
        // Act & Assert
        // The function catches internally, so it should not throw to the test environment
        await viewModel.reload()
        
        // Verify behavior matches your catch block logic (currently leaves data as-is)
        await #expect(viewModel.data == defaultData)
    }
}

// Simple extension to safely mutate the actor state in tests
extension MockFindImageDataProvider {
    func setShouldFail(_ value: Bool) {
        self.shouldFail = value
    }
}

