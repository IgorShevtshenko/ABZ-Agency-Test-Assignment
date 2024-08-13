import Architecture
import SignUp
import PositionsRepository
import Combine
import SignUpFormValidator

public final class SignUpNewUserViewModel: ViewModel<SignUpNewUserState, SignUpNewUserAction> {
    
    private let events = PassthroughSubject<SignUpNewUserEvent, Never>()
    
    private let signUp: SignUp
    private let signUpFormValidator: SignUpFormValidator
    private let positionsRepository: PositionsRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        signUp: SignUp,
        signUpFormValidator: SignUpFormValidator,
        positionsRepository: PositionsRepository
    ) {
        self.signUp = signUp
        self.signUpFormValidator = signUpFormValidator
        self.positionsRepository = positionsRepository
        
        super.init(
            initial: SignUpNewUserState(),
            dataEvents: events,
            reducer: Self.reduce
        )
        
        send(.fetchPositions)
    }
    
    private static func reduce(state: State, event: SignUpNewUserEvent) -> State {
        var state = state
        switch event {
        case .didChangeInput(let field, let input):
            state.editingInputs[field] = true
            updateState(&state, field: field, input: input)
        case .didDropValidation(let field):
            state.fieldErrors[field] = nil
        case .didFinishEditingField(let field):
            state.editingInputs[field] = false
        case .didChangeValidation(let error, let field):
            state.fieldErrors[field] = error
        case .didChangeAvailablePositions(let positions):
            state.positions = positions
            state.signupResult = nil
        case .didChangePosition(let position):
            state.form.position = position
        case .didChangePhoto(let photo):
            state.form.photo = photo
        case .didRecevieNoInternetConnection:
            state.isNoInternetConnection = true
        }
        return state
    }
    
    public override func send(_ action: SignUpNewUserAction) {
        switch action {
        case .changeInput(let field, let input):
            events.send(.didChangeInput(field, input))
            events.send(.didDropValidation(field))
        case .validateField(let field):
            events.send(.didFinishEditingField(field))
            if let validationError = signUpFormValidator
                .validate(field: field, for: state.form.value(for: field))
            {
                events.send(.didChangeValidation(validationError, field))
            }
        case .changePosition(let position):
            events.send(.didChangePosition(position))
        case .changePhoto(let data):
            events.send(.didChangePhoto(data))
        case .fetchPositions:
            let fetchPositions = positionsRepository.fetchPositions()
            fetchPositions
                .setOutputType(to: SignUpNewUserEvent.self)
                .append(
                    positionsRepository.positions
                        .map(SignUpNewUserEvent.didChangeAvailablePositions)
                        .setFailureType(to: PositionsRepositoryError.self)
                )
                .sink(receiveValue: events.send)
                .store(in: &cancellables)
            fetchPositions
                .setOutputType(to: SignUpNewUserEvent.self)
                .catch { error in
                    switch error {
                    case .noInternetConnection:
                        return Just(SignUpNewUserEvent.didRecevieNoInternetConnection)
                            .eraseToAnyPublisher()
                    case .general:
                        return Empty().eraseToAnyPublisher()
                    }
                }
                .sink(receiveValue: events.send)
                .store(in: &cancellables)
        }
    }
}

private extension SignUpNewUserViewModel {
    
    static func updateState(_ state: inout State, field: SignUpFormField, input: String) {
        switch field {
        case .name:
            state.form.name = input
        case .phone:
            state.form.phone = input
        case .email:
            state.form.email = input
        }
    }
}

private extension SignUpNewUserFormPayload {
    
    func value(for field: SignUpFormField) -> String {
        switch field {
        case .name:
            name
        case .phone:
            phone
        case .email:
            email
        }
    }
}
