//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import FeedFeature

public final class FeedUIComposer {
	private init() {}

	public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
		let presentationAdapter = FeedLoaderPresentationAdapter(
			feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))

		let feedController = makeFeedViewController(
			feedViewControllerDelegate: presentationAdapter,
			errorViewDelegate: presentationAdapter,
			title: Localized.Feed.title)

		let weakFeedController = WeakRefVirtualProxy(feedController)

		presentationAdapter.presenter = FeedPresenter(
			feedView: FeedViewAdapter(
				controller: feedController,
				imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
			loadingView: weakFeedController,
			feedErrorView: weakFeedController)

		return feedController
	}

	private static func makeFeedViewController(
		feedViewControllerDelegate: FeedViewControllerDelegate,
		errorViewDelegate: ErrorViewDelegate,
		title: String
	) -> FeedViewController {
		let bundle = Bundle(for: FeedViewController.self)
		let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
		feedController.feedViewControllerDelegate = feedViewControllerDelegate
		feedController.errorViewDelegate = errorViewDelegate
		feedController.title = title
		return feedController
	}
}
