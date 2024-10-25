import SwiftUI

// Main View for Fitness Tracking
struct FitnessView: View {
    // Environment object to access and manage workout data
    @EnvironmentObject var dataManager: DataManager

    // Main body of the view
    var body: some View {
        VStack {
            // Navigation link to the Workout Creation View
            NavigationLink(destination: WorkoutCreationView()) {
                Text("Create Workout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            // List of existing workouts
            List {
                // Iterate over each workout in the data manager
                ForEach(dataManager.workouts) { workout in
                    // Navigation link to the Workout Detail View for the selected workout
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        Text(workout.name)
                    }
                }
                // Enable deletion of workouts
                .onDelete(perform: dataManager.deleteWorkout)
            }
        }
        .navigationTitle("Fitness") // Set the navigation title
        .onAppear {
            // Load workouts and print a message when the view appears
            print("FitnessView appeared")
            dataManager.loadWorkouts()
        }
    }
}

// Preview for SwiftUI
#Preview {
    FitnessView()
        .environmentObject(DataManager()) // Add environment object for preview
}
