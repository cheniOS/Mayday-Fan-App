import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var musicService = MusicService.shared
    @StateObject var cloudService = CloudKitService.shared
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            // 1. 显示云端真实粉丝数据
            ForEach(cloudService.remoteFans) { fan in
                Annotation(fan.songTitle, coordinate: fan.coordinate) {
                    FanAnnotationView(isCurrent: false)
                }
            }
            
            // 2. 显示当前用户（我）
            if let userLocation = musicService.currentLocation {
                Annotation("我", coordinate: userLocation) {
                    FanAnnotationView(isCurrent: true)
                }
            }
        }
        .mapStyle(.standard(emphasis: .muted, pointsOfInterest: .excludingAll))
        .onAppear {
            // 定时刷新全球星海
            startHeartbeat()
        }
    }
    
    private func startHeartbeat() {
        cloudService.fetchGlobalFans()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            cloudService.fetchGlobalFans()
            
            // 如果正在听五月天，则同步自己的坐标到云端
            if musicService.isMaydayNow, let loc = musicService.currentLocation {
                cloudService.uploadMySpot(
                    location: loc,
                    songTitle: musicService.currentSong?.title ?? "Mayday",
                    artistName: "五月天"
                )
            }
        }
    }
}

// 补充 MusicService 的坐标支持
extension MusicService {
    var currentLocation: CLLocationCoordinate2D? {
        // 这里需要接入 CLLocationManager 逻辑
        // 暂时返回一个上海 Mock 坐标供测试
        return .init(latitude: 31.23, longitude: 121.47)
    }
}
