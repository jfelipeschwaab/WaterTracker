import SwiftUI

struct Home: View {
    @ObservedObject var waterManager: WaterManager
    @State private var showNotificationSetupView = false
    @State private var showGoalEditSheet = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("💧 Aqua")
                    .font(.largeTitle.bold())
                    .foregroundColor(.blue.opacity(0.8))

                // Círculo de progresso
                ZStack {
                    Circle()
                        .stroke(lineWidth: 25)
                        .foregroundColor(Color.blue.opacity(0.15))

                    Circle()
                        .trim(from: 0, to: CGFloat(waterManager.getProgress()))
                        .stroke(
                            LinearGradient(colors: [.blue, .cyan],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 25, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: waterManager.getProgress())

                    VStack {
                        Text("\(Int(waterManager.getProgress() * 100))%")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.blue)

                        HStack(spacing: 5) {
                            Text("\(Int(waterManager.registerOfTheDay?.totalAmount ?? 0)) / \(Int(waterManager.registerOfTheDay?.goalAmount ?? 0)) ml")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Button {
                                showGoalEditSheet = true
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 22))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Editar meta diária")
                        }
                    }
                }
                .frame(width: 220, height: 220)
                .padding(.top, 20)

                // Controle de quantidade a adicionar
                VStack(spacing: 10) {
                    Text("Quantidade a adicionar")
                        .font(.headline)

                    HStack {
                        Text("\(Int(waterManager.valueToAlwaysAdd)) ml")
                            .font(.title2.bold())
                            .foregroundColor(.blue)

                        Slider(value: $waterManager.valueToAlwaysAdd, in: 50...1000, step: 50)
                            .tint(.blue)
                            .frame(width: 200)
                    }
                }

                // Botão de adicionar água
                Button {
                    withAnimation(.easeInOut) {
                        if !NotificationManager.shared.hasSeenNotificationPrompt {
                            NotificationManager.shared.setHasSeenNotificationPrompt()
                            showNotificationSetupView = true
                        } else {
                            waterManager.updateTotalAmount()
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.title2)
                        Text("Adicionar Água")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 250)
                    .background(
                        LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }

                // Botão de reset
                Button {
                    waterManager.resetProgress()
                } label: {
                    Text("Resetar progresso diário")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250)
                        .background(Color.red)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }

                Spacer()
            }
            .padding(.top, 80)
            .sheet(isPresented: $showNotificationSetupView) {
                NotificationSetupView(waterManager: waterManager)
            }
            .sheet(isPresented: $showGoalEditSheet) {
                GoalEditView(waterManager: waterManager)
            }
        }
    }
}
