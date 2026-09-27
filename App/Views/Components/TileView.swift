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
            // 背景
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)

            // 和了牌のハイライト
            if isWinning {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.appAccentYellow, lineWidth: 3)
            }

            // 牌の内容
            VStack(spacing: 2) {
                switch tile {
                case .manzu(let num):
                    Text(kanjiNumber(num))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appManzu)
                    Text("萬")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appManzu)

                case .pinzu(let num):
                    Text(kanjiNumber(num))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appPinzu)
                    Text("筒")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appPinzu)

                case .souzu(let num):
                    Text(kanjiNumber(num))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appSouzu)
                    Text("索")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appSouzu)

                case .jihai(let type):
                    jihaiView(type)
                }
            }
            .padding(4)
        }
        .frame(width: 32, height: 44)
    }

    @ViewBuilder
    private func jihaiView(_ type: JihaiType) -> some View {
        switch type {
        case .ton:
            Text("東")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)
        case .nan:
            Text("南")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)
        case .sha:
            Text("西")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)
        case .pei:
            Text("北")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)
        case .haku:
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(Color.appTextSecondary, lineWidth: 2)
                .frame(width: 20, height: 20)
        case .hatsu:
            Text("發")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appHatsu)
        case .chun:
            Text("中")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appChun)
        }
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
