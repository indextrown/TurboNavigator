---
name: auto-pr
description: TurboNavigator 저장소 전용 GitHub Pull Request 자동 작성 및 게시 워크플로우. 사용자가 "PR 올려줘", "pr 생성해", "자동 PR", "풀리퀘 만들어줘", "github pr 올려줘"처럼 현재 브랜치의 커밋을 바탕으로 PR 제목/본문을 만들고 게시하라고 요청할 때 사용한다. 저장소 템플릿, git log/diff, 커밋 내용, TurboNavigator 운영 문체를 반영해 `gh pr create`로 PR을 생성한다.
---

# Auto PR

## 목적

TurboNavigator 저장소에서 현재 브랜치의 커밋과 변경사항을 분석해 기존 PR 템플릿과 문체에 맞는 PR 제목과 본문을 작성하고 GitHub에 게시한다.

실제 PR 게시는 사용자가 PR 생성 또는 게시를 명시한 경우에만 수행한다. 사용자가 "본문만 작성해", "초안만 만들어줘"처럼 요청하면 `gh pr create`를 실행하지 않는다.

## 참고 파일

PR 작성 전에 아래 파일을 읽는다.

1. `.github/PULL_REQUEST_TEMPLATE.md`가 있으면 우선 사용한다.
2. `.agents/skills/auto-pr/references/pr-writing-style.md`

두 파일이 모두 없으면 PR을 만들기 전에 사용자에게 누락 경로를 알리고, 현재 확인 가능한 정보로 진행 가능한지 판단한다.

## 사전 점검

1. `git status --short`로 working tree 상태를 확인한다.
2. uncommitted 변경이 있으면 PR 생성 전에 중단한다. 사용자가 명시적으로 원하면 먼저 `$auto-commit-push`로 커밋하게 안내한다.
3. `.env`, `.codex/logs/*.jsonl`, 인증키/토큰/비밀번호, 서비스 계정 파일, 불필요한 캐시나 빌드 산출물이 변경사항에 보이면 PR 생성을 중단하고 사용자에게 보고한다.
4. `git branch --show-current`로 현재 브랜치를 확인한다.
5. 현재 브랜치가 `main`이면 PR 생성을 중단한다.
6. `git remote -v`와 `gh auth status`로 GitHub remote와 인증 상태를 확인한다.
7. `gh repo view --json defaultBranchRef,nameWithOwner,url`로 기본 브랜치와 저장소를 확인한다.
8. `git fetch origin <base>`로 base 브랜치 정보를 갱신한다.
9. `git log --oneline origin/<base>..HEAD`로 PR에 들어갈 커밋이 있는지 확인한다.
10. `gh pr list --head <current-branch> --state open --json number,title,url`로 중복 PR이 있는지 확인한다.

## 이슈 번호 추론

관련 이슈 번호는 아래 순서로 찾는다.

1. 브랜치명에서 `#<number>` 또는 `<type>-<number>-...` 형태를 찾는다.
2. 커밋 메시지에서 `#<number>`를 찾는다.
3. 사용자 요청에 포함된 이슈 번호를 사용한다.

이슈 번호를 찾으면 이슈 제목을 조회한다.

```bash
gh issue view <issue-number> --json number,title,url,state
```

이슈 번호를 찾은 경우 PR 제목은 아래 규칙을 따른다.

```text
[#<issue-number>] <issue-title>
```

이슈를 찾을 수 없는 문서/정리 작업에서는 커밋과 diff를 바탕으로 `[docs] ...`, `[chore] ...` 형식 제목을 사용할 수 있다.

## 본문 작성

템플릿이 있으면 템플릿의 섹션과 순서를 유지한다. 템플릿이 없으면 `references/pr-writing-style.md` 형식을 사용한다.

작성 규칙:

- 템플릿의 HTML 주석은 제거해도 된다.
- 변경 사항은 보통 4-8개의 bullet로 작성한다.
- bullet은 `- ...했습니다.` 문체를 기본으로 쓴다.
- 코드 변경 PR은 `### 문제 원인`, `### 해결 내용`, `### 검증한 내용`, `### 위험과 롤백 포인트` 같은 하위 섹션을 추가할 수 있다.
- SwiftUI/UIKit UI 변경은 스크린샷 또는 GIF 필요 여부를 적는다.
- 문서-only 변경이면 실행하지 않은 build/test를 완료했다고 쓰지 않는다.

## 게시 절차

PR 본문은 shell inline 문자열보다 임시 body file로 전달한다.

1. 제목과 본문을 사용자에게 짧게 요약하되, 사용자가 이미 PR 생성을 요청했다면 별도 승인 대기 없이 계속 진행한다.
2. 브랜치가 원격에 없거나 원격보다 앞서 있으면 `git push -u origin <current-branch>` 또는 `git push`를 실행한다.
3. `gh pr create --base <base> --head <current-branch> --title "<title>" --body-file <body-file>` 형식으로 생성한다.
4. 사용자가 draft를 요청했거나 검증이 불충분해 draft가 더 적절하면 `--draft`를 붙인다.
5. PR 생성 후 URL을 보고하고, 사용자 승인 대기 상태임을 함께 알린다.

## 실패와 중단 기준

- working tree에 커밋되지 않은 변경이 있다.
- 금지 파일이나 비밀이 변경사항에 포함되어 있다.
- 현재 브랜치가 `main`이다.
- base 대비 커밋이 없다.
- `gh auth status`가 실패한다.
- 같은 head branch의 open PR이 이미 있다.
- PR 제목 또는 본문을 만들기에 diff 정보가 부족하다.

## 최종 응답

PR을 생성했다면 아래를 보고한다.

- PR URL
- 제목
- base/head branch
- 관련 이슈
- push 여부
- 검증 또는 미검증 요약

PR을 생성하지 않았다면 중단 이유와 필요한 다음 조치를 보고한다.
