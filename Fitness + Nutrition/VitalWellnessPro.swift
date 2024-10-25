import SwiftUI

// Main entry point
@main
struct VitalWellnessPro: App {
    // StateObject to manage and observe data across the app
    @StateObject private var dataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            // ContentView as the root view
            ContentView()
                // Inject the dataManager environment object to make it available throughout the app
                .environmentObject(dataManager)
        }
    }
}
