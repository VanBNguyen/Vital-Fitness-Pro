import SwiftUI

// Main View for User Information
struct UserInfoView: View {
    // Stored properties for user input
    @AppStorage("heightFeet") private var heightFeet: String = ""
    @AppStorage("heightInches") private var heightInches: String = ""
    @AppStorage("weight") private var weight: String = ""
    @AppStorage("sex") private var sex: String = "Male"
    @AppStorage("age") private var age: String = ""
    @AppStorage("weightGoal") private var weightGoal: String = "Lose"
    @AppStorage("weightChangeSpeed") private var weightChangeSpeed: String = "Slowly"
    
    // Options for Pickers
    let sexes = ["Male", "Female", "Other"]
    let weightGoals = ["Lose", "Gain"]
    let weightChangeSpeeds = ["Quickly", "Slowly"]

    // Main body of the view
    var body: some View {
        VStack {
            // Form to collect user information
            Form {
                Section(header: Text("User Information")) {
                    // Input fields for height in feet and inches
                    HStack {
                        TextField("Height (feet)", text: $heightFeet)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: heightFeet) { newValue in
                                if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                    heightFeet = ""
                                }
                            }
                        
                        TextField("Height (inches)", text: $heightInches)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: heightInches) { newValue in
                                if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                    heightInches = ""
                                }
                            }
                    }
                    
                    // Input field for weight in pounds
                    TextField("Weight (lbs)", text: $weight)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: weight) { newValue in
                            if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                weight = ""
                            }
                        }
                    
                    // Input field for age
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: age) { newValue in
                            if !newValue.isEmpty && (Int(newValue) == nil || Int(newValue)! < 0) {
                                age = ""
                            }
                        }
                    
                    // Picker for sex selection
                    Picker("Sex", selection: $sex) {
                        ForEach(sexes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: sex) { newValue in
                        if newValue.isEmpty || !sexes.contains(newValue) {
                            sex = "Male" // Set to default if invalid
                        }
                    }
                    
                    // Picker for weight goal selection
                    Picker("Weight Goal", selection: $weightGoal) {
                        ForEach(weightGoals, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: weightGoal) { newValue in
                        if newValue.isEmpty || !weightGoals.contains(newValue) {
                            weightGoal = "Lose" // Set to default if invalid
                        }
                    }
                    
                    // Picker for weight change speed selection
                    Picker("Change Speed", selection: $weightChangeSpeed) {
                        ForEach(weightChangeSpeeds, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: weightChangeSpeed) { newValue in
                        if newValue.isEmpty || !weightChangeSpeeds.contains(newValue) {
                            weightChangeSpeed = "Slowly" // Set to default if invalid
                        }
                    }
                    
                    // Button to save user information
                    Button(action: saveUserInfo) {
                        Text("Save")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            // Display calculated BMI
            Text("BMI: \(calculateBMI())")
                .font(.headline)
                .padding(.top, 20)
            
            // Display calculated calorie needs if available
            if let calories = calculateCalories() {
                Text("Calorie Needs: \(calories) kcal/day")
                    .font(.headline)
                    .padding(.top, 10)
            } else {
                Text("Please enter all user information to calculate calorie needs.")
                    .font(.subheadline)
                    .padding(.top, 10)
            }
        }
    }
    
    // Function to save user information (it autosaves due to @AppStorage)
    private func saveUserInfo() {
        // it autosaves
    }
    
    // Function to calculate BMI
    private func calculateBMI() -> String {
        guard let heightFeetValue = Double(heightFeet), let heightInchesValue = Double(heightInches), let weightValue = Double(weight), heightFeetValue > 0 || heightInchesValue > 0 else {
            return "Invalid data"
        }
        let totalHeightInInches = (heightFeetValue * 12) + heightInchesValue
        let heightInMeters = totalHeightInInches * 0.0254
        let weightInKg = weightValue * 0.453592
        let bmi = weightInKg / (heightInMeters * heightInMeters)
        return String(format: "%.2f", bmi)
    }
    
    // Function to calculate daily calorie needs
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

// Preview for SwiftUI
#Preview {
    UserInfoView()
}
