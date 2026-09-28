import SwiftUI
import TsumoRonCore

struct ContentView: View {
    @State private var state = AppState()
    private let reducer = AppReducer()

    // 役を翻数ごとにグループ分け
    private let yakuByHan: [(han: Int, yaku: [YakuDefinition])] = [
        (1, YakuDefinition.definitions.values.filter { $0.menzenHan == 1 && $0.id != "riichi" && $0.id != "ippatsu" && $0.id != "double_riichi" && $0.id != "tsumo" && $0.id != "haitei" && $0.id != "houtei" && $0.id != "rinshan" && $0.id != "chankan" && !["ton", "nan", "sha", "pei", "haku", "hatsu", "chun"].contains($0.id) }.sorted(by: { $0.id < $1.id })),
        (2, YakuDefinition.definitions.values.filter { $0.menzenHan == 2 }.sorted(by: { $0.id < $1.id })),
        (3, YakuDefinition.definitions.values.filter { $0.menzenHan == 3 }.sorted(by: { $0.id < $1.id })),
        (6, YakuDefinition.definitions.values.filter { $0.menzenHan == 6 }.sorted(by: { $0.id < $1.id }))
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                LinearGradient(
                    colors: [Color.appBackground, Color.appPrimaryLight.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // 役のセクション
                        ForEach(yakuByHan, id: \.han) { group in
                            yakuSection(han: group.han, yaku: group.yaku)
                        }

                        // その他セクション
                        otherSection
                    }
                    .padding()
                    .padding(.bottom, 100)  // 計算ボタン分の余白
                }

                // 計算ボタン（固定表示）
                VStack {
                    Spacer()
                    calculateButton
                }
            }
            .navigationTitle("ツモロン")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                // 計算結果モーダル
                if state.isResultPresented, let score = state.calculatedScore {
                    ModalOverlay {
                        ResultModal(
                            score: score,
                            onDismiss: { send(.resultDismissed) },
                            onReset: { send(.resetTapped) }
                        )
                    }
                }

                // 役の説明モーダル
                if let yakuId = state.helpYakuId {
                    ModalOverlay {
                        YakuHelpModal(yakuId: yakuId) {
                            send(.helpDismissed)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func yakuSection(han: Int, yaku: [YakuDefinition]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // セクションヘッダー
            Text("\(han)翻")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 4)

            // 役ボタン
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(yaku, id: \.id) { def in
                    yakuButtonRow(def)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private var otherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("その他")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                // 役牌
                Stepper("役牌: \(state.yakuhaiCount)", value: Binding(
                    get: { state.yakuhaiCount },
                    set: { send(.yakuhaiCountChanged($0)) }
                ), in: 0...4)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appCardBackground)
                )

                // ドラ
                Stepper("ドラ: \(state.doraCount)", value: Binding(
                    get: { state.doraCount },
                    set: { send(.doraCountChanged($0)) }
                ), in: 0...10)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appCardBackground)
                )

                // 符
                HStack {
                    Text("符")
                        .font(.system(size: 16, weight: .medium, design: .rounded))

                    Spacer()

                    Picker("", selection: Binding(
                        get: { state.fu },
                        set: { send(.fuChanged($0)) }
                    )) {
                        ForEach([20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 110], id: \.self) { fu in
                            Text("\(fu)符").tag(fu)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appCardBackground)
                )

                // 鳴きあり
                Toggle("鳴きあり", isOn: Binding(
                    get: { state.isNaki },
                    set: { _ in send(.nakiToggled) }
                ))
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appCardBackground)
                )

                // 親/子
                VStack(alignment: .leading, spacing: 8) {
                    Text("親/子")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextSecondary)

                    Picker("", selection: Binding(
                        get: { state.playerType },
                        set: { send(.playerTypeChanged($0)) }
                    )) {
                        Text("親").tag(PlayerType.dealer)
                        Text("子").tag(PlayerType.nonDealer)
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appCardBackground)
                )

                // ツモ/ロン
                VStack(alignment: .leading, spacing: 8) {
                    Text("ツモ/ロン")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextSecondary)

                    Picker("", selection: Binding(
                        get: { state.winType },
                        set: { send(.winTypeChanged($0)) }
                    )) {
                        Text("ツモ").tag(WinType.tsumo)
                        Text("ロン").tag(WinType.ron)
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appCardBackground)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private func yakuButtonRow(_ def: YakuDefinition) -> some View {
        HStack(spacing: 4) {
            // 役名ボタン
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    send(.yakuTapped(def.id))
                }
            } label: {
                HStack {
                    Text(def.name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Spacer()

                    // 鳴き時の翻数表示
                    if state.isNaki, let nakiHan = def.nakiHan {
                        Text("\(nakiHan)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(state.selectedYaku.contains(def.id) ? Color.appPrimary : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            state.selectedYaku.contains(def.id) ? Color.clear : Color.appPrimary,
                            lineWidth: 2
                        )
                )
            }
            .foregroundStyle(state.selectedYaku.contains(def.id) ? .white : Color.appPrimary)
            .disabled(!state.isSelectable(def.id))
            .opacity(state.isSelectable(def.id) ? 1.0 : 0.4)
            .sensoryFeedback(.selection, trigger: state.selectedYaku.contains(def.id))

            // ? ボタン
            Button {
                send(.helpTapped(def.id))
            } label: {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.appAccentYellow)
            }
            .sensoryFeedback(.selection, trigger: state.helpYakuId != nil)
        }
    }

    @ViewBuilder
    private var calculateButton: some View {
        VStack(spacing: 0) {
            // グラデーション境界
            LinearGradient(
                colors: [Color.appBackground.opacity(0), Color.appBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 20)

            // ボタン
            Button {
                send(.calculateTapped)
            } label: {
                HStack {
                    Text(state.hasYaku ? "計算する" : "役を選んでください")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    if state.hasYaku {
                        Spacer()
                        Text("\(state.totalHan)翻")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(state.hasYaku ? Color.appAccent : Color.appTextSecondary)
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            }
            .disabled(!state.hasYaku)
            .padding(.horizontal)
            .padding(.bottom)
            .background(Color.appBackground)
            .sensoryFeedback(.impact, trigger: state.isResultPresented)
        }
    }

    private func send(_ intent: AppIntent) {
        reducer.reduce(state: state, intent: intent)
    }
}

#Preview("ライト") {
    ContentView()
}

#Preview("ダーク") {
    ContentView()
        .preferredColorScheme(.dark)
}
