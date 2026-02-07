import SwiftUI
import MusicKit

struct ContentView: View {
    @StateObject var musicService = MusicService.shared
    @State private var isAuthorized = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 背景地图
            MapView()
                .ignoresSafeArea()
            
            // 底部控制/状态卡片
            VStack {
                if !isAuthorized {
                    Button("授权 Apple Music 以点亮星海") {
                        musicService.requestPermission { authorized in
                            self.isAuthorized = authorized
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                } else if musicService.isMaydayNow {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundColor(.blue)
                        Text("正在听: \(musicService.currentSong?.title ?? "未知曲目")")
                            .font(.headline)
                        Spacer()
                        Text("同频共振中")
                            .font(.caption)
                            .padding(5)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(5)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding()
                } else {
                    Text("播放五月天，点亮你的星位 ✨")
                        .font(.subheadline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
