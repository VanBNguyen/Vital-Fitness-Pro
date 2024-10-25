import SwiftUI

// Main View for Displaying Workout Details
struct WorkoutDetailView: View {
    // Environment object to manage data and state for workouts
    @EnvironmentObject var dataManager: DataManager
    
    // State properties for workout details and edit mode
    @State var workout: Workout
    @State private var editMode: EditMode = .inactive

    // Main body of the view
    var body: some View {
        VStack {
            // Form to display and edit workout details
            Form {
                // Section for workout name
                Section(header: Text("Workout Details")) {
                    if editMode == .active {
                        // Editable TextField for workout name
                        TextField("Workout Name", text: $workout.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        // Display workout name as Text
                        Text(workout.name)
                            .font(.largeTitle)
                            .padding()
                    }
                }

                // Section for displaying exercises
                Section(header: Text("Exercises")) {
                    ForEach($workout.exercises) { $exercise in
                        VStack(alignment: .leading) {
                            // Exercise name
                            Text(exercise.name)
                                .font(.headline)
                            
                            // Input fields for sets, reps, and weight
                            HStack {
                                TextField("Sets", text: $exercise.sets)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)
                                    .placeholder(when: exercise.sets.isEmpty) {
                                        Text("Sets").foregroundColor(.gray)
                                    }
                                    .onChange(of: exercise.sets) { _ in
                                        saveWorkout()
                                    }
                                
                                TextField("Reps", text: $exercise.reps)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)
                                    .placeholder(when: exercise.reps.isEmpty) {
                                        Text("Reps").foregroundColor(.gray)
                                    }
                                    .onChange(of: exercise.reps) { _ in
                                        saveWorkout()
                                    }
                                
                                TextField("Weight", text: $exercise.weight)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                    .placeholder(when: exercise.weight.isEmpty) {
                                        Text("Weight").foregroundColor(.gray)
                                    }
                                    .onChange(of: exercise.weight) { _ in
                                        saveWorkout()
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle(editMode == .active ? "Edit Workout" : workout.name)
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
            .onChange(of: editMode) { _ in
                saveWorkout()
            }
        }
    }

    // Function to save workout changes
    private func saveWorkout() {
        if let index = dataManager.workouts.firstIndex(where: { $0.id == workout.id }) {
            dataManager.workouts[index] = workout
            dataManager.saveWorkouts()
            print("Workout updated: \(workout)")
        }
    }
}

// Extension for placeholder in TextField
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

// Preview for SwiftUI
#Preview {
    WorkoutDetailView(workout: Workout(name: "Sample Workout", exercises: [Exercise(name: "Push Up", sets: "", reps: "", weight: "")]))
        .environmentObject(DataManager()) // Add environment object for preview
}
