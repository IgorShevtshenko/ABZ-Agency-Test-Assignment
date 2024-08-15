import Combine
import SwiftUI

open class ViewModel<State, Action>: ObservableObject {
    
    public typealias State = State
    public typealias Action = Action
    
    @Published public private(set) var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    public init<Event, EventPublisher: Publisher>(
        initial: State,
        dataEvents: EventPublisher,
        reducer: @escaping (State, Event) -> State
    ) where EventPublisher.Output == Event, EventPublisher.Failure == Never {
        state = initial
        dataEvents
            .scan(initial, reducer)
            .assign(to: &$state)
    }
    
    open func send(_ action: Action) {}
}
