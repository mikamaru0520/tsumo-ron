import SwiftUI
import TsumoRonCore

struct TileView: View {
    let tile: Tile
    let isWinning: Bool

    init(_ tile: Tile, isWinning: Bool = false) {
        self.tile = tile
        self.isWinning = isWinning
    }

    var body: some View {
        ZStack {
            // 背景（アイボリー）
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(red: 0.98, green: 0.96, blue: 0.93))
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)

            // 和了牌のハイライト
            if isWinning {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.appAccentYellow, lineWidth: 3)
            }

            // 牌の内容
            VStack(spacing: 1) {
                // 上部：数字や文字
                switch tile {
                case .manzu(let num):
                    manzuContent(num)
                case .pinzu(let num):
                    pinzuContent(num)
                case .souzu(let num):
                    souzuContent(num)
                case .jihai(let type):
                    jihaiContent(type)
                }

                Spacer()

                // 下部：ペンギン
                penguinView()
                    .padding(.bottom, 2)
            }
            .padding(.top, 4)
            .padding(.horizontal, 2)
        }
        .frame(width: 36, height: 50)
    }

    // MARK: - 萬子
    @ViewBuilder
    private func manzuContent(_ num: Int) -> some View {
        VStack(spacing: 0) {
            Text(kanjiNumber(num))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.4, green: 0.5, blue: 0.6))
            Text("萬")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 1.0, green: 0.4, blue: 0.4))
        }
    }

    // MARK: - 索子（縦棒）
    @ViewBuilder
    private func souzuContent(_ num: Int) -> some View {
        HStack(spacing: 2) {
            ForEach(0..<num, id: \.self) { index in
                Capsule()
                    .fill(Color(red: 0.3, green: 0.6, blue: 0.5))
                    .frame(width: 2, height: 12)
            }
        }
        .frame(height: 14)
    }

    // MARK: - 筒子（丸）
    @ViewBuilder
    private func pinzuContent(_ num: Int) -> some View {
        let rows = pinzuLayout(num)
        VStack(spacing: 2) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 2) {
                    ForEach(Array(row.enumerated()), id: \.offset) { index, _ in
                        Circle()
                            .strokeBorder(index % 2 == 0 ? Color(red: 0.5, green: 0.6, blue: 0.75) : Color(red: 1.0, green: 0.6, blue: 0.65), lineWidth: 1.5)
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .frame(height: 18)
    }

    private func pinzuLayout(_ num: Int) -> [[Int]] {
        switch num {
        case 1: return [[0]]
        case 2: return [[0], [0]]
        case 3: return [[0], [0], [0]]
        case 4: return [[0, 0], [0, 0]]
        case 5: return [[0, 0], [0], [0, 0]]
        case 6: return [[0, 0, 0], [0, 0, 0]]
        case 7: return [[0, 0], [0, 0, 0], [0, 0]]
        case 8: return [[0, 0, 0], [0, 0], [0, 0, 0]]
        case 9: return [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        default: return [[0]]
        }
    }

    // MARK: - 字牌
    @ViewBuilder
    private func jihaiContent(_ type: JihaiType) -> some View {
        switch type {
        case .ton:
            Text("東")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.4, green: 0.5, blue: 0.6))
        case .nan:
            Text("南")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.4, green: 0.5, blue: 0.6))
        case .sha:
            Text("西")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.4, green: 0.5, blue: 0.6))
        case .pei:
            Text("北")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.4, green: 0.5, blue: 0.6))
        case .haku:
            Text("白")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.5, green: 0.6, blue: 0.7))
        case .hatsu:
            Text("發")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.3, green: 0.65, blue: 0.5))
        case .chun:
            Text("中")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 1.0, green: 0.4, blue: 0.45))
        }
    }

    // MARK: - ペンギン
    @ViewBuilder
    private func penguinView() -> some View {
        ZStack {
            // 体（円形）
            Circle()
                .fill(Color(red: 0.5, green: 0.6, blue: 0.7))
                .frame(width: 14, height: 14)

            // お腹（白い楕円）
            Ellipse()
                .fill(Color.white.opacity(0.9))
                .frame(width: 8, height: 10)
                .offset(y: 1)

            // 目
            HStack(spacing: 3) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 2.5, height: 2.5)
                Circle()
                    .fill(Color.white)
                    .frame(width: 2.5, height: 2.5)
            }
            .offset(y: -2)

            // くちばし
            Circle()
                .fill(Color(red: 1.0, green: 0.7, blue: 0.3))
                .frame(width: 2, height: 2)
                .offset(y: 1)
        }
        .frame(width: 16, height: 16)
    }

    private func kanjiNumber(_ num: Int) -> String {
        switch num {
        case 1: return "一"
        case 2: return "二"
        case 3: return "三"
        case 4: return "四"
        case 5: return "五"
        case 6: return "六"
        case 7: return "七"
        case 8: return "八"
        case 9: return "九"
        default: return "\(num)"
        }
    }
}

/// 牌姿を表示するビュー
struct HandView: View {
    let example: YakuExample

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 面子ごとに表示
            ForEach(Array(example.melds.enumerated()), id: \.offset) { index, meld in
                HStack(spacing: 2) {
                    ForEach(Array(meld.tiles.enumerated()), id: \.offset) { tileIndex, tile in
                        TileView(
                            tile,
                            isWinning: tile == example.winningTile
                        )
                    }
                }
            }

            // 雀頭
            if !example.pair.isEmpty && example.melds.isEmpty {
                // 七対子の場合
                let pairs = stride(from: 0, to: example.pair.count, by: 2).map {
                    Array(example.pair[$0..<min($0+2, example.pair.count)])
                }
                FlowLayout(spacing: 8) {
                    ForEach(Array(pairs.enumerated()), id: \.offset) { pairIndex, pair in
                        HStack(spacing: 2) {
                            ForEach(Array(pair.enumerated()), id: \.offset) { tileIndex, tile in
                                TileView(
                                    tile,
                                    isWinning: tile == example.winningTile
                                )
                            }
                        }
                    }
                }
            } else {
                // 通常の雀頭
                HStack(spacing: 2) {
                    ForEach(Array(example.pair.enumerated()), id: \.offset) { index, tile in
                        TileView(
                            tile,
                            isWinning: tile == example.winningTile
                        )
                    }
                }
            }
        }
    }
}

/// 自動折り返しレイアウト
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    // 改行
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                x += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview("萬子") {
    HStack {
        TileView(.manzu(1))
        TileView(.manzu(5))
        TileView(.manzu(9))
    }
}

#Preview("筒子") {
    HStack {
        TileView(.pinzu(2))
        TileView(.pinzu(5))
        TileView(.pinzu(8))
    }
}

#Preview("索子") {
    HStack {
        TileView(.souzu(3))
        TileView(.souzu(6))
        TileView(.souzu(9))
    }
}

#Preview("字牌") {
    HStack {
        TileView(.jihai(.ton))
        TileView(.jihai(.haku))
        TileView(.jihai(.hatsu))
        TileView(.jihai(.chun))
    }
}

#Preview("和了牌") {
    TileView(.manzu(5), isWinning: true)
}
