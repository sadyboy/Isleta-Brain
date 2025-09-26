import SwiftUI
import WebKit

extension UIImage {
    static func gradientImage(colors: [UIColor], size: CGSize = CGSize(width: 1, height: 64)) -> UIImage? {
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        
        UIGraphicsBeginImageContext(layer.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

@main
struct WirepenApp: App {
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if let gradientImage = UIImage.gradientImage(
            colors: [UIColor.back2, UIColor.back1]
        ) {
            appearance.backgroundImage = gradientImage
        }
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isOnboardingCompleted {
                    MainTabView()
                } else {
                    OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                }
            }
            .environment(\.colorScheme, .dark)
            .preferredColorScheme(.dark)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock =
    UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication,supportedInterfaceOrientationsFor window:UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
