# 技术栈与架构 (Mayday Fan App)

## 1. 核心框架 (iOS Native)
*   **语言**：Swift
*   **UI 框架**：SwiftUI (支持 Glassmorphism 拟态效果)
*   **地图**：MapKit
*   **音乐数据**：MusicKit (获取 Apple Music 播放状态)

## 2. 无后端方案 (Serverless/BaaS)
*   **首选：Apple CloudKit**
    *   **优点**：完全集成于 iOS，无需维护独立服务器，合规性好（数据存在苹果云端），针对个人开发者成本极低。
    *   **功能**：用于存储用户公开的坐标、歌曲 ID、勋章状态。
*   **备选：Firebase** (如需跨平台或更强的实时性)。

## 3. 已安装的 AI 辅助技能 (Skills)
*   `apple-hig-designer` (设计合规性)
*   `ios-glass-ui-designer` (视觉效果)
*   `ios-ux-design` (交互路径)
*   `swiftui-skills` (代码实现)
*   `ios-swiftui-patterns` (架构参考)
*   `swiftui-code-review` (性能审计)
