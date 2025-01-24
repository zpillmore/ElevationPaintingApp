import SwiftUI

struct RoomListView: View {
    @EnvironmentObject var projectManager: ProjectManager // Access the current project
    @State private var rooms: [Room] = [] // List of rooms
    @State private var isEditingRoom: Bool = false // Controls AddRoomView presentation
    @State private var roomToEdit: Room? = nil // Room to edit, if any
    @State private var isSummaryViewPresented: Bool = false // Controls SummaryView presentation

    var grandTotal: Double {
        return rooms.reduce(0) { $0 + $1.interiorTotal }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all) // White Background

                VStack {
                    // Watermark Logo
                    Spacer()

                    Image("ElevationLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .opacity(0.3)
                        .padding(.bottom, 120)

                    Spacer()

                    // List of Rooms
                    List {
                        ForEach(rooms) { room in
                            HStack {
                                Text(room.name)
                                    .foregroundColor(.white)
                                    .bold()
                                Spacer()
                                Text("$\(String(format: "%.2f", room.interiorTotal))")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .onTapGesture {
                                roomToEdit = room
                                isEditingRoom = true
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)

                    // Grand Total Section
                    Text("Grand Total for All Rooms: $\(String(format: "%.2f", grandTotal))")
                        .font(.title2)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)

                    // Complete Estimate Button
                    Button(action: {
                        isSummaryViewPresented = true
                    }) {
                        Text("Complete Estimate")
                            .padding()
                            .frame(height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .bold()
                    }
                    .padding(.top, 20)

                    // Save to Project Button
                    Button(action: {
                        saveInteriorDataToProject()
                    }) {
                        Text("Save to Project")
                            .padding()
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .bold()
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Interior Painting Rooms")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        roomToEdit = nil
                        isEditingRoom = true
                    }) {
                        Text("Add Room")
                            .padding()
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .bold()
                    }
                }
            }
            .sheet(isPresented: $isEditingRoom) {
                AddRoomView(room: roomToEdit, onSave: { updatedRoom in
                    if let roomToEdit = roomToEdit {
                        if let index = rooms.firstIndex(where: { $0.id == roomToEdit.id }) {
                            rooms[index] = updatedRoom
                        }
                    } else {
                        rooms.append(updatedRoom)
                    }
                    isEditingRoom = false
                })
            }
            .sheet(isPresented: $isSummaryViewPresented) {
                SummaryView(rooms: rooms, grandTotal: grandTotal)
            }
        }
    }

    // Save interior data to the current project
    private func saveInteriorDataToProject() {
        projectManager.currentProject?.interiorData = rooms
        print("Interior data saved to project!")
    }
}

// Add preview feature for RoomListView
struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RoomListView()
                .environmentObject(ProjectManager()) // Provide ProjectManager for preview
        }
    }
}
