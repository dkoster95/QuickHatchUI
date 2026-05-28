//
//  AsyncImageTests.swift
//  QuickHatchUI
//
//  Created by Daniel Koster on 5/28/26.
//
#if canImport(UIKit)
import Foundation
import SnapshotTesting
import SwiftUI
import Testing
import UIKit
import QuickHatchUI

// Helper to generate a solid color test image
extension UIImage {
    static func make(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}


class MockAsyncImageViewModel: AsyncImageViewModelable {
    func reload() async {
        
    }
    
    var data: Data?

    init(data: Data? = nil) {
        self.data = data
    }
}

@MainActor
@Suite("AsyncImageV2 Snapshot Tests")
struct AsyncImageV2Tests {
    
    // Set to true to record new baselines, false to verify
    private let recordMode = false

    @Test("Shows placeholder when data is nil")
    func showsPlaceholderWhenDataIsNil() {
        // Given
        let mockViewModel = MockAsyncImageViewModel(data: nil)
        let view = AsyncImageV2<Image, ProgressView>(viewModel: mockViewModel) {
            ProgressView()
        }.frame(width: 40, height: 40)

        // Then
        assertSnapshot(
            of: view,
            as: .image,
            record: SnapshotTestingConfiguration.Record(booleanLiteral: recordMode)
        )
    }

    @Test("Applies modifiers to loaded image")
    func appliesModifiersToLoadedImage() {
        // Given
        let testImage = UIImage.make(color: .red, size: CGSize(width: 40, height: 40))
        let mockViewModel = MockAsyncImageViewModel(data: testImage.pngData())
        
        let view = AsyncImageV2(
            viewModel: mockViewModel,
            imageModifiers: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .border(Color.black, width: 5)
            },
            placeholder: { Color.clear }
        ).frame(width: 40, height: 40)

        // Then
        assertSnapshot(
            of: view,
            as: .image,
            record: SnapshotTestingConfiguration.Record(booleanLiteral: recordMode)
        )
    }
}
#endif

