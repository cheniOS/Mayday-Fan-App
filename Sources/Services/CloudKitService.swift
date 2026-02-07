import Foundation
import CloudKit
import CoreLocation

/// 云端服务：负责实现“全球星海”的实时同步
class CloudKitService: ObservableObject {
    static let shared = CloudKitService()
    
    private let container = CKContainer.default()
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    @Published var remoteFans: [FanSpot] = []
    
    /// 上传自己的实时坐标与听歌状态
    func uploadMySpot(location: CLLocationCoordinate2D, songTitle: String, artistName: String) {
        let recordID = CKRecord.ID(recordName: "current_user_spot") // 这里通常用设备ID或用户哈希
        let record = CKRecord(recordType: "FanSpot", recordID: recordID)
        
        record["location"] = CLLocation(latitude: location.latitude, longitude: location.longitude)
        record["songTitle"] = songTitle
        record["artistName"] = artistName
        record["timestamp"] = Date()
        
        publicDB.save(record) { record, error in
            if let error = error {
                print("CloudKit Upload Error: \(error.localizedDescription)")
            } else {
                print("Successfully uploaded star to the sky! ✨")
            }
        }
    }
    
    /// 获取全球在线粉丝（星海）
    func fetchGlobalFans() {
        // 只查询过去 30 分钟内活跃的粉丝，确保“实时感”
        let thirtyMinsAgo = Date().addingTimeInterval(-1800)
        let predicate = NSPredicate(format: "timestamp > %@", thirtyMinsAgo as NSDate)
        let query = CKQuery(recordType: "FanSpot", predicate: predicate)
        
        publicDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let response):
                let spots = response.matchResults.compactMap { (id, result) -> FanSpot? in
                    guard let record = try? result.get() else { return nil }
                    let loc = record["location"] as? CLLocation
                    return FanSpot(
                        id: UUID(), // 临时展示ID
                        coordinate: loc?.coordinate ?? .init(),
                        songTitle: record["songTitle"] as? String ?? "",
                        artistName: record["artistName"] as? String ?? ""
                    )
                }
                DispatchQueue.main.async {
                    self.remoteFans = spots
                }
            case .failure(let error):
                print("CloudKit Fetch Error: \(error.localizedDescription)")
            }
        }
    }
}
