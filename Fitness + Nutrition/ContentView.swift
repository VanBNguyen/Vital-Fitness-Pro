import SwiftUI

// Main Content View
struct ContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
            FitnessView()
        }
    }
}

// Sidebar View for Navigation
struct Sidebar: View {
    var body: some View {
        // List of navigation links
        List {
            // Navigation link to UserInfoView
            NavigationLink(destination: UserInfoView()) {
                Label("User Info", systemImage: "person.crop.circle")
            }
            // Navigation link to FitnessView
            NavigationLink(destination: FitnessView()) {
                Label("Fitness", systemImage: "figure.walk")
            }
            // Navigation link to NutritionView
            NavigationLink(destination: NutritionView()) {
                Label("Nutrition", systemImage: "leaf")
            }
        }
        .listStyle(SidebarListStyle()) // Style the list as a sidebar
        .navigationTitle("Main Menu") // Set the navigation title
    }
}

// Preview for SwiftUI
#Preview {
    ContentView()
}
