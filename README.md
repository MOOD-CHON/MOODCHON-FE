# MOODCHON-FE

무드촌(MOOD:CHON) 프론트엔드 레포지토리입니다.

무드촌은 함께 촌캉스를 떠나는 사람들이 각자 원하는 분위기를 선택하고, 공통 무드와 여행 조건을 바탕으로 숙소와 관광 콘텐츠를 탐색할 수 있도록 돕는 서비스입니다.

현재 프론트엔드는 **Flutter 기반 iOS 앱 개발 및 App Store 배포를 우선 목표**로 개발합니다.

## 1. Tech Stack

* Flutter
* Dart
* iOS
* Xcode
* VS Code

## 2. Development Environment

프로젝트 개발 전 아래 환경이 필요합니다.

* Flutter SDK
* Xcode
* iOS Simulator
* CocoaPods
* VS Code
* VS Code Flutter Extension

Android 및 기타 플랫폼은 현재 개발 범위에 포함하지 않습니다.

개발 환경이 정상적으로 설정되었는지는 아래 명령어로 확인할 수 있습니다.

```bash
flutter doctor -v
```

Android 관련 경고는 현재 프로젝트 개발에 영향을 주지 않으므로 무시해도 됩니다.

## 3. Getting Started

### Repository Clone

```bash
git clone https://github.com/MOOD-CHON/MOODCHON-FE.git
```

```bash
cd MOODCHON-FE
```

### Dependency 설치

```bash
flutter pub get
```

### Git Hook 설정

프로젝트 최초 Clone 후 아래 명령어를 실행합니다.

```bash
git config core.hooksPath .githooks
```

커밋 메시지는 아래 형식을 사용합니다.

```text
type: 작업 내용
```

사용 가능한 Type은 다음과 같습니다.

```text
feat
fix
style
refactor
chore
docs
```

### iOS Simulator 실행

```bash
open -a Simulator
```

연결된 기기를 확인합니다.

```bash
flutter devices
```

iPhone Simulator가 정상적으로 표시되면 앱을 실행합니다.

```bash
flutter run
```

## 4. Project Structure

```text
MOODCHON-FE/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── feat.md
│   │   ├── fix.md
│   │   ├── refactor.md
│   │   └── chore.md
│   └── pull_request_template.md
│
├── .githooks/
│   └── commit-msg
│
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
│
├── lib/
│   ├── app/
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_shadows.dart
│   │   │   ├── app_theme.dart
│   │   │   └── app_typography.dart
│   │   └── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── utils/
│   │   └── widgets/
│   │
│   ├── features/
│   └── main.dart
│
├── test/
├── CONTRIBUTING.md
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

### `lib/app`

앱 전역에서 사용하는 설정을 관리합니다.

* `router/`: 앱 라우팅 설정
* `theme/`: 디자인 시스템 및 전역 Theme
* `app.dart`: 앱 최상위 설정

### `lib/app/theme`

Figma 디자인 시스템을 기준으로 공통 디자인 값을 관리합니다.

* `app_colors.dart`: Color
* `app_typography.dart`: Typography
* `app_shadows.dart`: Shadow
* `app_theme.dart`: Flutter 전역 Theme

실제 폰트 파일은 `assets/fonts/`에서 관리합니다.

### `lib/core`

여러 기능에서 공통으로 사용하는 코드를 관리합니다.

* `constants/`: 공통 상수
* `network/`: 네트워크 및 API 공통 설정
* `utils/`: 공통 Utility
* `widgets/`: 공용 Widget

필요한 공통 기능이 생길 때 하위 구조를 추가하거나 확장합니다.

### `lib/features`

서비스의 실제 기능 단위 코드를 관리합니다.

기능별 폴더는 초기 단계에서 미리 고정하지 않고 실제 개발 범위에 따라 생성합니다.

예시:

```text
features/
├── auth/
├── trip/
├── mood/
└── explore/
```

각 기능의 규모와 책임에 따라 필요한 하위 구조를 추가합니다.

### `assets`

앱에서 사용하는 정적 리소스를 관리합니다.

```text
assets/
├── fonts/
├── icons/
└── images/
```

## 5. Branch Strategy

기본 개발 브랜치는 `develop`입니다.

일반적인 기능 개발 및 수정은 `develop`에서 작업 브랜치를 생성한 후 다시 `develop`으로 Pull Request를 생성합니다.

배포 시에는 `develop`의 내용을 `main`으로 병합합니다.

```text
feat / fix / style / refactor / chore / docs
                      ↓
                   develop
                      ↓
                    main
```

브랜치 이름은 아래 형식을 사용합니다.

```text
{type}/#{issue-number}-{description}
```

예시:

```text
feat/#12-create-trip
fix/#21-invite-code-validation
style/#25-notification-card
refactor/#31-common-button
chore/#1-project-setup
docs/#40-readme
```

`description`은 영문 `kebab-case`로 간결하게 작성합니다.

## 6. Git Convention

Issue, Branch, Commit, Pull Request에 대한 상세한 협업 규칙은 [`CONTRIBUTING.md`](./CONTRIBUTING.md)를 참고해주세요.

기본 작업 흐름은 다음과 같습니다.

```text
Issue 생성
→ develop 최신화
→ 작업 Branch 생성
→ 개발 및 Commit
→ Push
→ develop 대상 Pull Request 생성
→ Merge
```

## 7. Environment Variables

환경변수 파일은 Git에 포함하지 않습니다.

프로젝트에서 환경변수가 필요한 경우 `.env.example`을 기준으로 개인 환경에 `.env` 파일을 생성합니다.

```text
.env
```

실제 API URL, Secret Key 등 민감한 값은 Repository에 Commit하지 않습니다.

## 8. Code Check

작업 전후 아래 명령어로 코드 상태를 확인합니다.

```bash
flutter analyze
```

앱 실행은 다음 명령어를 사용합니다.

```bash
flutter run
```

## 9. Platform

현재 MOODCHON-FE는 **iOS App Store 배포를 우선 목표**로 개발합니다.

Flutter 프로젝트 생성 시 Android, Web, macOS, Windows, Linux용 플랫폼 디렉터리가 함께 생성될 수 있으나, 해당 플랫폼은 현재 개발 범위에 포함하지 않습니다.

추후 Android 등 추가 플랫폼 지원이 필요한 경우 별도의 개발 및 배포 환경을 설정합니다.
