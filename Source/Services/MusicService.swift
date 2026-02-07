import Foundation
import MusicKit
import Combine

/// 核心音乐服务：负责监听 Apple Music 状态并过滤五月天歌曲
class MusicService: ObservableObject {
    static let shared = MusicService()
    
    // 五月天官方 Artist ID
    private let maydayArtistID = "369211611"
    
    @Published var currentSong: Song?
    @Published var isMaydayNow: Bool = false
    
    private var timer: AnyCancellable?
    
    init() {
        startMonitoring()
    }
    
    /// 开始循环监听（iOS 暂时不支持第三方 App 后台播放状态的高频通知推送，需定期轮询）
    func startMonitoring() {
        timer = Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchCurrentSong()
            }
    }
    
    func fetchCurrentSong() {
        Task {
            // 获取用户最近播放状态
            let musicPlayer = SystemMusicPlayer.shared
            let state = musicPlayer.state
            
            guard let song = musicPlayer.queue.currentEntry?.item as? Song else {
                DispatchQueue.main.async {
                    self.isMaydayNow = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self.currentSong = song
                self.checkIfMayday(song: song)
            }
        }
    }
    
    private func checkIfMayday(song: Song) {
        // 校验逻辑：ID 匹配优先
        let hasArtistID = song.artists?.contains(where: { $0.id.rawValue == maydayArtistID }) ?? false
        let hasKeywords = song.artistName.contains("五月天") || song.artistName.contains("Mayday")
        
        self.isMaydayNow = hasArtistID || hasKeywords
        
        if self.isMaydayNow {
            print("Detected Mayday: \(song.title)")
        }
    }
    
    /// 请求 MusicKit 权限
    func requestPermission(completion: @escaping (Bool) -> Void) {
        Task {
            let status = await MusicAuthorization.request()
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
}
