import UIKit.UIControl

//MARK: - Declarative method
public extension UIControl {
    @discardableResult
    func add(target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        self.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    @discardableResult
    func add(target: Any?, for controlEvents: UIControl.Event, _ actionBuilder: () -> Selector) -> Self {
        self.add(target: target, action: actionBuilder(), for: controlEvents)
    }
    
    @discardableResult
    func addControlAction(target: Any?, for controlEvents: UIControl.Event, _ actionBuilder: () -> Selector) -> Self {
        self.add(target: target, action: actionBuilder(), for: controlEvents)
    }

    @available(iOS 14.0, *)
    @discardableResult
    func addAction(_ controlEvents: UIControl.Event, handler: @escaping UIActionHandler) -> Self {
        self.addAction(.init(handler: handler), for: controlEvents)
        return self
    }

}
