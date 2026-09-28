import SwiftUI
import TsumoRonCore

struct YakuHelpSheet: View {
    let yakuId: String
    let onDismiss: () -> Void

    private var definition: YakuDefinition? {
        YakuDefinition.definitions[yakuId]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let def = definition {
                        // 役名と翻数
                        VStack(alignment: .leading, spacing: 8) {
                            Text(def.name)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appPrimary)

                            HStack(spacing: 12) {
                                Label("\(def.menzenHan)翻", systemImage: "star.fill")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.appAccent)

                                if let nakiHan = def.nakiHan {
                                    Label("鳴き\(nakiHan)翻", systemImage: "star")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Color.appTextSecondary)
                                } else {
                                    Label("門前のみ", systemImage: "lock.fill")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Color.appTextSecondary)
                                }
                            }
                        }
                        .padding(.horizontal)

                        Divider()
                            .padding(.horizontal)

                        // 説明文
                        VStack(alignment: .leading, spacing: 12) {
                            Text("役の説明")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appPrimary)

                            Text(def.description)
                                .font(.system(size: 16, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)
                                .lineSpacing(6)
                        }
                        .padding(.horizontal)

                        // 牌姿例
                        if let example = def.example {
                            Divider()
                                .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 12) {
                                Text("牌姿例")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.appPrimary)

                                HandView(example: example)
                                    .padding(.vertical, 8)
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        Text("役の情報が見つかりません")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(Color.appTextSecondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    YakuHelpSheet(yakuId: "tanyao") {}
}

#Preview("平和") {
    YakuHelpSheet(yakuId: "pinfu") {}
}

#Preview("清一色") {
    YakuHelpSheet(yakuId: "chinitsu") {}
}
