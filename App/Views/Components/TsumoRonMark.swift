import SwiftUI

/// ツモロンのロゴマーク（傾いた点棒キャラクター）
struct TsumoRonMark: View {
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            // 点棒本体（細長い長方形を15度傾ける）
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appPrimary,
                            Color.appPrimaryLight
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 2.5, height: size * 0.6)
                .rotationEffect(.degrees(15))
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)

            // 顔の装飾
            HStack(spacing: size * 0.15) {
                // 左目
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.12, height: size * 0.12)

                // 右目
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.12, height: size * 0.12)
            }
            .offset(x: -size * 0.1, y: -size * 0.08)
            .rotationEffect(.degrees(15))

            // 口（小さな弧）
            Arc(startAngle: .degrees(0), endAngle: .degrees(180))
                .stroke(.white, lineWidth: size * 0.06)
                .frame(width: size * 0.25, height: size * 0.15)
                .offset(x: -size * 0.1, y: size * 0.12)
                .rotationEffect(.degrees(15))
        }
        .frame(width: size * 2.8, height: size * 1.2)
    }
}

/// 弧を描くShape
struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )

        return path
    }
}

#Preview("デフォルトサイズ") {
    TsumoRonMark()
        .padding()
        .background(Color.appBackground)
}

#Preview("大きいサイズ") {
    TsumoRonMark(size: 80)
        .padding()
        .background(Color.appBackground)
}

#Preview("小さいサイズ") {
    TsumoRonMark(size: 24)
        .padding()
        .background(Color.appBackground)
}
