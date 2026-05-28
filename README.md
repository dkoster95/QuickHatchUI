# QuickHatchUI

`QuickHatchUI` is a reusable, modular design system framework for Apple platforms. It contains a collection of custom, highly configurable, and generic SwiftUI components designed to establish visual consistency and speed up layout development across multiple apps.

---

## 🚀 Key Features

* **Generic Design**: Built using Swift generics to decouple UI styling constraints from underlying data models.
* **Protocol-Driven State**: Components rely on clear protocol abstractions (e.g., `AsyncImageViewModelable`), isolating views from concrete business logic.
* **Deterministic Layouts**: Designed for predictability, making UI snapshot testing and previews seamless without running backend or network side effects.
* **Swift Concurrency Optimized**: Interfaces are bound to `@MainActor` to strictly enforce thread-safe UI updates on the main thread.

---

## 📐 Included Components

### `AsyncImageV2`
A highly customizable, lightweight asynchronous image view designed to replace the native SwiftUI `AsyncImage`. It offloads loading task states to a view model protocol, enabling instant placeholder stubbing and custom image-modifying pipelines.

---

## 🛠 Quick Start

### Implementing `AsyncImageV2`

You can easily instantiate layout components by passing generic placeholder layouts and optional modifier blocks:

```swift
import QuickHatchUI
import SwiftUI

struct ProfileCardView: View {
    let viewModel: AsyncImageViewModelable // Injected protocol bound to @MainActor
    
    var body: some View {
        VStack {
            AsyncImageV2(
                viewModel: viewModel,
                imageModifiers: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                },
                placeholder: {
                    ProgressView() // Rendered while data is nil
                }
            )
            
            Text("User Profile")
                .font(.headline)
        }
    }
}
```

---

## 🎨 Designing New Components

When contributing new elements to `QuickHatchUI`, maintain high reusability by adhering to these structural guidelines:

1. **Leverage Generics**: Allow parent apps to inject arbitrary layout containers via `@ViewBuilder`.
2. **Abstract with Protocols**: Never hardcode models or network handlers directly inside the view structs.
3. **Isolate Threads**: Annotate views or view-model bindings with `@MainActor` to prevent multi-threaded data-race issues.

---

## 🧪 UI Test Doubling & Previews

Because components depend strictly on protocol contracts, writing isolated SwiftUI Previews or Snapshot Tests requires zero runtime overhead:

```swift
import SwiftUI
import QuickHatchUI

@MainActor
final class MockImageViewModel: AsyncImageViewModelable {
    var data: Data?

    init(data: Data? = nil) {
        self.data = data
    }
    
    func reload() async {

    }
}

#Preview("Loaded State") {
    let sampleData = UIImage(systemName: "person.circle.fill")?.pngData()
    let mockVM = MockImageViewModel(data: sampleData)
    
    return AsyncImageV2(viewModel: mockVM) {
        ProgressView()
    }
}
```

---

## 💾 Installation

Add this framework to your target dependencies inside your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/dkoster95/QuickHatchUI.git", from: "1.0.0")
]
```
