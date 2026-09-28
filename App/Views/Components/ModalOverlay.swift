import SwiftUI

/// 半透明背景付きのモーダルオーバーレイ
struct ModalOverlay<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            // 半透明の背景
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            // モーダルコンテンツ
            content
                .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: true)
    }
}
