import SwiftUI

// Main View for Nutrition Tracking
struct NutritionView: View {
    // Stored properties to handle food data and user input
    @AppStorage("foodsData") private var foodsData: Data = Data()
    @State private var foods: [Food] = []
    @State private var foodName: String = ""
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    @State private var showError: Bool = false

    // Stored properties to handle user info for calorie goal calculation
    @AppStorage("heightFeet") private var heightFeet: String = ""
    @AppStorage("heightInches") private var heightInches: String = ""
    @AppStorage("weight") private var weight: String = ""
    @AppStorage("sex") private var sex: String = "Male"
    @AppStorage("age") private var age: String = ""
    @AppStorage("weightGoal") private var weightGoal: String = "Lose"
    @AppStorage("weightChangeSpeed") private var weightChangeSpeed: String = "Slowly"
    
    // Computed property to calculate the user's calorie goal
    private var calorieGoal: Int {
        calculateCalories() ?? 0
    }

    // Initializer to decode and load foods from storage
    init() {
        if let decodedFoods = try? JSONDecoder().decode([Food].self, from: foodsData) {
            _foods = State(initialValue: decodedFoods)
        }
    }

    // Main body of the view
    var body: some View {
        ScrollView {
            VStack {
                // Header Title
                Text("Nutrition Page")
                    .font(.largeTitle)
                    .padding()

                // Display total intake information
                VStack(alignment: .leading) {
                    Text("Total Intake")
                        .font(.title2)
                        .padding(.bottom, 5)

                    // Display the total intake details for calories, protein, carbs, and fats
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Calories: \(totalCalories())")
                            Text("Protein: \(totalProtein())g")
                            Text("Carbs: \(totalCarbs())g")
                            Text("Fats: \(totalFats())g")
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    // Display calorie goal and progress bar
                    VStack(alignment: .leading) {
                        Text("Calorie Goal: \(totalCalories()) / \(calorieGoal)")
                        ProgressView(value: Double(totalCalories()), total: Double(calorieGoal))
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding(.top, 5)
                    }
                }
                .padding()

                // Section to add new food items
                VStack {
                    Text("ADD FOOD")
                        .font(.headline)
                        .padding(.bottom, 5)

                    // Input fields for new food details
                    TextField("Food Name", text: $foodName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    TextField("Calories", text: $calories)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.bottom, 5)
                        .onChange(of: calories) { newValue in
                            if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                calories = ""
                            }
                        }
                    TextField("Protein (g)", text: $protein)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.bottom, 5)
                        .onChange(of: protein) { newValue in
                            if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                protein = ""
                            }
                        }
                    TextField("Carbs (g)", text: $carbs)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.bottom, 5)
                        .onChange(of: carbs) { newValue in
                            if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                carbs = ""
                            }
                        }
                    TextField("Fats (g)", text: $fats)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.bottom, 5)
                        .onChange(of: fats) { newValue in
                            if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                fats = ""
                            }
                        }

                    // Show error message if food name is empty
                    if showError {
                        Text("Food name is required.")
                            .foregroundColor(.red)
                    }

                    // Button to add the new food item
                    Button(action: addFood) {
                        Text("Add Food")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
                .padding()

                // Section to display the list of added foods
                VStack {
                    Text("FOODS")
                        .font(.headline)
                        .padding(.bottom, 5)

                    // List of foods with navigation links to detail views
                    ForEach(foods) { food in
                        NavigationLink(destination: FoodDetailView(food: food, foods: $foods)) {
                            Text("\(food.name)    Cal: \(food.calories) P: \(food.protein)g C: \(food.carbs)g F: \(food.fats)g")
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()

                // Button to delete all foods
                Button(action: deleteAllFoods) {
                    Text("Delete All Foods")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding()
            }
            .onAppear(perform: loadFoods)
        }
        .navigationTitle("Nutrition")
    }

    // Function to calculate total calories from all foods
    private func totalCalories() -> Int {
        return foods.map { $0.calories }.reduce(0, +)
    }

    // Function to calculate total protein from all foods
    private func totalProtein() -> Int {
        return foods.map { $0.protein }.reduce(0, +)
    }

    // Function to calculate total carbs from all foods
    private func totalCarbs() -> Int {
        return foods.map { $0.carbs }.reduce(0, +)
    }

    // Function to calculate total fats from all foods
    private func totalFats() -> Int {
        return foods.map { $0.fats }.reduce(0, +)
    }

    // Function to add a new food item
    private func addFood() {
        guard !foodName.isEmpty else {
            showError = true
            return
        }
        showError = false

        guard let caloriesValue = Int(calories), let proteinValue = Int(protein), let carbsValue = Int(carbs), let fatsValue = Int(fats) else { return }

        let newFood = Food(name: foodName, calories: caloriesValue, protein: proteinValue, carbs: carbsValue, fats: fatsValue)
        foods.append(newFood)
        saveFoods()

        // Clear input fields
        foodName = ""
        calories = ""
        protein = ""
        carbs = ""
        fats = ""
    }

    // Function to save foods to persistent storage
    private func saveFoods() {
        if let encodedFoods = try? JSONEncoder().encode(foods) {
            foodsData = encodedFoods
        }
    }

    // Function to load foods from persistent storage
    private func loadFoods() {
        if let decodedFoods = try? JSONDecoder().decode([Food].self, from: foodsData) {
            foods = decodedFoods
        }
    }

    // Function to delete all foods
    private func deleteAllFoods() {
        foods.removeAll()
        saveFoods()
    }
    
    // Function to calculate the user's daily calorie needs
    private func calculateCalories() -> Int? {
        guard let heightFeetValue = Double(heightFeet),
              let heightInchesValue = Double(heightInches),
              let weightValue = Double(weight),
              let ageValue = Int(age),
              !sex.isEmpty,
              !weightGoal.isEmpty,
              !weightChangeSpeed.isEmpty else {
            return nil
        }
        
        let heightCm = (heightFeetValue * 12 + heightInchesValue) * 2.54
        let weightKg = weightValue * 0.453592
        
        let bmr: Double
        if sex == "Male" {
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(ageValue) + 5
        } else {
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(ageValue) - 161
        }
        
        let activityFactor: Double = 1.2 // assuming sedentary lifestyle for simplicity
        
        let maintenanceCalories = bmr * activityFactor
        
        let adjustment: Double
        if weightGoal == "Lose" {
            adjustment = weightChangeSpeed == "Quickly" ? 750 : 500
            return Int(maintenanceCalories - adjustment)
        } else {
            adjustment = weightChangeSpeed == "Quickly" ? 750 : 500
            return Int(maintenanceCalories + adjustment)
        }
    }
}

// Model for Food items
struct Food: Identifiable, Codable {
    let id = UUID()
    var name: String
    var calories: Int
    var protein: Int
    var carbs: Int
    var fats: Int
}

// Detailed view for a single food item
struct FoodDetailView: View {
    var food: Food
    @Binding var foods: [Food]
    @State private var foodName: String
    @State private var calories: String
    @State private var protein: String
    @State private var carbs: String
    @State private var fats: String
    @Environment(\.presentationMode) var presentationMode

    // Initializer to set the state variables with the food details
    init(food: Food, foods: Binding<[Food]>) {
        self.food = food
        self._foods = foods
        self._foodName = State(initialValue: food.name)
        self._calories = State(initialValue: String(food.calories))
        self._protein = State(initialValue: String(food.protein))
        self._carbs = State(initialValue: String(food.carbs))
        self._fats = State(initialValue: String(food.fats))
    }

    var body: some View {
        Form {
            // Section to display and edit food details
            Section(header: Text("Food Details")) {
                TextField("Food Name", text: $foodName)
                TextField("Calories", text: $calories)
                    .keyboardType(.numberPad)
                TextField("Protein (g)", text: $protein)
                    .keyboardType(.numberPad)
                TextField("Carbs (g)", text: $carbs)
                    .keyboardType(.numberPad)
                TextField("Fats (g)", text: $fats)
                    .keyboardType(.numberPad)
            }

            // Button to save changes to the food item
            Button(action: saveChanges) {
                Text("Save Changes")
            }
            .foregroundColor(.blue)
            .padding()

            // Button to delete the food item
            Button(action: deleteFood) {
                Text("Delete Food")
            }
            .foregroundColor(.red)
            .padding()
        }
        .navigationTitle(food.name)
    }

    // Function to save changes made to the food item
    private func saveChanges() {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            if let caloriesValue = Int(calories), let proteinValue = Int(protein), let carbsValue = Int(carbs), let fatsValue = Int(fats) {
                foods[index] = Food(name: foodName, calories: caloriesValue, protein: proteinValue, carbs: carbsValue, fats: fatsValue)
                saveFoods()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    // Function to delete the food item
    private func deleteFood() {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods.remove(at: index)
            saveFoods()
            presentationMode.wrappedValue.dismiss()
        }
    }

    // Function to save foods to persistent storage
    private func saveFoods() {
        if let encodedFoods = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(encodedFoods, forKey: "foodsData")
        }
    }
}

// Preview for SwiftUI
#Preview {
    NutritionView()
}
