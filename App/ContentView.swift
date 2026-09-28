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

    var body: some View {
        ZStack {
            // 背景 - Aqua + ぼかし円
            backgroundView

            // メインコンテンツ
            VStack(spacing: 0) {
                // カスタムツールバー
                customToolbar

                // スクロール可能なコンテンツ
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
                    .padding(.bottom, 100)
                }
            }

            // 計算ボタン（浮遊）
            VStack {
                Spacer()
                calculateButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .overlay {
            // モーダル
            if state.isResultPresented, let score = state.calculatedScore {
                ModalOverlay {
                    ResultModal(
                        score: score,
                        onDismiss: { send(.modalDismissed) },
                        onReset: { send(.resetTapped) }
                    )
                }
            }

            if let helpTarget = state.helpTarget, case .yaku(let yakuId) = helpTarget {
                ModalOverlay {
                    YakuHelpModal(yakuId: yakuId) {
                        send(.modalDismissed)
                    }
                }
            }

            if let helpTarget = state.helpTarget, case .yakuhai = helpTarget {
                ModalOverlay {
                    YakuhaiHelpModal {
                        send(.modalDismissed)
                    }
                }
            }

            if state.isSettingsPresented {
                ModalOverlay {
                    SettingsModal(
                        kuiTan: Binding(
                            get: { state.kuiTan },
                            set: { _ in }
                        ),
                        kiriage: Binding(
                            get: { state.kiriage },
                            set: { _ in }
                        ),
                        kazoe: Binding(
                            get: { state.kazoe },
                            set: { _ in }
                        ),
                        onDismiss: { send(.modalDismissed) }
                    )
                }
            }
        }
    }

    // MARK: - Background

    private var backgroundView: some View {
        ZStack {
            // ベース背景色
            Color.appBackground
                .ignoresSafeArea()

            // ぼかし円 - コーラル
            Circle()
                .fill(Color.appPrimary.opacity(0.3))
                .frame(width: 400, height: 400)
                .blur(radius: 100)
                .offset(x: -100, y: -200)

            // ぼかし円 - ミント
            Circle()
                .fill(Color.appAccent.opacity(0.25))
                .frame(width: 350, height: 350)
                .blur(radius: 90)
                .offset(x: 150, y: 100)

            // ぼかし円 - イエロー
            Circle()
                .fill(Color.appAccentYellow.opacity(0.2))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -50, y: 400)
        }
    }

    // MARK: - Custom Toolbar

    private var customToolbar: some View {
        HStack {
            // ロゴマーク + タイトル
            HStack(spacing: 12) {
                TsumoRonMark(size: 32)

                Text("ツモロン")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            // 設定ボタン
            Button {
                send(.settingsTapped)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.glass)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    // MARK: - Yaku Section

    @ViewBuilder
    private func yakuSection(han: Int, yaku: [YakuDefinition]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // セクションヘッダー
            Text("\(han)翻")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            // 役ボタン
            VStack(spacing: 12) {
                ForEach(yaku, id: \.id) { def in
                    yakuButtonRow(def)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.85))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }

    @ViewBuilder
    private func yakuButtonRow(_ def: YakuDefinition) -> some View {
        HStack(spacing: 8) {
            // 役名ボタン
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    send(.yakuTapped(def.id))
                }
            } label: {
                HStack {
                    Text(def.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(
                            state.selectedYaku.contains(def.id) ? .white : Color.appTextPrimary
                        )

                    Spacer()

                    // 鳴き時の翻数
                    if state.isNaki, let nakiHan = def.nakiHan {
                        Text("\(nakiHan)翻")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(
                                state.selectedYaku.contains(def.id)
                                    ? .white.opacity(0.9)
                                    : Color.appTextSecondary
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(
                            state.selectedYaku.contains(def.id)
                                ? Color.appPrimary
                                : Color.appCardBackground
                        )
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            state.selectedYaku.contains(def.id)
                                ? Color.clear
                                : Color.appPrimary.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
            }
            .disabled(!state.isSelectable(def.id))
            .opacity(state.isSelectable(def.id) ? 1.0 : 0.4)
            .sensoryFeedback(.selection, trigger: state.selectedYaku.contains(def.id))

            // ? ボタン
            Button {
                send(.helpTapped(.yaku(def.id)))
            } label: {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.appAccentYellow)
            }
            .sensoryFeedback(.selection, trigger: state.helpTarget != nil)
        }
    }

    // MARK: - Other Section

    @ViewBuilder
    private var otherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("その他")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            VStack(spacing: 12) {
                // 役牌
                HStack {
                    Text("役牌")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextPrimary)

                    Spacer()

                    // ? ボタン
                    Button {
                        send(.helpTapped(.yakuhai))
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.appAccentYellow)
                    }

                    // ステッパー
                    HStack(spacing: 12) {
                        Button {
                            send(.yakuhaiCountChanged(max(0, state.yakuhaiCount - 1)))
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.appTextSecondary)
                        }
                        .disabled(state.yakuhaiCount == 0)

                        Text("\(state.yakuhaiCount)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                            .frame(minWidth: 30)

                        Button {
                            send(.yakuhaiCountChanged(min(4, state.yakuhaiCount + 1)))
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.appPrimary)
                        }
                        .disabled(state.yakuhaiCount == 4)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appCardBackground)
                )

                // ドラ
                HStack {
                    Text("ドラ")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextPrimary)

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            send(.doraCountChanged(max(0, state.doraCount - 1)))
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.appTextSecondary)
                        }
                        .disabled(state.doraCount == 0)

                        Text("\(state.doraCount)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                            .frame(minWidth: 30)

                        Button {
                            send(.doraCountChanged(state.doraCount + 1))
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.appPrimary)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appCardBackground)
                )

                // 符
                HStack {
                    Text("符")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextPrimary)

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
                    .tint(Color.appPrimary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appCardBackground)
                )

                // 鳴きあり
                Toggle(isOn: Binding(
                    get: { state.isNaki },
                    set: { _ in send(.nakiToggled) }
                )) {
                    Text("鳴きあり")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextPrimary)
                }
                .tint(Color.appPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appCardBackground)
                )

                // 親/子
                VStack(alignment: .leading, spacing: 12) {
                    Text("親/子")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
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
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appCardBackground)
                )

                // ツモ/ロン
                VStack(alignment: .leading, spacing: 12) {
                    Text("ツモ/ロン")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
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
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appCardBackground)
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.85))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }

    // MARK: - Calculate Button

    private var calculateButton: some View {
        Button {
            send(.calculateTapped)
        } label: {
            HStack(spacing: 12) {
                Text(state.hasYaku ? "計算する" : "役を選んでください")
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                if state.hasYaku {
                    Spacer()

                    Text("\(state.totalHan)翻")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.3))
                        )
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glassProminent)
        .tint(state.hasYaku ? Color.appAccent : Color.appTextSecondary)
        .disabled(!state.hasYaku)
        .sensoryFeedback(.impact, trigger: state.isResultPresented)
    }

    // MARK: - Helper

    private func send(_ intent: AppIntent) {
        reducer.reduce(state: state, intent: intent)
    }
}

#Preview {
    ContentView()
}
