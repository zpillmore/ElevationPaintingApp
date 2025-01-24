import Foundation
import UIKit

struct Room: Identifiable {
    var id = UUID()
    var name: String
    var length: Double
    var width: Double
    var height: Double

    var includeWalls: Bool
    var includeCeilings: Bool
    var includeTrim: Bool
    var includeDoors: Bool
    var includeDoorCasing: Bool
    var includeWindows: Bool
    var includeFeatureWall: Bool

    var images: [UIImage] = [] // Store selected images

    var subtotalWalls: Double
    var subtotalCeilings: Double
    var subtotalTrim: Double
    var subtotalDoors: Double
    var subtotalDoorCasings: Double
    var subtotalWindows: Double
    var subtotalFeatureWall: Double

    var interiorTotal: Double {
        return subtotalWalls + subtotalCeilings + subtotalTrim + subtotalDoors + subtotalDoorCasings + subtotalWindows + subtotalFeatureWall
    }
}
