import SwiftUI

extension View {
    /// `onChange` that hands the new value to the action.
    ///
    /// Before iOS 17 the action closure captures the view value from the body
    /// evaluation that installed it, so anything read back off `self` inside the
    /// action is one update behind. Take the new value as a parameter rather
    /// than reading the captured property.
    @ViewBuilder
    func onChangeCompat<V: Equatable>(of value: V, perform action: @escaping (V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            self.onChange(of: value) { _, newValue in
                action(newValue)
            }
        } else {
            self.onChange(of: value) { newValue in
                action(newValue)
            }
        }
    }
}
