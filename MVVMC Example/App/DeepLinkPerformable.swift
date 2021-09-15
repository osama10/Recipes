import Foundation

protocol DeepLinkPerformable: AnyObject {
    /// Here happens the actual handling of deeplinks.
    /// This method should be implemented.
    func performDeepLink(_ link: DeepLink)
}

protocol QueuedDeepLinkPerformable: DeepLinkPerformable {
    /// This property holds a deepLink until it can be handled.
    var queuedDeepLink: DeepLink? { get set }

    /// Call this method when all the content is loaded.
    /// If there's a deepLink in a queue, it will be executed,
    /// otherwise – nothing happens.
    ///
    /// (Note: It doesn't have to be implemented.)
    func performDeepLinkIfQueued()

    /// Call this method from `performDeepLink(...)`
    /// if some data hasn't been loaded yet.
    /// `performDeepLink(...)` will be called again, once the data is there.
    ///
    /// (Note: It doesn't have to be implemented.)
    func queueDeepLink(_ link: DeepLink)
}

extension QueuedDeepLinkPerformable {
    func queueDeepLink(_ link: DeepLink) {
        queuedDeepLink = link
    }

    func performDeepLinkIfQueued() {
        guard let queuedDeepLink = queuedDeepLink else { return }

        DispatchQueue.main.async {
            self.queuedDeepLink = nil
            self.performDeepLink(queuedDeepLink)
        }
    }
}

enum DeepLink: Equatable {
    case actions
    case date
}

