import UIKit.UIView

public struct UIEdgeBools {
    public var top: Bool = true
    public var leading: Bool = true
    public var bottom: Bool = true
    public var trailing: Bool = true
    
    public init(top: Bool = true, leading: Bool = true, bottom: Bool = true, trailing: Bool = true) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    public init(all: Bool) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }

    public init(vertical: Bool) {
        self.init(top: vertical, leading: true, bottom: vertical, trailing: true)
    }
    
    public init(horizontal: Bool) {
        self.init(top: true, leading: horizontal, bottom: true, trailing: horizontal)
    }
}

public struct UIEdgePriorities {
    public var top: UILayoutPriority = .required
    public var leading: UILayoutPriority = .required
    public var bottom: UILayoutPriority = .required
    public var trailing: UILayoutPriority = .required
    
    public init(top: UILayoutPriority = .required, leading: UILayoutPriority = .required, bottom: UILayoutPriority = .required, trailing: UILayoutPriority = .required) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    public init(all: UILayoutPriority) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }

    public init(vertical: UILayoutPriority) {
        self.init(top: vertical, leading: .required, bottom: vertical, trailing: .required)
    }
    
    public init(horizontal: UILayoutPriority) {
        self.init(top: .required, leading: horizontal, bottom: .required, trailing: horizontal)
    }
}

public extension UIEdgeInsets {
    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    init(vertical: CGFloat) {
        self.init(top: vertical, left: 0, bottom: vertical, right: 0)
    }
    
    init(horizontal: CGFloat) {
        self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }
}

//MARK: - instance
public extension UIView {

    convenience init(tag: Int = 0) {
        self.init()
        self.tag = tag
    }

    convenience init(tag: Int = 0, _ imperative: ((Self) -> Void)) {
        self.init()
        self.tag = tag
        imperative(self)
    }
    
    func declarate(
priorities: UIEdgePriorities,
    @SingleUIViewBuilder _ builder: () -> UIView) {
        let view = builder()
        self.subviews.forEach { $0.removeFromSuperview() }
        self.edgesConstraints(view, safeAreas: .init(), priorities: priorities)
    }
    
    func declarate(@SingleUIViewBuilder _ builder: () -> UIView) {
        self.declarate(priorities: .init(), builder)
    }
    
    static func spacer() -> UIView {
        UIView {
            $0.isUserInteractionEnabled = false
        }
    }
    
    static func divider() -> UIView {
        UIView.spacer().height(0.5).backgroundColor(.lightGray)
    }
}

//MARK: - Declarative method
public extension UIView {
    
    @discardableResult
    func imperative(_ imperative: ((UIView) -> Void)) -> Self {
        imperative(self)
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask) -> Self {
        imperative {
            $0.layer.cornerRadius = radius
            $0.layer.maskedCorners = maskedCorners
        }
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        cornerRadius(radius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
    }
    
    @discardableResult
    func border(color: UIColor, width: CGFloat) -> Self {
        imperative {
            $0.layer.borderColor = color.cgColor
            $0.layer.borderWidth = width
        }
    }
    
    @discardableResult
    func tag(_ tag: Int) -> Self {
        imperative {
            $0.tag = tag
        }
    }
    
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> Self {
        imperative {
            $0.backgroundColor = backgroundColor
        }
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        imperative {
            $0.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        imperative {
            $0.clipsToBounds = clipsToBounds
        }
    }

    @discardableResult
    func contentMode(_ contentMode: ContentMode) -> Self {
        imperative {
            $0.contentMode = contentMode
        }
    }
    
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        imperative {
            $0.alpha = alpha
        }
    }
    
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        imperative {
            $0.isHidden = isHidden
        }
    }
    
    @discardableResult
    func isShow(_ isShow: Bool) -> Self {
        isHidden(!isShow)
    }
    
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Self {
        imperative {
            $0.transform = transform
        }
    }
    
    @discardableResult
    func shadow(color: UIColor = .black, radius: CGFloat = 0.0, x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        imperative {
            $0.layer.shadowColor = color.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: x, height: y)
            $0.layer.shadowRadius = radius
        }
    }
    
    @discardableResult
    func addSubview(
margin: UIEdgeInsets = .zero,
    @ArrayUIViewBuilder _ builder: () -> [UIView?]) -> Self {
        self.zStack(margin: margin, builder)
    }
    
    @discardableResult
    func zStack(
margin: UIEdgeInsets = .zero,
    @ArrayUIViewBuilder _ builder: () -> [UIView?]) -> Self {
        imperative { superView in
            builder().compactMap { $0 }.forEach { (view) in
                superView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: superView.topAnchor, constant: margin.top),
                    view.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: margin.left),
                    superView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: margin.right),
                    superView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: margin.bottom)
                ])
                
            }
        }
    }
    
    @discardableResult
    func padding(insets: UIEdgeInsets) -> UIView {
        UIView().zStack(margin: insets, { self })
    }
    
    @discardableResult
    func padding(_ value: CGFloat = 8.0) -> UIView {
        self.padding(insets: .init(all: value))
    }
}

