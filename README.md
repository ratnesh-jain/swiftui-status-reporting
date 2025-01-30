# Status Reporting
An SwiftUI Library for reporting various success, failure, help etc status at top level.

## Installation:
```swift
dependencies: [
  .package(url: "https://github.com/ratnesh-jain/swiftui-status-reporting", .upToNextMajor("0.0.1")
]
```

## Usage:
### Report Status
- Success Status
```swift
reportStatus(
  title: "Actions completed",
  message: "Item added to cart",
  type: .success
)
```
- Failure Status
```swift
reportStatus(
  title: "Error Occured Performing action",
  message: "Unknwon error occurred please try again later",
  type: .error(error.localizedDescription)
)
```
- Warning Status
```swift
reportStatus(
  title: "Could not add to bookmark",
  message: "We got some error bookmarking item, its not your fault. Give it another try.",
  type: .warning
)
```

### Displaying in UI
```swift
struct ContentView: View {
  var body: some View {
    AppRootView()
      .showReportedStatus(alignment: .top)
  }
}
```

### Optional Customization of Status View contents
- Customize Image:
```swift
.reportedStatusImage { status in
  switch status.type {
    case .error:
      Image(systemName: "exclamationmark.triangle.fill")
    case .warning:
      Image(systemName: "exclamationmark")
    case .success:
      Image(systemName: "checkmark")
    }
}
```
- Customize Content:
```swift
.reportedStatusContent({ status in
  VStack(alignment: .leading, spacing: 2) {
    Text(status.title)
      .fontWeight(.semibold)
    Text(status.message)
       .foregroundStyle(.secondary)
       .font(.subheadline)
   }
})
```
- Customize Action:
```swift
.reportedStatusActions({ status in
  switch status.type {
  case .error:
    Button("Contact Support") {
      store.openContactSupportSheet()
    }
    .foregroundStyle(Color.accentColor)
  case .warning:
    Button("Okay") {
      store.okayButtonTapped()
    }
   case .success:
     Button("Great") {}
   }
})
```

## Playful Example:
```swift
List(1...20, id: \.self) { index in
    Text("Index: \(index)")
        .contextMenu {
            Button("Add to Cart") {
                reportStatus(title: "Actions completed", message: "Item added to cart", type: .success)
            }
            Button("Checkout") {
                reportStatus(title: "Error Occured Performing action", message: "Unknwon error occurred please try again later", type: .error(""))
            }
            Button("Bookmark") {
                reportStatus(title: "Could not add to bookmark", message: "We got some error bookmarking item, its not your fault. Give it another try.", type: .warning)
            }
        }
}
.buttonStyle(.bordered)
.showReportedStatus(alignment: .top)
.reportedStatusActions({ status in
    switch status.type {
    case .error:
        Button("Contact Support") {}
            .foregroundStyle(Color.accentColor)
    case .warning:
        Button("Okay") {}
    case .success:
        Button("Great") {}
    }
})
.preferredColorScheme(.dark)
```


# Result

https://github.com/user-attachments/assets/7c59b39a-8c2c-4814-a7ec-a68db12402eb

