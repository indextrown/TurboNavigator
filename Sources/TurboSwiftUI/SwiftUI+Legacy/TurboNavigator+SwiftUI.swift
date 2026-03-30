// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI

// MARK: - AppRouter
public protocol Router {
    associatedtype Path: Hashable
    associatedtype Sheet: Identifiable = Never
    associatedtype FullSheet: Identifiable = Never
    associatedtype Overlay: Identifiable = Never
    
    associatedtype PathView: View
    associatedtype SheetView: View
    associatedtype FullSheetView: View
    associatedtype OverlayView: View
    
    @ViewBuilder
    static func build(path: Path) -> PathView
    
    @ViewBuilder
    static func build(sheet: Sheet) -> SheetView
    
    @ViewBuilder
    static func build(fullSheet: FullSheet) -> FullSheetView
    
    @ViewBuilder
    static func build(overlay: Overlay) -> OverlayView
}

#if !swift(>=5.9)
extension Never: Identifiable {
    public var id: Never { self }
}
#endif

// MARK: - Optional Default
public extension Router {
    
    @ViewBuilder
    static func build(sheet: Sheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    static func build(fullSheet: FullSheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    static func build(overlay: Overlay) -> some View {
        EmptyView()
    }
}

// MARK: - Coordinator
public final class Coordinator<R: Router>: ObservableObject {
    public typealias Path = R.Path
    public typealias Sheet = R.Sheet
    public typealias FullSheet = R.FullSheet
    public typealias Overlay = R.Overlay
    
    @Published public var paths: [Path] = []
    @Published public var sheet: Sheet? = nil
    @Published public var fullSheet: FullSheet? = nil
    @Published public var overlay: Overlay? = nil
    
    public init() {}
}

// MARK: - Coordinator Navigation
public extension Coordinator {
    enum RouteEvent {
        // push / pop
        case push(Path)
        case pop
        case popToRoot
        case popTo(Path)
        
        // present
        case sheet(Sheet)
        case full(FullSheet)
        case overlay(Overlay)
        
        // dismiss
        case dismissSheet
        case dismissFull
        case dismissOverlay
    }
    
    func route(_ event: RouteEvent) {
        switch event {
            
        // MARK: - Push
        case .push(let path):
            guard paths.last != path else { return }
            paths.append(path)
            
        case .pop:
            guard !paths.isEmpty else { return }
            paths.removeLast()
            
        case .popToRoot:
            paths.removeAll()
            
        case .popTo(let path):
            guard let index = paths.firstIndex(of: path) else { return }
            // paths = Array(paths.prefix(index + 1))
            
            
            // in-place로 잘라서 복사 제거
            paths.removeSubrange(index + 1..<paths.count)
            
        // MARK: - Present
        case .sheet(let route):
            sheet = route
            
        case .full(let route):
            fullSheet = route
            
        case .overlay(let route):
            overlay = route
            
        // MARK: - Dismiss
        case .dismissSheet:
            sheet = nil
            
        case .dismissFull:
            fullSheet = nil
            
        case .dismissOverlay:
            overlay = nil
        }
    }
}

// MARK: - Coordinator Container
@MainActor
public struct CoordinatorContainer<
    R: Router,
    Root: View
>: View {
    
    @StateObject private var coordinator: Coordinator<R>
    private let rootView: Root
    
    public init(
        coordinator: Coordinator<R>,
        @ViewBuilder rootView: () -> Root
    ) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.rootView = rootView()
    }
    
    public var body: some View {
        ZStack {
            NavigationStack(path: $coordinator.paths) {
                rootView
                    .navigationDestination(for: R.Path.self) {
                        R.build(path: $0)
                    }
            }
            .environmentObject(coordinator)
            .sheet(item: $coordinator.sheet) {
                R.build(sheet: $0)
            }
            .fullScreenCover(item: $coordinator.fullSheet) {
                R.build(fullSheet: $0)
            }
            if let overlay = coordinator.overlay {
                R.build(overlay: overlay)
            }
        }
    }
}





// 외부
enum MyRouter: Router {

    enum Path: Hashable {
        case empty
    }
//    
//    enum Sheet: Identifiable {
//        var id: String { String(describing: self) }
//        case empty
//    }
//    
//    enum FullSheet: Identifiable {
//        var id: String { String(describing: self) }
//        case empty
//    }
//    
//    enum Overlay: Identifiable {
//        var id: String { String(describing: self) }
//        case empty
//    }
}

extension MyRouter {
    @ViewBuilder
    static func build(path: MyRouter.Path) -> some View {
        switch path {
        case .empty:
            EmptyView()
        }
    }
    
//    @ViewBuilder
//    static func build(sheet: MyRouter.Sheet) -> some View {
//        switch sheet {
//        case .empty:
//            EmptyView()
//        }
//    }
//    
//    @ViewBuilder
//    static func build(fullSheet: MyRouter.FullSheet) -> some View {
//        switch fullSheet {
//        case .empty:
//            EmptyView()
//        }
//    }
//    
//    @ViewBuilder
//    static func build(overlay: MyRouter.Overlay) -> some View {
//        switch overlay {
//        case .empty:
//            Color.black.opacity(0.4).ignoresSafeArea()
//        }
//    }
}

struct SampleView: View {
    @StateObject var coordinator = Coordinator<MyRouter>()
    
    var body: some View {
        CoordinatorContainer(coordinator: coordinator) {
            VStack {
                Button {
                    coordinator.route(.push(.empty))
                } label: {
                    Text("Detail 이동")
                }
                
//                Button {
//                    coordinator.route(.sheet(.empty))
//                } label: {
//                    Text("Sheet 이동")
//                }
                
//                Button {
//                    coordinator.route(.full(.empty))
//                } label: {
//                    Text("fullSheet 이동")
//                }
//                
//                Button {
//                    coordinator.route(.overlay(.empty))
//                } label: {
//                    Text("overlay 이동")
//                }
            }
        }
    }
}

#Preview {
    SampleView()
}
