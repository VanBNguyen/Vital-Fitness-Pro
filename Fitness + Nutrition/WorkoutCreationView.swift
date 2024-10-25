import SwiftUI

struct WorkoutCreationView: View {
    // Environment object to manage data and state for workouts
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode

    // State properties for workout details and error handling
    @State private var workoutName: String = ""
    @State private var selectedExercises: [Exercise] = []
    @State private var showError: Bool = false

    var body: some View {
        Form {
            Section(header: Text("WORKOUT DETAILS")) {
                TextField("Workout Name", text: $workoutName)
                if showError {
                    Text("Workout name is required.")
                        .foregroundColor(.red)
                }
            }
            
            // Section for selecting exercises by muscle group
            Section(header: Text("SELECT EXERCISES")) {
                ForEach(groupedExercises.keys.sorted(), id: \.self) { muscleGroup in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(muscleGroup)
                            .font(.headline)
                            .bold()
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.clear)
                        
                        // List of exercises for the muscle group
                        ForEach(groupedExercises[muscleGroup]!, id: \.self) { exercise in
                            Toggle(exercise, isOn: Binding<Bool>(
                                get: { selectedExercises.contains { $0.name == exercise } },
                                set: { newValue in
                                    if newValue {
                                        selectedExercises.append(Exercise(name: exercise, sets: "", reps: "", weight: ""))
                                    } else {
                                        selectedExercises.removeAll { $0.name == exercise }
                                    }
                                }
                            ))
                        }

                        // Add padding between muscle group sections
                        .padding(.bottom, 10)
                    }
                }
            }

            Button(action: saveWorkout) {
                Text("Save Workout")
                    .foregroundColor(.blue)
            }
            .padding(.top, 20) // Add some space before the button
        }
        .navigationTitle("Create Workout")
        .onAppear {
            print("WorkoutCreationView appeared")
        }
    }

    // Function to group exercises by muscle group
    private var groupedExercises: [String: [String]] {
        Dictionary(grouping: ExerciseGroups.map { $0.0 }, by: { exercise in
            ExerciseGroups.first { $0.0 == exercise }!.1
        })
    }

    // Function to save the workout
    private func saveWorkout() {
        // Check if workout name is provided
        guard !workoutName.isEmpty else {
            showError = true
            return
        }
        showError = false

        // Create new workout and add it to the data manager
        let newWorkout = Workout(name: workoutName, exercises: selectedExercises)
        dataManager.workouts.append(newWorkout)
        dataManager.saveWorkouts()

        // Print statements
        print("Workout saved: \(newWorkout)")
        print("Returning to FitnessView")
        
        // Navigate back to the FitnessView
        presentationMode.wrappedValue.dismiss()
    }
}
