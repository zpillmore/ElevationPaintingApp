import SwiftUI

struct AddRoomView: View {
    @State private var name: String = ""
    @State private var length: String = ""
    @State private var width: String = ""
    @State private var height: String = ""

    @State private var includeWalls: Bool = false
    @State private var includeCeilings: Bool = false
    @State private var includeTrim: Bool = false
    @State private var includeDoors: Bool = false
    @State private var includeDoorCasing: Bool = false
    @State private var includeWindows: Bool = false
    @State private var includeFeatureWall: Bool = false

    @State private var numberOfDoors: String = ""
    @State private var numberOfDoorCasings: String = ""
    @State private var numberOfWindows: String = ""
    @State private var featureWallSqFt: String = ""

    @State private var selectedImages: [UIImage] = []
    @State private var isSelectingImage: Bool = false
    @State private var selectedImageIndex: Int? = nil

    var room: Room?
    var onSave: (Room) -> Void
    @Environment(\.presentationMode) var presentationMode

    private let pricePerSqFtWalls: Double = 0.92
    private let pricePerSqFtCeilings: Double = 0.92
    private let pricePerLinearFtTrim: Double = 2.42
    private let pricePerDoor: Double = 100.0
    private let pricePerDoorCasing: Double = 35.0
    private let pricePerWindow: Double = 25.0
    private let pricePerSqFtFeatureWall: Double = 1.50

    @State private var subtotalWalls: Double = 0.0
    @State private var subtotalCeilings: Double = 0.0
    @State private var subtotalTrim: Double = 0.0
    @State private var subtotalDoors: Double = 0.0
    @State private var subtotalDoorCasings: Double = 0.0
    @State private var subtotalWindows: Double = 0.0
    @State private var subtotalFeatureWall: Double = 0.0
    @State private var interiorTotal: Double = 0.0

    init(room: Room? = nil, onSave: @escaping (Room) -> Void) {
        self.room = room
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Room Name")) {
                    TextField("Enter room name", text: $name)
                        .onAppear {
                            if let room = room {
                                name = room.name
                                length = String(room.length)
                                width = String(room.width)
                                height = String(room.height)
                                selectedImages = room.images
                                subtotalWalls = room.subtotalWalls
                                subtotalCeilings = room.subtotalCeilings
                                subtotalTrim = room.subtotalTrim
                                subtotalDoors = room.subtotalDoors
                                subtotalDoorCasings = room.subtotalDoorCasings
                                subtotalWindows = room.subtotalWindows
                                subtotalFeatureWall = room.subtotalFeatureWall
                                interiorTotal = room.interiorTotal

                                includeWalls = room.includeWalls
                                includeCeilings = room.includeCeilings
                                includeTrim = room.includeTrim
                                includeDoors = room.includeDoors
                                includeDoorCasing = room.includeDoorCasing
                                includeWindows = room.includeWindows
                                includeFeatureWall = room.includeFeatureWall

                                numberOfDoors = String(Int(room.subtotalDoors / pricePerDoor))
                                numberOfDoorCasings = String(Int(room.subtotalDoorCasings / pricePerDoorCasing))
                                numberOfWindows = String(Int(room.subtotalWindows / pricePerWindow))
                                featureWallSqFt = String(Int(room.subtotalFeatureWall / pricePerSqFtFeatureWall))
                            }
                        }
                }

                Section(header: Text("Dimensions")) {
                    TextField("Length", text: $length).keyboardType(.decimalPad)
                    TextField("Width", text: $width).keyboardType(.decimalPad)
                    TextField("Height", text: $height).keyboardType(.decimalPad)
                }

                Section(header: Text("Options")) {
                    Toggle("Include Walls", isOn: $includeWalls)
                    Toggle("Include Ceilings", isOn: $includeCeilings)
                    Toggle("Include Trim", isOn: $includeTrim)
                    Toggle("Include Doors", isOn: $includeDoors)
                    if includeDoors {
                        TextField("Number of Doors", text: $numberOfDoors).keyboardType(.numberPad)
                    }
                    Toggle("Include Door Casings", isOn: $includeDoorCasing)
                    if includeDoorCasing {
                        TextField("Number of Door Casings", text: $numberOfDoorCasings).keyboardType(.numberPad)
                    }
                    Toggle("Include Windows", isOn: $includeWindows)
                    if includeWindows {
                        TextField("Number of Windows", text: $numberOfWindows).keyboardType(.numberPad)
                    }
                    Toggle("Include Feature Wall", isOn: $includeFeatureWall)
                    if includeFeatureWall {
                        TextField("Feature Wall Area (sq ft)", text: $featureWallSqFt).keyboardType(.numberPad)
                    }
                }

