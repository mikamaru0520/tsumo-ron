import SwiftUI

/// ルビ（ふりがな）付きテキストを表示するビュー
struct RubyText: View {
    let text: String
    let ruby: String
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let color: Color

    init(
        _ text: String,
        ruby: String,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .regular,
        color: Color = .primary
    ) {
        self.text = text
        self.ruby = ruby
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.color = color
    }

    var body: some View {
        VStack(spacing: 0) {
            // ルビ（小さい文字）
            Text(ruby)
                .font(.system(size: fontSize * 0.5, weight: .medium, design: .rounded))
                .foregroundStyle(color.opacity(0.7))

            // 本文
            Text(text)
                .font(.system(size: fontSize, weight: fontWeight, design: .rounded))
                .foregroundStyle(color)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        RubyText("立直", ruby: "リーチ", fontSize: 20, fontWeight: .bold)
        RubyText("断么九", ruby: "タンヤオ", fontSize: 20, fontWeight: .bold)
        RubyText("一盃口", ruby: "イーペーコー", fontSize: 20, fontWeight: .bold)
        RubyText("混一色", ruby: "ホンイーソー", fontSize: 20, fontWeight: .bold)
    }
    .padding()
}
