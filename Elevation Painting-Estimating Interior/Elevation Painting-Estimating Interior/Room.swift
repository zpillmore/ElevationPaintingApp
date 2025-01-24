import Foundation

struct Room: Identifiable, Codable {
    let id: UUID
    var name: String
    var length: Double
    var width: Double
    var height: Double
    var interiorTotal: Double
}
