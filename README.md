# SwiftUI_isDragActive


This is a self contained sample project demonstrating how to detect when a SwiftUI drag operation has begun.  It also detects when the drag operation has ended whether or not a valid drop has occured.

## Key concepts to implement isDragActive

- This project uses SwiftUI's' `Transferrable` drag and drop View modifiers `.draggable()` and `.dropDestination()`
- It declares an `isDragActive` `@State` var to hold the current dragging state
- It also declares an `isDragActive` environment varable to inject the current dragging state into all child Views
- It uses the `isTargeted:` closure with all of the drop target `.dropDestination()` view modifiers to track dragging status for all expected drop targets
- It also implements a `.dropDestination()` view modifier on an outer View in order to continue tracking the drag when none of the expected drop targets is being targeted

### Tips

- Use `.onChange(of: isDragActive)` to trigger desired actions when dragging begins or ends anywhere within the outer View. 
- This project uses it to change the `FocusState` of the `List` view so the background color of a selection will change during a drag.
