import SwiftUI
import PhotosUI

struct ContentView: View {
    // Estimation State Variables
    @State private var roomName: String = ""
    @State private var roomLength: String = ""
    @State private var roomWidth: String = ""
    @State private var roomHeight: String = ""

    private let pricePerSqFtWalls: Double = 0.92
    private let pricePerSqFtCeilings: Double = 0.92
    private let pricePerLinearFtTrim: Double = 2.42
    private let pricePerDoor: Double = 100.0
    private let pricePerDoorCasing: Double = 35.0
    private let pricePerWindow: Double = 25.0
    private let pricePerSqFtFeatureWall: Double = 1.50

    @State private var includeWalls: Bool = true
    @State private var includeCeilings: Bool = false
    @State private var includeTrim: Bool = false
    @State private var includeDoors: Bool = false
    @State private var includeDoorCasing: Bool = false
    @State private var includeWindows: Bool = false
    @State private var includeFeatureWall: Bool = false

    @State private var numberOfDoors: String = "1"
    @State private var numberOfDoorCasings: String = "1"
    @State private var numberOfWindows: String = "1"
    @State private var featureWallSqFt: String = "0"

    @State private var subtotalWalls: Double = 0.0
    @State private var subtotalCeilings: Double = 0.0
    @State private var subtotalTrim: Double = 0.0
    @State private var subtotalDoors: Double = 0.0
    @State private var subtotalDoorCasings: Double = 0.0
    @State private var subtotalWindows: Double = 0.0
    @State private var subtotalFeatureWall: Double = 0.0
    @State private var grandTotal: Double = 0.0

    // Image Selection State Variables
    @State private var selectedImages: [UIImage] = []   // Store selected images
    @State private var isSelectingImage: Bool = false    // Flag for triggering image picker
    @State private var selectedImageIndex: Int? = nil    // Index of the image to edit (if applicable)

    @State private var isAddingRoom = false
    @State private var editingRoom: Room? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Interior Painting Estimator")
                        .font(.largeTitle)
                        .padding()

                    // Your other UI code for room name, dimensions, etc.

                    Divider()

                    // Image Selection Section
                    VStack {
                        Text("Upload Images")
                            .font(.title2)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                            ForEach(0..<4, id: \.self) { index in
                                ZStack {
                                    if index < selectedImages.count {
                                        Image(uiImage: selectedImages[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                selectedImageIndex = index
                                                isSelectingImage = true
                                            }
                                            .overlay(
                                                Button(action: {
                                                    selectedImages.remove(at: index)
                                                }) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.white)
                                                        .padding(8)
                                                        .background(Color.red)
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: 50, y: -50),
                                                alignment: .topTrailing
                                            )
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 150)
                                            .cornerRadius(8)
                                            .overlay(
                                                Image(systemName: "plus")
                                                    .foregroundColor(.blue)
                                                    .font(.largeTitle)
                                            )
                                            .onTapGesture {
                                                selectedImageIndex = index
                                                isSelectingImage = true
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $isSelectingImage) {
                ImagePicker(images: $selectedImages, selectedImageIndex: $selectedImageIndex)
            }
        }
    }

    private func calculateEstimate() {
        subtotalWalls = 0.0
        subtotalCeilings = 0.0
        subtotalTrim = 0.0
        subtotalDoors = 0.0
        subtotalDoorCasings = 0.0
        subtotalWindows = 0.0
        subtotalFeatureWall = 0.0
        grandTotal = 0.0

        // Estimate calculations here
    }
}

