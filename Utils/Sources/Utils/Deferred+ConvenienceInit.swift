import Combine

public extension Deferred {

//    init<Output>(
//        futureFrom closure: @escaping () -> Output
//    ) where DeferredPublisher == Future<Output, Never> {
//        self = Deferred { Future { $0(.success(closure())) } }
//    }

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
