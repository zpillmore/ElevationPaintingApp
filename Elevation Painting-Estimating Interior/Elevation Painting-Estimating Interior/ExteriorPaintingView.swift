import SwiftUI

// SideArea Model
struct SideArea: Identifiable {
    let id = UUID()
    var title: String = ""
    var length: String = ""
    var width: String = ""
    var isBody: Bool = false
    var isTrim: Bool = false
    var totalPrice: Double = 0.0
}

// ExteriorPaintingView
struct ExteriorPaintingView: View {
    @State private var houseSqft: String = ""
    @State private var houseTotalPrice: Double = 0.0

    @State private var sides: [SideArea] = []
    @State private var deckLength: String = ""
    @State private var deckWidth: String = ""
    @State private var isSandingRequired: Bool = false
    @State private var deckPrice: Double = 0.0

    @State private var fenceLength: String = ""
    @State private var fenceHeight: String = ""
    @State private var isTransparentStain: Bool = false
    @State private var isSolidBodyStain: Bool = false
    @State private var isBothSides: Bool = false
    @State private var fencePrice: Double = 0.0

    @State private var selectedImages: [UIImage] = []
    @State private var isSelectingImage: Bool = false
    @State private var selectedImageIndex: Int? = nil

    var grandTotal: Double {
        houseTotalPrice +
        sides.reduce(0) { $0 + $1.totalPrice } +
        deckPrice +
        fencePrice
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // House Total Sqft Section
                    Section(header: Text("House Total Sqft").font(.headline)) {
                        TextField("Enter total house sqft", text: $houseSqft)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .onChange(of: houseSqft) { newValue in
                                if let sqft = Double(newValue) {
                                    houseTotalPrice = sqft * 2.30
                                } else {
                                    houseTotalPrice = 0.0
                                }
                            }

                        Text("Price: $\(String(format: "%.2f", houseTotalPrice))")
                            .bold()
                    }

                    // Per Side Area Section
                    Section(header: Text("Per Side Area").font(.headline)) {
                        if !sides.isEmpty {
                            ForEach(sides) { side in
                                SideAreaView(side: side, onDelete: {
                                    sides.removeAll { $0.id == side.id }
                                })
                            }
                        }

                        Button(action: {
                            sides.append(SideArea())
                        }) {
                            Text("Add Side")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }

                    // Back Deck Section
                    Section(header: Text("Back Deck").font(.headline)) {
                        HStack {
                            TextField("Length", text: $deckLength)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)

                            TextField("Width", text: $deckWidth)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }

                        Toggle("Sanding Required", isOn: $isSandingRequired)

                        Button("Calculate Deck Price") {
                            if let length = Double(deckLength), let width = Double(deckWidth) {
                                let sqft = length * width
                                deckPrice = sqft * (isSandingRequired ? 4.50 : 2.25)
                            } else {
                                deckPrice = 0.0
                            }
                        }

                        Text("Deck Price: $\(String(format: "%.2f", deckPrice))")
                            .bold()
                    }

                    // Fence Section
                    Section(header: Text("Exterior Fence").font(.headline)) {
                        HStack {
                            TextField("Length (LNFT)", text: $fenceLength)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)

                            TextField("Height", text: $fenceHeight)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }

                        Toggle("Transparent/Semi-Trans Stain", isOn: $isTransparentStain)
                            .onChange(of: isTransparentStain) { newValue in
                                if newValue { isSolidBodyStain = false }
                            }

                        Toggle("Solid Body Stain", isOn: $isSolidBodyStain)
                            .onChange(of: isSolidBodyStain) { newValue in
                                if newValue { isTransparentStain = false }
                            }

                        Toggle("Both Sides of Fence", isOn: $isBothSides)

                        Button("Calculate Fence Price") {
                            if let length = Double(fenceLength), let height = Double(fenceHeight) {
                                let sqft = length * height
                                let basePrice = isTransparentStain ? sqft * 2.50 : (isSolidBodyStain ? sqft * 2.00 : 0)
                                fencePrice = isBothSides ? basePrice * 2 : basePrice
                            } else {
                                fencePrice = 0.0
                            }
                        }

                        Text("Fence Price: $\(String(format: "%.2f", fencePrice))")
                            .bold()
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

                        if selectedImages.count < 4 {
                            Button("Add Photo") {
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
                    Text("Grand Total: $\(String(format: "%.2f", grandTotal))")
                        .font(.title)
                        .bold()
                        .padding()

                    // Export Button
                    NavigationLink(destination: SummaryView(rooms: [], grandTotal: grandTotal)) {
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
            .navigationTitle("Exterior Painting Pricing Tool")
            .sheet(isPresented: $isSelectingImage) {
                ImagePicker(images: $selectedImages, selectedImageIndex: $selectedImageIndex, sourceType: .camera)
            }
        }
    }
}

// SideAreaView for dynamically added sides
struct SideAreaView: View {
    @State var side: SideArea
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Elevation Title", text: $side.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            HStack {
                TextField("Length", text: $side.length)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Width", text: $side.width)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            Toggle("Body", isOn: $side.isBody)
            Toggle("Trim", isOn: $side.isTrim)

            Button("Calculate Side Price") {
                if let length = Double(side.length), let width = Double(side.width) {
                    let sqft = length * width
                    side.totalPrice = (side.isBody ? sqft * 1.13 : 0) + (side.isTrim ? length * 19.72 : 0)
                } else {
                    side.totalPrice = 0.0
                }
            }

            Text("Side Price: $\(String(format: "%.2f", side.totalPrice))")
                .bold()

            Button("Remove Side") {
                onDelete()
            }
            .foregroundColor(.red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
