import Foundation
import CoreLocation

struct FanSpot: Identifiable, Codable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    let songTitle: String
    let artistName: String
    let isCurrent: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, songTitle, artistName, isCurrent
    }
    
    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2D, songTitle: String, artistName: String, isCurrent: Bool = false) {
        self.id = id
        self.coordinate = coordinate
        self.songTitle = songTitle
        self.artistName = artistName
        self.isCurrent = isCurrent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let lat = try container.decode(Double.self, forKey: .latitude)
        let lon = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        songTitle = try container.decode(String.self, forKey: .songTitle)
        artistName = try container.decode(String.self, forKey: .artistName)
        isCurrent = try container.decode(Bool.self, forKey: .isCurrent)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(songTitle, forKey: .songTitle)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(isCurrent, forKey: .isCurrent)
    }
}
