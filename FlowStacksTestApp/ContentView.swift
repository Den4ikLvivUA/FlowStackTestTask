//
//  ContentView.swift
//  FlowStacksTestApp
//
//  Created by Denys on 18.05.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
           // new navigator here
            NavigationStackNavigator()

        } else {
            // Fallback on earlier versions
            NavigationView {
                DMNavigator()
                    .navigationViewStyle(.stack)
            }
        }
    }
}

struct NavigationStackNavigator: View {
    
    @State var path: [Screen] = [Screen.intro]
    
    enum Screen: Int, Hashable {
        case intro // welcome screen
        case signup // user enters country code and phone number
        case verification // user enters verification code
        case countryCode // user picks country code from list
        case completeProfile // user adds his info
        case dashboard // user can logout
        case capture // live video capture screen
        
        var rawValue: Int {
            switch self {
            case .intro: return 0
            case .signup: return 1
            case .verification: return 2
            case .countryCode: return 3
            case .completeProfile: return 4
            case .dashboard: return 5
            case .capture: return 6
            }
        }
        
        var title: String {
            switch self {
            case .intro: return "INTRO"
            case .signup: return "SIGNUP"
            case .verification: return "VERIFICATION"
            case .countryCode: return "COUNTRY CODE"
            case .completeProfile: return "COMPLETE PROFILE"
            case .dashboard: return "DASHBOARD"
            case .capture: return "CAPTURE"
            }
        }
        
        var next: Screen? {
            let newId = rawValue+1
            return Screen(rawValue: newId)
        }
    }
    
    var body: some View {
        NavigationStack(path: $path, root: {
            Image(systemName: "apple.logo")
                .navigationDestination(for: Screen.self, destination: { screen in
                    switch screen {
                    case .dashboard:
                        DashboardScreen(goToIntro: backToRoot,
                                        goToCapture: nextAction)
                    default:
                        MainView(title: "\(screen.title) screen",
                                 backAction: goBack,
                                 nextAction: nextAction)
                    }
                })
        })
    }
    
    func backToRoot() {
        path = []
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func nextAction() {
        if path.isEmpty {
            path.append(.intro)
        } else if let nextScreen = path.last?.next {
            path.append(nextScreen)
        } else {
            backToRoot()
        }
    }
    
}

struct DashboardScreen: View {
    
    var goToIntro: () -> ()
    var goToCapture: () -> ()

    var body: some View {
        VStack {
            Spacer()

            Text(NavigationStackNavigator.Screen.dashboard.title)
                .padding(.all, 30)

            HStack {
                Button("Intro", action: goToIntro)
                    .padding(.all, 30)

                Button("Capture", action: goToCapture)
                    .padding(.all, 30)
            }.padding()

            Spacer()
        }
    }
}

struct MainView: View {

    var title: String
    var backAction: () -> ()
    var nextAction: () -> ()

    var body: some View {
        VStack {
            Spacer()

            Text(title)
                .padding(.all, 30)

            HStack {
                Button("Back", action: backAction)
                    .padding(.all, 30)

                Button("Next", action: nextAction)
                    .padding(.all, 30)
            }.padding()

            Spacer()
        }
    }
}

// This is the navigator for the app.
struct DMNavigator: View {

    enum Screen {
        case intro
        case nextOne
        case nextTwo
        case last
    }

    @State var routes: Routes<Screen> = [.root(.intro)]
    var body: some View {
        Router($routes) { screen, _ in

            switch screen {
            case .intro:
                MainView(title: "MAIN!!!!",
                         backAction: goBackToRoot,
                         nextAction: { routes.push(.nextOne) } )
            case .nextOne:
                MainView(title: "11111!!!!",
                         backAction: goBack,
                         nextAction: { routes.push(.nextTwo) } )
            case .nextTwo:
                MainView(title: "22222!!!!",
                         backAction: goBack,
                         nextAction: { routes.push(.last) } )
            case .last:
                VStack {
                    Text("LAST")
                        .padding(.all, 30)

                    HStack {
                        Button("Back", action: goBack)
                            .padding(.all, 30)

                        Button("Back to root", action: goBackToRoot )
                            .padding(.all, 30)
                    }.padding()
                }
            }
        }
        .onChange(of: routes, perform: { _ in
            print(routes)
        })
    }

    private func goBack() {
        routes.goBack()
    }

    private func goBackToRoot() {
        routes.goBackToRoot()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
