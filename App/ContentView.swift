import SwiftUI
import TsumoRonCore

struct ContentView: View {
    @State private var selectedYaku: Set<Yaku> = []
    @State private var fu: Int = 30
    @State private var playerType: PlayerType = .nonDealer
    @State private var winType: WinType = .ron
    @State private var calculatedScore: Score?

    private let calculator = ScoreCalculator()
    private let availableYaku = Yaku.commonYaku
    private let fuOptions = [20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 110]

    var body: some View {
        NavigationStack {
            Form {
                Section("役") {
                    ForEach(availableYaku) { yaku in
                        Button {
                            toggleYaku(yaku)
                        } label: {
                            HStack {
                                Text(yaku.name)
                                Spacer()
                                if selectedYaku.contains(yaku) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                                Text("\(yaku.han)翻")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }

                Section("符") {
                    Picker("符", selection: $fu) {
                        ForEach(fuOptions, id: \.self) { fuValue in
                            Text("\(fuValue)符").tag(fuValue)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("親/子") {
                    Picker("親/子", selection: $playerType) {
                        Text("親").tag(PlayerType.dealer)
                        Text("子").tag(PlayerType.nonDealer)
                    }
                    .pickerStyle(.segmented)
                }

                Section("ツモ/ロン") {
                    Picker("ツモ/ロン", selection: $winType) {
                        Text("ツモ").tag(WinType.tsumo)
                        Text("ロン").tag(WinType.ron)
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Button("計算") {
                        calculate()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(selectedYaku.isEmpty)
                }

                if let score = calculatedScore {
                    Section("結果") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("選択した役: \(score.hand.yaku.map(\.name).joined(separator: "・"))")
                                .font(.subheadline)
                            Text("合計: \(score.hand.totalHan)翻 \(score.hand.fu)符")
                                .font(.subheadline)

                            Divider()

                            switch score.payment {
                            case .dealerTsumo(let fromEach):
                                Text("\(fromEach)点∀（各\(fromEach)点）")
                                    .font(.title2)
                                    .bold()
                                Text("総計: \(score.payment.totalPoints)点")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                            case .nonDealerTsumo(let fromDealer, let fromNonDealer):
                                Text("\(fromDealer)点・\(fromNonDealer)点")
                                    .font(.title2)
                                    .bold()
                                Text("親\(fromDealer)点、子各\(fromNonDealer)点")
                                    .font(.subheadline)
                                Text("総計: \(score.payment.totalPoints)点")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                            case .dealerRon(let total):
                                Text("\(total)点")
                                    .font(.title)
                                    .bold()

                            case .nonDealerRon(let total):
                                Text("\(total)点")
                                    .font(.title)
                                    .bold()
                            }
                        }
                    }
                }
            }
            .navigationTitle("ツモロン")
        }
    }

    private func toggleYaku(_ yaku: Yaku) {
        if selectedYaku.contains(yaku) {
            selectedYaku.remove(yaku)
        } else {
            selectedYaku.insert(yaku)
        }
    }

    private func calculate() {
        let hand = Hand(
            yaku: Array(selectedYaku),
            fu: fu,
            playerType: playerType,
            winType: winType
        )
        calculatedScore = calculator.calculate(hand: hand)
    }
}

#Preview {
    ContentView()
}