//MARK: - Declarative constraint method
public extension UIView {
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        imperative {
            $0.widthConstraint = width
        }
    }
    
    @discardableResult
    func minWidth(_ width: CGFloat) -> Self {
        imperative {
            $0.minWidthConstraint = width
        }
    }

    @discardableResult
    func maxWidth(_ width: CGFloat) -> Self {
        imperative {
            $0.maxWidthConstraint = width
        }
    }

    @discardableResult
    func height(_ height: CGFloat) -> Self {
        imperative {
            $0.heightConstraint = height
        }
    }
    
    @discardableResult
    func minHeight(_ height: CGFloat) -> Self {
        imperative {
            $0.minHeightConstraint = height
        }
    }

    @discardableResult
    func maxHeight(_ height: CGFloat) -> Self {
        imperative {
            $0.maxHeightConstraint = height
        }
    }

    @discardableResult
    func size(width: CGFloat, height: CGFloat) -> Self {
        imperative {
            $0.widthConstraint = width
            $0.heightConstraint = height
        }
    }
    
    @discardableResult
    func minSize(width: CGFloat, height: CGFloat) -> Self {
        imperative {
            $0.minWidthConstraint = width
            $0.minHeightConstraint = height
        }
    }

    @discardableResult
    func maxSize(width: CGFloat, height: CGFloat) -> Self {
        imperative {
            $0.maxWidthConstraint = width
            $0.maxHeightConstraint = height
        }
    }

    @discardableResult
    func widthEqual(to superview: UIView, constraint: HelperConstraint) -> Self {
        imperative {
            if superview is UIStackView, !superview.subviews.contains($0) {
                superview.addSubview($0)
            }
            $0.widthAnchor.constraint(equalTo: constraint.dimension, multiplier: constraint.multiplier, constant: constraint.constant).isActive = true
        }
    }
    
    @discardableResult
    func widthEqual(to superview: UIView, constraint: NSLayoutDimension) -> Self {
        widthEqual(to: superview, constraint: .init(dimension: constraint))
    }
        
    @discardableResult
    func heightEqual(to superview: UIView, constraint: HelperConstraint) -> Self {
        imperative {
            if superview is UIStackView, !superview.subviews.contains($0) {
                superview.addSubview($0)
            }
            $0.heightAnchor.constraint(equalTo: constraint.dimension, multiplier: constraint.multiplier, constant: constraint.constant).isActive = true
        }
    }
    
    @discardableResult
    func heightEqual(to superview: UIView, constraint: NSLayoutDimension) -> Self {
        heightEqual(to: superview, constraint: .init(dimension: constraint))
    }
    
    @discardableResult
    func aspectRatio(_ ratio: CGFloat) -> Self {
        imperative {
            $0.aspectRatioConstraint = ratio
        }
    }
}

//MARK: - others
public extension UIView {
    
    func getView(tag: Int, _ recursiveCount: Int = 0) -> UIView? {
        if recursiveCount != 0, self.tag == tag { return self }
        if let view = self.subviews.compactMap({ $0.getView(tag: tag, recursiveCount + 1) }).first {
            return view
        } else if
            let stackView = self as? UIStackView,
            let view = stackView.arrangedSubviews.compactMap({ $0.getView(tag: tag, recursiveCount + 1) }).first {
            return view
        }
        return nil
    }
}

//MARK: - double components constraint
public extension UIView {
    func edgesConstraints(
        _ view: UIView,
        safeAreas: UIEdgeBools,
        priorities: UIEdgePriorities
    ) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let top = safeAreas.top ?
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor) :
        view.topAnchor.constraint(equalTo: self.topAnchor)
        
        let leading = safeAreas.leading ?
        view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor) :
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        
        let bottom = safeAreas.bottom ?
        self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor) :
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        let trailing = safeAreas.trailing ?
        self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor) :
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        top.priority = priorities.top
        leading.priority = priorities.leading
        trailing.priority = priorities.trailing
        bottom.priority = priorities.bottom
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
}

//MARK: - single component constraint
public extension UIView {
    
    var minHeightConstraint: CGFloat? {
        get {
            nil //TODO:
        }
        set {
            guard let constraint = newValue else { return }
            heightAnchor.constraint(greaterThanOrEqualToConstant: constraint).isActive = true
        }
    }
    
    var minWidthConstraint: CGFloat? {
        get {
            nil //TODO:
        }
        set {
            guard let constraint = newValue else { return }
            widthAnchor.constraint(greaterThanOrEqualToConstant: constraint).isActive = true
        }
    }
    
    var maxHeightConstraint: CGFloat? {
        get {
            nil //TODO:
        }
        set {
            guard let constraint = newValue else { return }
            heightAnchor.constraint(lessThanOrEqualToConstant: constraint).isActive = true
        }
    }
    
    var maxWidthConstraint: CGFloat? {
        get {
            nil //TODO:
        }
        set {
            guard let constraint = newValue else { return }
            widthAnchor.constraint(lessThanOrEqualToConstant: constraint).isActive = true
        }
    }
    
    var heightConstraint: CGFloat? {
        get {
            nil //TODO:
        }
        set {
            guard let constraint = newValue else { return }
            heightAnchor.constraint(equalToConstant: constraint).isActive = true
        }
    }
    
    var widthConstraint: CGFloat? {
        get {
            nil //TODO:
        }
        set {
            guard let constraint = newValue else { return }
            widthAnchor.constraint(equalToConstant: constraint).isActive = true
        }
    }
    
    var aspectRatioConstraint: CGFloat? {
        get {
            nil
        }
        set {
            guard let constraint = newValue else { return }
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: constraint).isActive = true
        }
    }
}
