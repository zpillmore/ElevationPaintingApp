import SwiftUI

@main
struct ElevationPaintingApp: App {
    @StateObject private var projectManager = ProjectManager() // Create the shared ProjectManager instance

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomePageView()
                    .environmentObject(projectManager) // Pass ProjectManager to the environment
            }
        }
    }
}
