//
//  Navigator+DeepLink.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/31/26.
//

import Foundation

public extension Navigator {
  
  /// DeepLink에 정의된 action을 기반으로 네비게이션을 수행합니다.
  ///
  /// - Description:
  ///   DeepLink가 가지고 있는 route와 action을 해석하여
  ///   push / replace / present 중 적절한 방식으로 화면 전환을 수행합니다.
  ///
  /// - Parameters:
  ///   - deepLink: 적용할 딥링크 객체
  ///   - animated: 애니메이션 여부 (기본값: true)
  ///
  /// - Note:
  ///   DeepLink는 "무엇을"과 "어떻게"를 모두 포함하고 있으며,
  ///   Navigator는 이를 실제 화면 전환으로 실행합니다.
  ///
  /// - Example:
  ///   let deepLink = DeepLink(route: .detail(id: "42"), action: .push)
  ///   navigator.handle(deepLink)
  func handle(_ deepLink: DeepLink<Route>, animated: Bool = true) {
    switch deepLink.action {
    case .push:
      push(deepLink.routes, animated: animated)
      
    case .replace:
      replace(with: deepLink.routes, animated: animated)
      
    case let .present(style):
      present(deepLink.routes, animated: animated, style: style)
    }
  }

  /// URL을 파싱하여 DeepLink로 변환한 뒤 네비게이션을 수행합니다.
  ///
  /// - Description:
  ///   외부에서 전달된 URL을 DeepLinkParser를 통해 해석한 후,
  ///   변환된 DeepLink를 handle(_:animated:)을 통해 적용합니다.
  ///
  /// - Parameters:
  ///   - url: 처리할 URL (딥링크, 유니버설 링크 등)
  ///   - parser: URL을 DeepLink로 변환하는 parser
  ///   - animated: 애니메이션 여부 (기본값: true)
  ///
  /// - Note:
  ///   URL이 유효하지 않거나 파싱에 실패할 경우 아무 동작도 하지 않습니다.
  ///
  /// - Generic:
  ///   - Parser: DeepLinkParser를 준수하는 타입
  ///
  /// - Example:
  ///   navigator.handle(
  ///     url: incomingURL,
  ///     parser: AppDeepLinkParser()
  ///   )
  func handle<Parser: DeepLinkParser>(
    url: URL,
    parser: Parser,
    animated: Bool = true
  )
  where Parser.Route == Route
  {
    guard let deepLink = parser.parse(url: url) else { return }
    handle(deepLink, animated: animated)
  }
}
