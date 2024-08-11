public enum CompletableResult<Failure: Error> {
    case success
    case failure(Failure)
}
