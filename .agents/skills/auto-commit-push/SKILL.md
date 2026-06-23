---
name: auto-commit-push
description: TurboNavigator 저장소 전용 git 커밋 및 푸시 워크플로우. 사용자가 "커밋해", "커밋하고 푸시해", "자동 커밋", "push까지 해줘"처럼 현재 저장소 변경사항을 커밋하거나 원격에 푸시하라고 요청할 때 사용한다. 커밋 메시지는 feat, chore, docs, fix, refactor, test, ci 중 하나와 간결한 설명을 사용한다.
---

# Auto Commit Push

## 목적

TurboNavigator 저장소에서 변경사항을 점검하고 프로젝트 규칙에 맞는 커밋 메시지로 커밋한다. 사용자가 명시적으로 push까지 요청한 경우에만 현재 브랜치를 원격에 push한다.

## 커밋 메시지 규칙

사용 가능한 기본 타입은 아래와 같다.

```text
feat: 설명
chore: 설명
docs: 설명
fix: 설명
refactor: 설명
test: 설명
ci: 설명
```

타입 선택 기준:

- `feat`: Navigator, route, modal, tab, deep link 기능 추가
- `fix`: 잘못된 navigation 동작, demo build, 문서 오류 수정
- `refactor`: 동작 변경 없이 구조 개선
- `docs`: README, 템플릿, Codex 문서, 스킬 변경
- `test`: 테스트 추가 또는 수정
- `chore`: 로컬 설정, 스크립트, 운영성 정리
- `ci`: GitHub Actions, 자동화, 검증 파이프라인 변경

설명은 짧고 명확하게 쓴다. 한글 또는 주변 커밋 문체에 맞는 간결한 표현을 사용한다.

## 워크플로우

1. `git branch --show-current`로 현재 브랜치를 확인한다.
2. 현재 브랜치가 `main`이면 커밋을 중단한다.
3. 가능하면 issue 번호가 포함된 `codex/<type>-<issue-number>-<short-slug>` 브랜치에서 작업한다.
4. `git status --short`로 전체 변경사항을 확인한다.
5. `git diff --stat`과 필요한 파일별 diff를 읽어 변경 의도를 파악한다.
6. 커밋 대상에 금지 파일이 섞였는지 확인한다.
7. 변경사항이 서로 무관하게 섞여 있으면 하나의 커밋으로 묶지 말고 사용자에게 분리 기준을 확인한다.
8. 변경 성격에 맞춰 타입을 고르고 커밋 메시지를 만든다.
9. 관련 파일만 `git add`로 stage한다. `git add .`는 사용하지 않는다.
10. `git diff --cached --stat`으로 stage 결과를 다시 확인한다.
11. `git commit -m "type: 설명"`을 실행한다.
12. 사용자가 push를 명시한 경우에만 현재 브랜치를 확인한 뒤 `git push`를 실행한다.
13. 최종 응답에 브랜치명, 커밋 해시, 메시지, push 여부를 짧게 보고한다.

## 커밋 금지 대상

- `.env`, `*.env`
- `.codex/logs/*.jsonl`
- `*.pem`, `*.key`, `*.p12`
- 서비스 계정 JSON, 인증서, 토큰, 비밀번호가 포함된 파일
- `.DS_Store`
- `.build/`, `DerivedData/`, `xcuserdata/`
- 빌드 산출물, coverage 결과, 임시 리포트처럼 재생성 가능한 파일
- 원격 게시와 무관한 대용량 로그 또는 캐시 파일

금지 대상이 변경사항에 보이면 커밋하지 말고 사용자에게 알려야 한다.

## Push 규칙

- 사용자가 "push", "푸시", "올려"처럼 명시한 경우에만 push한다.
- push 전 `git branch --show-current`로 현재 브랜치를 확인한다.
- 원격 브랜치가 없어서 push가 실패하면 `git push -u origin <branch>` 실행 가능 여부를 사용자에게 확인한다.
- push 실패 시 재시도하지 말고 에러 요지를 보고한다.
