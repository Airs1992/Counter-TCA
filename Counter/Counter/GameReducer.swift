//
//  GameReducer.swift
//  Counter
//
//  Created by hong on 2023/02/26.
//

import Foundation
import ComposableArchitecture

public struct GameReducer: ReducerProtocol {
    public struct State: Equatable {
        var counter: CounterReducer.State = .init()
        var timer: TimerReducer.State = .init()
        var resultList: GameResultListReducer.State = .init()
        var lastTimestamp = 0.0

        // これを入れるによって、GameResultListReducer.Stateは二個あります
        // 自分表示用とプッシュ表示用に分けます
        var resultListState: Identified<UUID, GameResultListReducer.State>?
        var alert: AlertState<GameAlertAction>?
        var savingResults: Bool = false

        var resultListStateModal: Identified<UUID, GameResultListReducer.State>?
    }

    public enum Action {
        case counter(CounterReducer.Action)
        case timer(TimerReducer.Action)
        case resultList(GameResultListReducer.Action)
        case setNavigation(UUID?)
        case alertAction(GameAlertAction)
        case saveResult(Result<Void, URLError>)
        case setSheet(GameResultListReducer.State?)
        case dismissSheet
    }

    public enum GameAlertAction: Equatable {
      case alertSaveButtonTapped
      case alertCancelButtonTapped
      case alertDismiss
    }

    @Dependency(\.mainQueue) var mainQueue

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
                let result = GameResult(counter: state.counter, timeSpent: state.timer.duration - state.lastTimestamp)
                state.resultList.results.append(result)
                state.lastTimestamp = state.timer.duration
                return .none
            case .setNavigation(.some(let id)):
                // ここでresultListStateを新しく作ってナビゲーション発動する事によって、遷移先のGameResultListがstateの変更がある場合、その修正が全てresultListState.value内に渡される、resultListState.valueをresultListに渡さない限り、Gameのstateは昔のままになる（例えばユーザーをstateの変更をやめる場合、昔のstateに戻るのが可能になる）
                state.resultListState = .init(state.resultList, id: id)
                return .none
            case .setNavigation(.none):
                if state.resultListState?.value.results != state.resultList.results {
                    state.alert = .init(
                        title: .init("Save Changes?"),
                        primaryButton: .default(.init("OK"), action: .send(.alertSaveButtonTapped)),
                        secondaryButton: .cancel(.init("Cancel"), action: .send(.alertCancelButtonTapped))
                    )
                } else {
                    state.resultListState = nil
                }
                return .none
            // .alertDismissはアラートがdismissされた後に発動する、その後TCAは具体出来にどのボタンタップされたによってbindingされたアクションを送信する、なので.alertDismiss内でnilを設定する、.alertSaveButtonTappedと.alertCancelButtonTapped内でロジックを書く
            case .alertAction(.alertDismiss):
                state.alert = nil
                return .none
            case .alertAction(.alertSaveButtonTapped):
                // Todo: ここはサーバーリクエストしてresultListを設定するのが一番ですが，一旦直接渡しにします
//                state.resultList.results = state.resultListState?.value.results ?? []
//                state.resultListState = nil
                // ここはdelayでリクエスト模擬する
                state.savingResults = true
                return EffectTask(value: .saveResult(.success(())))
                    .delay(for: 2, scheduler: mainQueue)
                    .eraseToEffect()
            case .alertAction(.alertCancelButtonTapped):
                state.resultListState = nil
                return .none
            // ここのエラー処理は一旦後回しにします
            case .saveResult:
                state.savingResults = false
                state.resultList.results = state.resultListState?.value.results ?? []
                state.resultListState = nil
                return .none
            case .setSheet(item: .some(let item)):
                state.resultListStateModal = .init(state.resultList, id: item.id)
                return .none
            case .dismissSheet:
                state.resultListStateModal = nil
                return .none
            default:
                return .none
            }
        }
        // 子のreducerに入れる前オプショナルの判定を先にやる、非nilの場合子reducerの処理を実行する
        .ifLet(\State.resultListState, action: /Action.resultList) {
            Scope(state: \Identified<UUID, GameResultListReducer.State>.value, action: .self) {
                GameResultListReducer()
            }
        }
        Scope(state: \.counter, action: /Action.counter) {
            CounterReducer()
        }
        Scope(state: \.timer, action: /Action.timer) {
            TimerReducer()
        }
    }
}

extension GameReducer {
    public struct GameResult: Equatable, Identifiable {
        let counter: CounterReducer.State
        let timeSpent: TimeInterval
        var correct: Bool { counter.secret == counter.count }

        public var id: UUID { counter.id }
    }
}
