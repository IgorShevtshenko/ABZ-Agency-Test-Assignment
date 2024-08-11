import Combine

public typealias ProtectedPublisher<Output> = AnyPublisher<Output, Never>
public typealias Completable<Failure: Error> = AnyPublisher<Never, Failure>

public extension Publisher where Output == Never {
    
    func setOutputType<NewOutput>(
        to outputType: NewOutput.Type
    ) -> Publishers.Map<Self, NewOutput> {
        map { _ -> NewOutput in }
    }
}
