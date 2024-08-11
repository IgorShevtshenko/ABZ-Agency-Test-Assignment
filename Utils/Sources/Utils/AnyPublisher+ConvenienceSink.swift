import Combine
import Foundation

public extension AnyPublisher {

    func sink() -> AnyCancellable where Failure == Never {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

public extension Publisher {

    func sink(
        receiveValue: @escaping (Self.Output) -> Void = { _ in },
        receiveSuccess: @escaping () -> Void = {},
        receiveFailure: @escaping (Failure) -> Void = { _ in }
    ) -> AnyCancellable {
        sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    receiveSuccess()
                case .failure(let error):
                    receiveFailure(error)
                }
            },
            receiveValue: { receiveValue($0) }
        )
    }
}
