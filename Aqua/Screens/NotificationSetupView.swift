import SwiftUI

struct NotificationSetupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var interval: Double = 2 // intervalo em horas
    @State private var animateDrop = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.cyan.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Ícone ou animação de gota
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .foregroundColor(.blue)
                    .opacity(animateDrop ? 1 : 0.6)
                    .scaleEffect(animateDrop ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateDrop)
                    .onAppear { animateDrop = true }
                
                // Texto explicativo
                VStack(spacing: 10) {
                    Text("Lembretes de Hidratação")
                        .font(.title.bold())
                        .foregroundColor(.blue.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Escolha o intervalo que deseja receber notificações para beber água e manter-se saudável.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                VStack {
                    Text("Intervalo: \(Int(interval)) \(Int(interval) == 1 ? "hora" : "horas")")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Slider(value: $interval, in: 1...12, step: 1)
                        .tint(.blue)
                        .padding(.horizontal, 40)
                }
                
                // Botão de ativar notificações
                Button {
                    let seconds = interval * 3600
                    NotificationManager.shared.saveInterval(seconds: seconds)
                    
                    NotificationManager.shared.requestAuthorization { granted in
                        if granted {
                            NotificationManager.shared.scheduleWaterNotification()
                        }
                        DispatchQueue.main.async {
                            dismiss()
                        }
                    }
                    
                } label: {
                    Text("Ativar lembretes")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Não quero notificações")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                }
                
                Spacer()
            }
            .padding(.vertical, 50)
        }
    }
}

#Preview {
    NotificationSetupView()
}
