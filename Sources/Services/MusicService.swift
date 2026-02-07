import Foundation
import MusicKit
import Combine

class MusicService: ObservableObject {
    static let shared = MusicService()
    private let maydayArtistID = "369211611"
    
    @Published var currentSong: Song?
    @Published var isMaydayNow: Bool = false
    private var timer: AnyCancellable?
    
    init() { startMonitoring() }
    
    func startMonitoring() {
        timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.fetchCurrentSong()
        }
    }
    
    func fetchCurrentSong() {
        Task {
            let musicPlayer = SystemMusicPlayer.shared
            guard let song = musicPlayer.queue.currentEntry?.item as? Song else {
                DispatchQueue.main.async { self.isMaydayNow = false }
                return
            }
            DispatchQueue.main.async {
                self.currentSong = song
                self.checkIfMayday(song: song)
            }
        }
    }
    
    private func checkIfMayday(song: Song) {
        let hasArtistID = song.artists?.contains(where: { $0.id.rawValue == maydayArtistID }) ?? false
        let hasKeywords = song.artistName.contains("五月天") || song.artistName.contains("Mayday")
        self.isMaydayNow = hasArtistID || hasKeywords
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        Task {
            let status = await MusicAuthorization.request()
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
}
