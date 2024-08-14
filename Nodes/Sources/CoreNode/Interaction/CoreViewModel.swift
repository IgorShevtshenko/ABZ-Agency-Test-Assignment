import Architecture
import Combine

public final class CoreViewModel: ViewModel<CoreState, CoreAction> {
    
    private let events = PassthroughSubject<CoreEvent, Never>()
    
    public init() {
        super.init(initial: .init(), dataEvents: events, reducer: Self.reduce)
    }
    
    private static func reduce(state: State, event: CoreEvent) -> State {
        var state = state
        switch event {
        case .didChangeTab(let tab):
            state.activeTab = tab
        }
        return state
    }
    
    public override func send(_ action: CoreAction) {
        switch action {
        case .changeTab(let tab):
            events.send(.didChangeTab(tab))
        }
    }
}
