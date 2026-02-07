import SwiftUI

struct FanAnnotationView: View {
    let isCurrent: Bool
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 外圈呼吸灯效果
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: isCurrent ? 30 : 20)
                .scaleEffect(isAnimating ? 1.5 : 1.0)
                .opacity(isAnimating ? 0.0 : 0.5)
            
            // 核心发光点
            Circle()
                .fill(Color.blue)
                .frame(width: isCurrent ? 10 : 6)
                .shadow(color: .blue, radius: isCurrent ? 10 : 4)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
