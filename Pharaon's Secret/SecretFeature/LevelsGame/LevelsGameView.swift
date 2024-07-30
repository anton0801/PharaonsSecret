import SwiftUI

struct LevelsGameView: View {
    
    @Environment(\.presentationMode) var prem
    @StateObject var vm = LevelsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            prem.wrappedValue.dismiss()
                        } label: {
                            Image("back_btn")
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                VStack {
                    HStack {
                        Image("heart_active")
                            .resizable()
                            .frame(width: 42, height: 42)
                        Image("heart_active")
                            .resizable()
                            .frame(width: 42, height: 42)
                        Image("heart_active")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Image("pharaon")
                }
                .offset(y: 200)
                
                VStack {
                    Text("PLAY")
                        .font(.custom("InknutAntiqua-Regular", size: 42))
                        .foregroundColor(.white)
                        .padding(.top, 6)
                    LazyVGrid(columns: [
                        GridItem(.fixed(90)),
                        GridItem(.fixed(90)),
                        GridItem(.fixed(90)),
                        GridItem(.fixed(90))
                    ], spacing: 0) {
                        ForEach(vm.levels, id: \.id) { level in
                            ZStack {
                                Image("level_placeholder")
                                if level.isUnlocked {
                                    NavigationLink(destination: SceneViewGame(level: level)
                                        .environmentObject(vm)
                                        .navigationBarBackButtonHidden(true)) {
                                            Text("\(level.id)")
                                                .font(.custom("InknutAntiqua-Regular", size: 42))
                                                .foregroundColor(.white)
                                                .padding(0)
                                        }
                                        .padding(0)
                                } else {
                                    Image("lock")
                                }
                            }
                            .padding(.top)
                        }
                    }
                    
                    Spacer()
                }
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
}

#Preview {
    LevelsGameView()
}
