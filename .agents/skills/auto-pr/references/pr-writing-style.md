# TurboNavigator PR Writing Style

이 문서는 `auto-pr`가 TurboNavigator 저장소에서 일관된 PR 문체를 유지하기 위한 기준이다.

## 제목 규칙

이슈가 연결된 작업은 아래 형식을 우선 사용한다.

```text
[#<issue-number>] <issue-title>
```

이슈가 없는 작은 문서/정리 작업은 아래 형식을 사용할 수 있다.

```text
[docs] README navigation rationale 정리
[chore] 로컬 작업 템플릿 추가
```

## 본문 기본 구조

템플릿이 없을 때는 아래 순서를 기본값으로 사용한다.

```text
## Summary
## Why
## Changes
## Verification
## Risks
## Related Issue
```

## 문체

- 설명은 짧고 실무형으로 쓴다.
- bullet은 `- ...했습니다.` 문체를 기본으로 사용한다.
- Swift Package 라이브러리답게 public API, iOS 지원 버전, demo 영향, 문서 영향, 테스트 결과를 분리해서 쓴다.
- 과장된 표현이나 마케팅 문구는 피한다.

## 변경 사항 구성

보통 아래 순서를 권장한다.

1. 어떤 navigation 문제나 문서 공백을 메웠는지
2. 어떤 파일과 흐름을 바꿨는지
3. 왜 이 접근이 typed route / UIKit engine 원칙과 맞는지
4. 무엇을 검증했는지
5. 남은 리스크나 후속 작업이 있는지

## Draft PR 권장 상황

- 검증이 일부만 끝난 경우
- public API 변경이 포함된 경우
- UIKit/SwiftUI bridge 또는 demo build 리스크가 남아 있는 경우
- CI workflow 권한이나 macOS runner 호환성 확인이 필요한 경우
