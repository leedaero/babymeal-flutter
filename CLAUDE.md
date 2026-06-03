# babymeal Flutter 앱 가이드

## 레포 정보

- GitHub: `leedaero/babymeal-flutter`
- 로컬 경로: `/Users/idaelo/project/babymeal-flutter`
- 백엔드 레포: `leedaero/babymeal` (`/Users/idaelo/project/babyMeal`)

## API 백엔드 수정이 필요한 경우

Flutter 앱 작업 중 API 추가·수정·버그 수정 등 백엔드 변경이 필요하면, **Cmux로 백엔드 탭에 직접 작업 지시를 전송**한다.

### 백엔드 탭 찾기 → 명령 전송 절차

```bash
# 1. 현재 열려 있는 탭 목록 확인
cmux tree --all

# 2-A. "babyMeal backend" 탭이 있으면 해당 surface ID로 전송
cmux send --surface <surface_id> "<작업 내용>"
cmux send-key --surface <surface_id> "Enter"

# 2-B. 탭이 없으면 프로젝트 경로 확인 후 새 탭 열기
ls /Users/idaelo/project/babyMeal   # 경로 존재 확인
cmux /Users/idaelo/project/babyMeal  # 해당 경로로 새 탭 열기
# 열린 뒤 다시 cmux tree --all 로 surface ID 확인 후 전송
```

### 백엔드 작업 지시 메시지 형식

전송할 메시지에는 아래 내용을 포함한다:
- 어떤 기능을 위한 변경인지 (Flutter 기능명)
- 필요한 API 변경 목록 (엔드포인트, 필드명, 타입)
- Flutter 모델 기준 필드명 (`snake_case`)
- **작업 완료 후 커밋+푸시 요청**

### 백엔드 정보

- 프로젝트 경로: `/Users/idaelo/project/babyMeal/`
- GitHub: `leedaero/babymeal`

백엔드 수정이 완료된 후 Flutter 앱 작업을 이어서 진행한다.

## 작업 완료 후 필수 사항

- 작업이 끝나면 항상 커밋 → 푸시까지 완료할 것
- **PR 생성은 모바일 환경에서 작업할 때만** 수행할 것 (PC에서는 PR 생성 불필요)
- **Flutter 앱 변경 시: 코드 품질 체크(90점↑) → 릴리즈 APK 빌드 + 에뮬레이터 APK 빌드 → Firebase App Distribution 배포 순서로 완료할 것**

## 빌드 전 코드 품질 체크 (필수)

APK 빌드 전에 반드시 아래 품질 체크를 실행하고 **90점 이상**일 때만 빌드를 진행한다.

### 채점 기준

| 항목 | 차감 |
|------|------|
| error | -10점/개 |
| warning | -3점/개 |
| info (deprecated 등) | 미채점 |

시작 점수 100점, 90점 미만이면 빌드 중단 후 문제 수정.

### 품질 체크 명령

```bash
flutter analyze 2>&1 | tee /tmp/flutter_quality.txt; true
ERRORS=$(grep -E "^ *error •" /tmp/flutter_quality.txt | wc -l | tr -d ' ')
WARNINGS=$(grep -E "^ *warning •" /tmp/flutter_quality.txt | wc -l | tr -d ' ')
SCORE=$((100 - ERRORS * 10 - WARNINGS * 3))
[ "$SCORE" -lt 0 ] && SCORE=0
echo "──────────────────────────────"
echo " 에러:   ${ERRORS}개"
echo " 경고:   ${WARNINGS}개"
echo " 품질:   ${SCORE} / 100점"
echo "──────────────────────────────"
if [ "$SCORE" -lt 90 ]; then
  echo "❌ 품질 기준 미달 (${SCORE}점 < 90점) — 에러/경고 수정 후 재시도"
  grep "   error •\|   warning •" /tmp/flutter_quality.txt
  exit 1
fi
echo "✅ 품질 기준 통과 (${SCORE}점) — 빌드 진행"
```

> 에러·경고가 없으면 100점. 경고 3개까지는 91점으로 통과. 4개부터 88점으로 실패.

---

## Firebase App Distribution 배포

앱 변경이 있을 때마다 아래 순서로 배포한다.

### 1. pubspec.yaml 버전 올리기

`/Users/idaelo/project/babymeal-flutter/pubspec.yaml` 의 version 줄을 수정:
```
version: X.X.X+N   (뒤 빌드번호 N은 항상 이전보다 +1)
```

### 2. APK 빌드 (릴리즈 + 에뮬레이터)

```bash
cd /Users/idaelo/project/babymeal-flutter
# 릴리즈 빌드 (실기기용)
flutter build apk --release
# 에뮬레이터 빌드 (arm64, Apple Silicon Mac 기준)
flutter build apk --debug --target-platform android-arm64
```

### 3. Firebase App Distribution 업로드

```bash
# 릴리즈 APK
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --project babymeal-4f6f7 \
  --app "1:1045238419165:android:1d1bf34ccc50a275009534" \
  --release-notes "변경 내용 요약"

# 에뮬레이터 APK
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-debug.apk \
  --project babymeal-4f6f7 \
  --app "1:1045238419165:android:1d1bf34ccc50a275009534" \
  --release-notes "변경 내용 요약 (에뮬레이터용)"
```

### 4. 에뮬레이터에 직접 설치 (선택)

Firebase 배포 후 에뮬레이터에서 바로 확인하려면 adb로 직접 설치:

```bash
# 에뮬레이터 연결 확인
~/Library/Android/sdk/platform-tools/adb devices

# 에뮬레이터 APK 직접 설치
~/Library/Android/sdk/platform-tools/adb install -r \
  build/app/outputs/flutter-apk/app-debug.apk
```

> **에뮬레이터 환경**: Android Studio에서 실행한 Android 에뮬레이터 (Apple Silicon Mac, arm64)  
> **adb 경로**: `~/Library/Android/sdk/platform-tools/adb`

### Firebase 정보 (변경 금지)

| 항목 | 값 |
|---|---|
| Project ID | `babymeal-4f6f7` |
| Android App ID | `1:1045238419165:android:1d1bf34ccc50a275009534` |
| 로그인 계정 | `daero52@gmail.com` |
| 패키지명 | `com.babymeal.babymeal_app` |

### 전체 자동 배포 명령 (한 번에)

```bash
cd /Users/idaelo/project/babymeal-flutter && \
flutter build apk --release && \
flutter build apk --debug --target-platform android-arm64 && \
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --project babymeal-4f6f7 \
  --app "1:1045238419165:android:1d1bf34ccc50a275009534" \
  --release-notes "릴리즈 노트" && \
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-debug.apk \
  --project babymeal-4f6f7 \
  --app "1:1045238419165:android:1d1bf34ccc50a275009534" \
  --release-notes "릴리즈 노트 (에뮬레이터용)"
```
