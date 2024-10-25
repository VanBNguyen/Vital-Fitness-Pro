import Foundation

// Model for Workout
struct Workout: Identifiable, Codable {
    let id = UUID() // Unique identifier for each workout
    var name: String // Name of the workout
    var exercises: [Exercise] // List of exercises in the workout
}

// Model for Exercise
struct Exercise: Identifiable, Codable {
    let id = UUID() // Unique identifier for each exercise
    var name: String // Name of the exercise
    var sets: String // Number of sets performed
    var reps: String // Number of reps performed
    var weight: String // Weight used in the exercise
}
