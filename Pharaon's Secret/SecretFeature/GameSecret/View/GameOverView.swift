import SwiftUI

struct GameOverView: View {
    
    @State var settingsVolumApp = false {
        didSet {
            UserDefaults.standard.set(settingsVolumApp, forKey: "volum_app")
        }
    }
    
    @State var soundsApp = false {
        didSet {
            UserDefaults.standard.set(settingsVolumApp, forKey: "sounds")
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("GAME\nOVER!")
                .font(.custom("InknutAntiqua-Regular", size: 42))
                .foregroundColor(.white)
            
            HStack {
                Button {
                    NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
                } label: {
                    Image("restart_game")
                }
                Button {
                    NotificationCenter.default.post(name: Notification.Name("home_action"), object: nil)
                } label: {
                    Image("home")
                }
            }
            
            HStack(spacing: 24) {
                Button {
                    changeVolumeApp()
                } label: {
                    if settingsVolumApp {
                        Image("volume_app_on")
                    } else {
                        Image("volum_app_off")
                    }
                }
                
                Button {
                    changeSoundsApp()
                } label: {
                    if soundsApp {
                        Image("sounds_on")
                    } else {
                        Image("sounds_off")
                    }
                }
            }
            Spacer()
            
        }
        .background(
            Image("game_result_back")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private func changeVolumeApp() {
        withAnimation(.linear(duration: 0.5)) {
            settingsVolumApp = !settingsVolumApp
        }
    }
    
    private func changeSoundsApp() {
        withAnimation(.linear(duration: 0.5)) {
            soundsApp = !soundsApp
        }
    }
}

#Preview {
    GameOverView()
}
