import SwiftUI
import UIKit

struct SummaryView: View {
    let rooms: [Room]
    let grandTotal: Double
    @State private var isShowingShareSheet = false
    @State private var summaryImage: UIImage? = nil

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Summary")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom)

                        ForEach(rooms) { room in
                            VStack(alignment: .leading) {
                                Text("Room: \(room.name.isEmpty ? "Unnamed Room" : room.name)").bold()
                                if room.includeWalls { Text("• Walls included") }
                                if room.includeCeilings { Text("• Ceilings included") }
                                if room.includeTrim { Text("• Trim included") }
                                if room.includeDoors { Text("• Doors included") }
                                if room.includeWindows { Text("• Windows included") }
                                if room.includeFeatureWall { Text("• Feature wall included") }
                                Text("Room Total: $\(String(format: "%.2f", room.interiorTotal))")
                                
                                // Display images for the room
                                if !room.images.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(room.images, id: \.self) { image in
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(8)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }

                        Text("Grand Total: $\(String(format: "%.2f", grandTotal))")
                            .font(.title2)
                            .bold()
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }

                // Share Summary Button
                Button(action: {
                    generateSummaryImageAndShare()
                }) {
                    Text("Share Summary")
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue) // Match Add Room button color scheme
                        .foregroundColor(.white) // White text
                        .cornerRadius(8)
                        .bold() // Bold text
                        .font(.title2)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Estimate Summary")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .first?.windows
                            .first?.rootViewController?
                            .dismiss(animated: true, completion: nil)
                    }
                }
            }
            .sheet(isPresented: $isShowingShareSheet) {
                if let image = summaryImage {
                    ActivityView(activityItems: [image])
                }
            }
        }
    }

    // MARK: - Generate Image and Trigger Share
    private func generateSummaryImageAndShare() {
        summaryImage = nil  // Reset the image to ensure it's newly generated

        DispatchQueue.global(qos: .userInitiated).async {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 800))
            let image = renderer.image { context in
                // Fill background with white color
                let backgroundColor = UIColor.white
                backgroundColor.setFill()
                context.fill(CGRect(x: 0, y: 0, width: 400, height: 800))

                // Define text and title attributes
                let titleFont = UIFont.boldSystemFont(ofSize: 18)
                let textFont = UIFont.systemFont(ofSize: 16)
                let textColor = UIColor.black
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 6

                var yOffset: CGFloat = 20

                // Draw title
                let title = "Interior Painting Estimate Summary"
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: textColor,
                    .paragraphStyle: paragraphStyle
                ]
                title.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: titleAttributes)
                yOffset += 40

                // Draw room details
                for room in rooms {
                    let roomName = "Room: \(room.name)"
                    roomName.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: [
                        .font: textFont,
                        .foregroundColor: textColor
                    ])
                    yOffset += 25

                    let toggleDetails = [
                        ("Walls included", room.includeWalls),
                        ("Ceilings included", room.includeCeilings),
                        ("Trim included", room.includeTrim),
                        ("Doors included", room.includeDoors),
                        ("Windows included", room.includeWindows),
                        ("Feature wall included", room.includeFeatureWall)
                    ]

                    for (detail, isIncluded) in toggleDetails where isIncluded {
                        detail.draw(at: CGPoint(x: 40, y: yOffset), withAttributes: [
                            .font: textFont,
                            .foregroundColor: textColor
                        ])
                        yOffset += 20
                    }

                    // Room total
                    let roomTotal = "Room Total: $\(String(format: "%.2f", room.interiorTotal))"
                    roomTotal.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: [
                        .font: textFont,
                        .foregroundColor: textColor
                    ])
                    yOffset += 30

                    // Add room images
                    if !room.images.isEmpty {
                        for image in room.images {
                            let imageRect = CGRect(x: 20, y: yOffset, width: 100, height: 100)
                            if let cgImage = image.cgImage {
                                context.cgContext.draw(cgImage, in: imageRect)
                            }
                            yOffset += 120  // Add spacing for images
                        }
                    }

                    yOffset += 20 // Space between rooms
                }

                // Draw grand total
                let grandTotalText = "Grand Total: $\(String(format: "%.2f", grandTotal))"
                grandTotalText.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: titleAttributes)
            }

            DispatchQueue.main.async {
                self.summaryImage = image
                self.isShowingShareSheet = true
            }
        }
    }
}

// MARK: - Activity View for Sharing
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
