import SwiftUI

struct NewProjectPageView: View {
    @EnvironmentObject var projectManager: ProjectManager // Access the ProjectManager

    var body: some View {
        VStack(spacing: 20) {
            // Interior Painting
            NavigationLink("Interior Painting", destination: RoomListView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

            // Cabinet Painting
            NavigationLink("Cabinet Painting", destination: CabinetPricingView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

            // Exterior Painting
            NavigationLink("Exterior Painting", destination: ExteriorPaintingView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .navigationTitle("New Project")
    }
}

// Preview
struct NewProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectPageView()
            .environmentObject(ProjectManager()) // Provide ProjectManager for preview
    }
}
