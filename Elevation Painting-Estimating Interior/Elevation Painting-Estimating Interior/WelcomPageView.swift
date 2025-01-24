import SwiftUI

struct WelcomePageView: View {
    @EnvironmentObject var projectManager: ProjectManager // Access the shared ProjectManager
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var email = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color.white
                    .edgesIgnoringSafeArea(.all) // Ensures the background fills the entire screen

                ScrollView { // Makes the content scrollable
                    VStack(spacing: 20) {
                        // Logo (Increased Size)
                        Image("ElevationLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200) // Increased height to fill extra space
                            .padding(.top, 40)

                        // Input Fields with white background and gray outline
                        Group {
                            CustomTextField(placeholder: "First Name", text: $firstName)
                            CustomTextField(placeholder: "Last Name", text: $lastName)
                            CustomTextField(placeholder: "Address", text: $address)
                            CustomTextField(placeholder: "Phone Number", text: $phone)
                            CustomTextField(placeholder: "Email", text: $email)
                        }
                        .padding(.horizontal)

                        // New Project Button
                        NavigationLink(destination: NewProjectPageView()) {
                            Button(action: {
                                createNewProject() // Create a new project with the entered details
                            }) {
                                Text("New Project")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding(.bottom, 100) // Adds extra space at the bottom for the keyboard
                }
            }
            .navigationBarHidden(true) // Hides the default navigation bar
            .preferredColorScheme(.light) // Forces light mode
        }
    }

    // Create a new project with entered client data
    private func createNewProject() {
        let newProject = Project(
            clientName: "\(firstName) \(lastName)",
            clientEmail: email,
            clientPhone: phone,
            clientAddress: address
        )
        projectManager.currentProject = newProject // Assign it to the current project
    }
}

// Custom Text Field View
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Light gray outline
            )
            .cornerRadius(10)
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
            .environmentObject(ProjectManager()) // Provide ProjectManager for preview
    }
}
