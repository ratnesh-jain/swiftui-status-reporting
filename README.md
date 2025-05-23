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
import StatusReporting

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

### Interoperate with IssueReporting library.
`StatusReporting` can listen to IssueReporting library events via `IssueReporter` protocol to display reportedIssues with `ReportedStatusView`.
- By default, this only renders the UI when called `reportStatus` function, but to also render other issues reported using `reportIssue` function.
- To do this, client can add `StatusReporter` to `IssueReporters` like below.

```swift
import SwiftUI

struct AwesomeApp: App {
    init() {
        IssueReporters.current.append(StatusReporter())
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
              .showReportedStatus(alignment: .top)
        }
    }
}

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

# Results

https://github.com/user-attachments/assets/7c59b39a-8c2c-4814-a7ec-a68db12402eb

https://github.com/user-attachments/assets/581ace0b-4279-40ea-aef3-15a0ca5beb94

## Pre-requisite 
iOS 17+
Internal Dependency: TCA (https://github.com/pointfreeco/swift-composable-architecture) 
## Note: 
- This library is intented for my other TCA toy projects.
- Users are free to take inspiration of the code, view implementation, animation and apis.

