import Combine

public extension Deferred {

    init<Output>(
        futureAction closure: @escaping () throws -> Output
    ) where DeferredPublisher == Future<Output, Error> {
        self = Deferred {
            Future { promise in
                do {
                    try promise(.success(closure()))
                } catch {
                    promise(.failure(error as Failure))
                }
            }
        }
    }
}
