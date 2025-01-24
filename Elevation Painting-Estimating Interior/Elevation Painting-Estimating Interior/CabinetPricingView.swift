import SwiftUI

struct CabinetPricingView: View {
    @EnvironmentObject var projectManager: ProjectManager // Access the current project
    @State private var numberOfDoors: String = ""
    @State private var numberOfDrawers: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var isSelectingImage: Bool = false
    @State private var generalNotes: String = ""

    private let pricePerDoor: Double = 160.00
    private let pricePerDrawer: Double = 80.00
    private let basePrice: Double = 500.00

    var totalPrice: Double {
        let doors = Double(numberOfDoors) ?? 0.0
        let drawers = Double(numberOfDrawers) ?? 0.0
        return (doors * pricePerDoor) + (drawers * pricePerDrawer) + basePrice
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Cabinet Doors Section
                    Section(header: Text("Cabinet Doors (min 20)").font(.headline)) {
                        TextField("Enter number of cabinet doors", text: $numberOfDoors)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                        Text("Price: $\(String(format: "%.2f", (Double(numberOfDoors) ?? 0.0) * pricePerDoor))")
                            .bold()
                    }

                    // Cabinet Drawers Section
                    Section(header: Text("Cabinet Drawers").font(.headline)) {
                        TextField("Enter number of cabinet drawers", text: $numberOfDrawers)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                        Text("Price: $\(String(format: "%.2f", (Double(numberOfDrawers) ?? 0.0) * pricePerDrawer))")
                            .bold()
                    }

                    // General Notes Section
                    Section(header: Text("General Notes").font(.headline)) {
                        TextEditor(text: $generalNotes)
                            .frame(height: 100)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }

                    // Photo Upload Section
                    Section(header: Text("Photos").font(.headline)) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .cornerRadius(8)
                            }
                        }

                        if selectedImages.count < 6 {
                            Button("Take Photo") {
                                isSelectingImage = true
                            }
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.vertical)
                        }
                    }

                    // Grand Total Section
                    Section(header: Text("Grand Total").font(.headline)) {
                        Text("Total Price: $\(String(format: "%.2f", totalPrice))")
                            .font(.title)
                            .bold()
                            .padding()
                    }

                    // Save to Project Button
                    Button(action: {
                        saveCabinetDataToProject()
                    }) {
                        Text("Save to Project")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)

                    // Export Button
                    NavigationLink(destination: SummaryView(rooms: [], grandTotal: totalPrice)) {
                        Text("Export to Summary")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Cabinet Pricing Tool")
            .sheet(isPresented: $isSelectingImage) {
                ImagePicker(images: $selectedImages, selectedImageIndex: .constant(nil), sourceType: .camera)
            }
        }
    }

    // Save cabinet data to the current project
    private func saveCabinetDataToProject() {
        guard var currentProject = projectManager.currentProject else {
            print("No current project found!")
            return
        }

        // Create CabinetData object
        let cabinetData = CabinetData(
            numberOfDoors: Int(numberOfDoors) ?? 0,
            numberOfDrawers: Int(numberOfDrawers) ?? 0,
            photos: selectedImages,
            notes: generalNotes,
            totalPrice: totalPrice
        )

        // Update the project's cabinetData
        currentProject.cabinetData = cabinetData
        projectManager.currentProject = currentProject // Save the updated project
        print("Cabinet data saved to project!")
    }
}

// Preview
struct CabinetPricingView_Previews: PreviewProvider {
    static var previews: some View {
        CabinetPricingView()
            .environmentObject(ProjectManager()) // Provide ProjectManager for preview
    }
}
