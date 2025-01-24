import SwiftUI

class ProjectManager: ObservableObject {
    @Published var currentProject: Project? = nil
    @Published var savedProjects: [Project] = [] // Store all completed projects

    // Save the current project to the saved list
    func saveCurrentProject() {
        if let project = currentProject {
            savedProjects.append(project)
            currentProject = nil // Reset for a new project
        }
    }

    // Load a project by its ID
    func loadProject(id: UUID) -> Project? {
        return savedProjects.first { $0.id == id }
    }
}
