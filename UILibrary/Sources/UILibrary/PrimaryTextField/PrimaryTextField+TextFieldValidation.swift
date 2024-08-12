import Combine
import SwiftUI
import Utils

extension PrimaryTextField {

    private enum TextFieldValidationReason {
        case inputChange
        case resignFirstResponder
    }

    class TextFieldValidation: ObservableObject {

        var onValidationUpdate: ProtectedPublisher<Void> {
            _onValidationUpdate.eraseToAnyPublisher()
        }

        private let _onValidationUpdate = PassthroughSubject<Void, Never>()
        private let events = PassthroughSubject<TextFieldValidationReason, Never>()

        private var cancellables = Set<AnyCancellable>()

        init() {
            events
                .map { event -> ProtectedPublisher<Void> in
                    switch event {
                    case .inputChange:
                        Just(())
                            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                            .eraseToAnyPublisher()
                    case .resignFirstResponder:
                        Just(()).eraseToAnyPublisher()
                    }
                }
                .switchToLatest()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: _onValidationUpdate.send)
                .store(in: &cancellables)
        }

        func inputChange() {
            events.send(.inputChange)
        }

        func resignTextField() {
            events.send(.resignFirstResponder)
        }
    }
}
