import SwiftUI

struct ContentView: View {
    
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
    
    init() {
        settingsVolumApp = UserDefaults.standard.bool(forKey: "volum_app")
        soundsApp = UserDefaults.standard.bool(forKey: "sounds")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
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
                
                Button {
                    exitApplication()
                } label: {
                    Image("exit_btn")
                }
                
                NavigationLink(destination: LevelsGameView()
                    .navigationBarBackButtonHidden(true)) {
                    Image("play_btn")
                }
                
                Image("pharaon")
            }
            .background(
                Image("secret_bg")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func exitApplication() {
        finish(code: 0)
    }
    
    private func finish(code: Int32) {
        exit(code)
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
    ContentView()
}
