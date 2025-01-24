import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    var clientName: String
    var clientEmail: String
    var clientPhone: String
    var clientAddress: String
    var interiorData: [Elevation_Painting_Estimating_Interior.Room] = []
    var cabinetData: CabinetData? = nil
    var exteriorData: [Elevation_Painting_Estimating_Interior.SideArea] = []
    var createdAt: Date = Date()
}

extension Project {
    enum CodingKeys: String, CodingKey {
        case id
        case clientName
        case clientEmail
        case clientPhone
        case clientAddress
        case interiorData
        case cabinetData
        case exteriorData
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        clientName = try container.decode(String.self, forKey: .clientName)
        clientEmail = try container.decode(String.self, forKey: .clientEmail)
        clientPhone = try container.decode(String.self, forKey: .clientPhone)
        clientAddress = try container.decode(String.self, forKey: .clientAddress)
        interiorData = try container.decode([Elevation..Room].self, forKey: .interiorData)
        cabinetData = try container.decodeIfPresent(CabinetData.self, forKey: .cabinetData)
        exteriorData = try container.decode([Elevation_Painting_Estimating_Interior.SideArea].self, forKey: .exteriorData)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(clientName, forKey: .clientName)
        try container.encode(clientEmail, forKey: .clientEmail)
        try container.encode(clientPhone, forKey: .clientPhone)
        try container.encode(clientAddress, forKey: .clientAddress)
        try container.encode(interiorData, forKey: .interiorData)
        try container.encode(cabinetData, forKey: .cabinetData)
        try container.encode(exteriorData, forKey: .exteriorData)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
