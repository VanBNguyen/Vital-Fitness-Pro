import SwiftUI

// View for Selecting Exercises for a Workout
struct ExerciseSelectionView: View {
    // Binding to selected exercises from the parent view
    @Binding var selectedExercises: [Exercise]

    // Main body of the view
    var body: some View {
        // Section to display exercise selection
        Section(header: Text("Select Exercises")) {
            // Iterate over each exercise group
            ForEach(ExerciseGroups, id: \.0) { exercise, group in
                // Toggle switch for each exercise
                Toggle(exercise, isOn: Binding<Bool>(
                    // Determine if the exercise is selected
                    get: { selectedExercises.contains { $0.name == exercise } },
                    // Add or remove the exercise based on toggle state
                    set: { newValue in
                        if newValue {
                            // Add exercise to selectedExercises
                            selectedExercises.append(Exercise(name: exercise, sets: "", reps: "", weight: ""))
                        } else {
                            // Remove exercise from selectedExercises
                            selectedExercises.removeAll { $0.name == exercise }
                        }
                    }
                ))
            }
        }
    }
}

// Preview for SwiftUI
#Preview {
    ExerciseSelectionView(selectedExercises: .constant([]))
}
