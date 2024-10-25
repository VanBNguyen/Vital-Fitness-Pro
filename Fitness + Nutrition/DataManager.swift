import Foundation
import SwiftUI

// DataManager class to handle saving and loading of workout and food data
class DataManager: ObservableObject {
    // Properties to store encoded workout and food data using @AppStorage
    @AppStorage("workoutsData") private var workoutsData: Data = Data()
    @AppStorage("foodsData") private var foodsData: Data = Data()
    
    // Published properties to notify views of changes in workouts and foods
    @Published var workouts: [Workout] = []
    @Published var foods: [Food] = []
    
    // Initializer to load workouts and foods when DataManager is initialized
    init() {
        loadWorkouts()
        loadFoods()
    }
    
    // Workout Data Management
    
    // Function to load workouts from storage
    func loadWorkouts() {
        if let decodedWorkouts = try? JSONDecoder().decode([Workout].self, from: workoutsData) {
            // Use main thread to update workouts property
            DispatchQueue.main.async {
                self.workouts = decodedWorkouts
                print("Workouts loaded: \(self.workouts)")
            }
        } else {
            print("Failed to load workouts")
        }
    }
    
    // Function to save workouts to storage
    func saveWorkouts() {
        if let encodedWorkouts = try? JSONEncoder().encode(workouts) {
            workoutsData = encodedWorkouts
            print("Workouts saved: \(workouts)")
        } else {
            print("Failed to save workouts")
        }
    }
    
    // Function to delete a workout at specified offsets
    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
        saveWorkouts()
        print("Workout deleted at offsets: \(offsets)")
    }
    
    // Food Data Management
    
    // Function to load foods from storage
    func loadFoods() {
        if let decodedFoods = try? JSONDecoder().decode([Food].self, from: foodsData) {
            // Use main thread to update foods property
            DispatchQueue.main.async {
                self.foods = decodedFoods
                print("Foods loaded: \(self.foods)")
            }
        } else {
            print("Failed to load foods")
        }
    }
    
    // Function to save foods to storage
    func saveFoods() {
        if let encodedFoods = try? JSONEncoder().encode(foods) {
            foodsData = encodedFoods
            print("Foods saved: \(foods)")
        } else {
            print("Failed to save foods")
        }
    }
    
    // Function to delete a food item at specified offsets
    func deleteFood(at offsets: IndexSet) {
        foods.remove(atOffsets: offsets)
        saveFoods()
        print("Food deleted at offsets: \(offsets)")
    }
}
