import SwiftUI

/// 2026 五月天巡回演唱会数据模型
struct ConcertInfo: Identifiable {
    let id = UUID()
    let city: String
    let venue: String
    let dateRange: String
    let status: String
}

/// Day 4: 玻璃拟态行程列表组件
struct ConcertListView: View {
    let concerts = [
        ConcertInfo(city: "香港站", venue: "启德主场馆", dateRange: "03.24 - 03.28", status: "待开票"),
        ConcertInfo(city: "北京站", venue: "国家体育场 (鸟巢)", dateRange: "网传近期", status: "筹备中"),
        ConcertInfo(city: "上海站", venue: "上海体育场", dateRange: "待公布", status: "待解锁")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("2026 巡演行程")
                .font(.title3.bold())
                .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(concerts) { concert in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(concert.city)
                                    .font(.headline)
                                Text(concert.venue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(concert.dateRange)
                                    .font(.subheadline.monospaced())
                                Text(concert.status)
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(concert.status == "待开票" ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .foregroundColor(concert.status == "待开票" ? .blue : .secondary)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial) // 核心玻璃材质
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        ConcertListView()
    }
}
