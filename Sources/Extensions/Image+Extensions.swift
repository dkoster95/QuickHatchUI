//
//  Image+Extensions.swift
//  QuickHatchUI
//
//  Created by Daniel Koster on 5/26/26.
//
import Foundation
import SwiftUI

public extension Image {
    init?(data: Data) {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        self = Image(nsImage: nsImage)
        #else
        return nil
        #endif
    }
}