                Section(header: Text("Cost Estimate")) {
                    Text("Subtotal for Walls: $\(subtotalWalls, specifier: "%.2f")")
                    Text("Subtotal for Ceilings: $\(subtotalCeilings, specifier: "%.2f")")
                    Text("Subtotal for Trim: $\(subtotalTrim, specifier: "%.2f")")
                    Text("Subtotal for Doors: $\(subtotalDoors, specifier: "%.2f")")
                    Text("Subtotal for Door Casings: $\(subtotalDoorCasings, specifier: "%.2f")")
                    Text("Subtotal for Windows: $\(subtotalWindows, specifier: "%.2f")")
                    Text("Subtotal for Feature Wall: $\(subtotalFeatureWall, specifier: "%.2f")")
                    Text("Interior Total: $\(interiorTotal, specifier: "%.2f")")
                }

                Button(action: calculateEstimate) {
                    Text("Calculate Price")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical)

                Section(header: Text("Photos")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                        }
                    }

                    if selectedImages.count < 4 {
                        Button("Add Photos") {
                            isSelectingImage = true
                        }
                        .padding()
                    }
                }

                Button(action: {
                    let updatedRoom = Room(
                        id: room?.id ?? UUID(),
                        name: name,
                        length: Double(length) ?? 0,
                        width: Double(width) ?? 0,
                        height: Double(height) ?? 0,
                        includeWalls: includeWalls,
                        includeCeilings: includeCeilings,
                        includeTrim: includeTrim,
                        includeDoors: includeDoors,
                        includeDoorCasing: includeDoorCasing,
                        includeWindows: includeWindows,
                        includeFeatureWall: includeFeatureWall,
                        images: selectedImages,
                        subtotalWalls: subtotalWalls,
                        subtotalCeilings: subtotalCeilings,
                        subtotalTrim: subtotalTrim,
                        subtotalDoors: subtotalDoors,
                        subtotalDoorCasings: subtotalDoorCasings,
                        subtotalWindows: subtotalWindows,
                        subtotalFeatureWall: subtotalFeatureWall
                    )
                    onSave(updatedRoom)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Room")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical)
            }
            .navigationTitle(room == nil ? "Add Room" : "Edit Room")
        }
        .sheet(isPresented: $isSelectingImage) {
            ImagePicker(images: $selectedImages, selectedImageIndex: $selectedImageIndex)
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
        interiorTotal = 0.0

        // Use default value 0.0 if the input is empty
        let roomLength = Double(length) ?? 0.0
        let roomWidth = Double(width) ?? 0.0
        let roomHeight = Double(height) ?? 0.0
        let featureWallArea = Double(featureWallSqFt) ?? 0.0
        let doors = Int(numberOfDoors) ?? 0
        let casings = Int(numberOfDoorCasings) ?? 0
        let windows = Int(numberOfWindows) ?? 0

        if includeWalls {
            let wallArea = 2 * roomHeight * (roomLength + roomWidth)
            subtotalWalls = wallArea * pricePerSqFtWalls
        }
        if includeCeilings {
            let ceilingArea = roomLength * roomWidth
            subtotalCeilings = ceilingArea * pricePerSqFtCeilings
        }
        if includeTrim {
            let trimPerimeter = 2 * (roomLength + roomWidth)
            subtotalTrim = trimPerimeter * pricePerLinearFtTrim
        }
        if includeDoors {
            subtotalDoors = Double(doors) * pricePerDoor
        }
        if includeDoorCasing {
            subtotalDoorCasings = Double(casings) * pricePerDoorCasing
        }
        if includeWindows {
            subtotalWindows = Double(windows) * pricePerWindow
        }
        if includeFeatureWall {
            subtotalFeatureWall = featureWallArea * pricePerSqFtFeatureWall
        }

        interiorTotal = subtotalWalls + subtotalCeilings + subtotalTrim + subtotalDoors + subtotalDoorCasings + subtotalWindows + subtotalFeatureWall
    }

}
