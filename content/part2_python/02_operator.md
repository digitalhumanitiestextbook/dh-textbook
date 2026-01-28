---
title: 연산자 배우기
---

<!-- colab-button:start -->
<div class="colab-button">
  <a
    href="https://colab.research.google.com/github/digitalhumanitiestextbook/dh-textbook/blob/main/notebooks/part2_computing/02_bit_and_memory.ipynb"
    target="_blank"
    rel="noopener"
  >
    Colab에서 실행하기
  </a>
</div>
<!-- colab-button:end -->

## 연산자 배우기

앞서 우리는 변수에 데이터를 저장하고 그 종류를 확인하는 방법을 배웠습니다. 이제 이 변수들을 이용하여 간단한 계산을 하거나, 값들을 비교하거나, 여러 조건을 조합하는 방법을 알아봅시다. 이때 사용되는 것이 바로 "**연산자(Operator)**"입니다. 파이썬의 기본 연산자들을 "프렌즈" 대본 분석이라는 인문학적/문학적 탐구 상황에 적용하며 AI 코드 생성을 통해 살펴보겠습니다.

## 산술 연산자: 대본 정보 계산하기

"**산술 연산자(Arithmetic Operator)**"는 숫자 데이터를 계산하는 데 사용됩니다. 대본 분석에서는 등장인물의 대사 분량, 단어 사용 빈도, 극 구조 등 다양한 정량적 정보를 계산하는 데 필수적입니다.

* **`+` (덧셈), `-` (뺄셈), `*` (곱셈), `/` (나눗셈)**
    * 기본적인 사칙연산입니다.
* **`//` (몫)**
    * 나눗셈 결과의 정수 부분만 구합니다.
* **`%` (나머지)** 
    * 나눗셈 결과의 나머지만 구합니다.
* **`**` (거듭제곱)**
    * 거듭제곱을 계산합니다.

이제 산술 연산자 개념의 숙지를 위해 간단한 코드를 실행시켜 보겠습니다.

```
# 레이첼과 모니카의 가상 총 단어 수를 변수에 저장합니다.
rachel_word_count = 850
monica_word_count = 780

# 두 사람의 총 단어 수 합계 계산 (덧셈 연산자 + 사용)
total_word_sum = rachel_word_count + monica_word_count

# 두 사람의 단어 수 차이 계산 (뺄셈 연산자 - 사용)
word_count_diff = rachel_word_count - monica_word_count

# 계산 결과를 출력합니다.
print(f"레이첼과 모니카의 총 단어 수 합계: {total_word_sum}개")
print(f"레이첼과 모니카의 단어 수 차이: {word_count_diff}개")
```

**실행 및 설명:**

* 결과 확인
    * `레이첼과 모니카의 총 단어 수 합계: 1630개`
    * `레이첼과 모니카의 단어 수 차이: 70개`
* `+` 와 `-` 연산자를 사용하여 두 캐릭터의 언어적 분량을 비교하는 기초 계산을 수행했습니다.

```
# 조이의 총 단어 수와 대사 수를 변수에 저장합니다.
joey_total_words = 270
joey_line_count = 30

# 평균 대사 길이 계산 (나눗셈 연산자 / 사용)
joey_avg_words_per_line = joey_total_words / joey_line_count

# 계산 결과를 출력합니다.
print(f"조이의 평균 대사 길이 (단어 수/대사): {joey_avg_words_per_line}")
```

**실행 및 설명**

* 결과 확인: `조이의 평균 대사 길이 (단어 수/대사): 9.0`
* `/` 연산자를 사용하여 캐릭터의 평균적인 발화 길이를 계산했습니다. 이는 캐릭터의 언어적 스타일을 파악하는 데 사용될 수 있습니다.

```
# 로스의 총 단어 수와 과학 관련 단어 언급 횟수를 변수에 저장합니다.
ross_total_words = 15000
ross_science_mentions = 45

# 1000 단어당 과학 관련 단어 빈도 계산 (나눗셈과 곱셈 사용)
# (과학 단어 수 / 총 단어 수) * 1000
ross_science_density = (ross_science_mentions / ross_total_words) * 1000

# 계산 결과를 출력합니다.
print(f"로스의 1000단어당 '과학' 관련 단어 빈도: {ross_science_density}")
```

**실행 및 설명**

* 결과 확인: `로스의 1000단어당 '과학' 관련 단어 빈도: 3.0`
* `/` 와 `*` 연산자를 조합하여 특정 주제어의 사용 밀도를 계산했습니다. 이는 캐릭터의 주요 관심사나 언어적 특징을 분석하는 데 활용될 수 있습니다.

```
# 총 장면 수와 나누려는 막의 수를 변수에 저장합니다.
total_scenes = 17
num_acts = 3

# 각 막당 평균 장면 수 계산 (몫 연산자 // 사용)
scenes_per_act = total_scenes // num_acts

# 나누고 남는 장면 수 계산 (나머지 연산자 % 사용)
remaining_scenes = total_scenes % num_acts

# 계산 결과를 출력합니다.
print(f"각 막당 평균 장면 수: {scenes_per_act}개")
print(f"남는 장면 수: {remaining_scenes}개")
```

**실행 및 설명**

* 결과 확인: `각 막당 평균 장면 수: 5개`, `남는 장면 수: 2개`
* `//` 와 `%` 연산자를 사용하여 에피소드의 장면 구성을 분석하는 기초적인 계산을 수행했습니다. 이는 극의 구조나 리듬을 분석하는 데 활용될 수 있습니다.


## 대본 내용 비교하기 (비교 연산자)

"**비교 연산자(Comparison Operator)**"는 두 값을 비교하여 `True`(참) 또는 `False`(거짓)의 결과를 반환합니다. 캐릭터 간의 특징 비교, 특정 패턴 확인 등에 유용합니다.

* `==` (같다)
* `!=` (다르다) 
* `>` (크다)
* `<` (작다)
* `>=` (크거나 같다)
* `<=` (작거나 같다)

이제 비교 연산자 개념의 숙지를 위해 간단한 코드를 실행시켜 보겠습니다.

```
# 챈들러와 조이의 가상 대사 수를 변수에 저장합니다.
chandler_lines = 8
joey_lines = 10

# 챈들러가 조이보다 대사를 더 많이 했는지 비교합니다. ('>' 연산자 사용)
did_chandler_talk_more = chandler_lines > joey_lines

# 비교 결과를 출력합니다.
print(f"챈들러가 조이보다 대사를 더 많이 했는가?: {did_chandler_talk_more}")
```

**실행 및 설명**

* 결과 확인: `챈들러가 조이보다 대사를 더 많이 했는가?: False`
* 8은 10보다 크지 않으므로, `>` 비교 연산의 결과는 `False`가 됩니다.

```
# 피비가 노래 부른 횟수를 변수에 저장합니다.
phoebe_sings_count = 3

# 횟수가 3번과 같은지 비교합니다. ('==' 연산자 사용)
is_exactly_three = phoebe_sings_count == 3

# 횟수가 5번과 다른지 비교합니다. ('!=' 연산자 사용)
is_not_five = phoebe_sings_count != 5

# 비교 결과를 출력합니다.
print(f"피비가 Smelly Cat을 정확히 3번 불렀는가?: {is_exactly_three}")
print(f"피비가 Smelly Cat을 5번 부르지는 않았는가?: {is_not_five}")
```

**실행 및 설명**

* 결과 확인: `피비가 Smelly Cat을 정확히 3번 불렀는가?: True`, `피비가 Smelly Cat을 5번 부르지는 않았는가?: True`
* `==`는 두 값이 같은지, `!=`는 두 값이 다른지를 확인하는 데 사용됩니다.

```
# 가상의 감정 점수를 변수에 저장합니다.
positive_score = 0.6
negative_score = -0.2

# 긍정 점수가 0.5 이상인지 비교합니다. ('>=' 연산자 사용)
is_positive_enough = positive_score >= 0.5

# 부정 점수가 -0.5 이하인지 비교합니다. ('<=' 연산자 사용)
is_negative_low_enough = negative_score <= -0.5

# 비교 결과를 출력합니다.
print(f"긍정 점수가 0.5 이상인가?: {is_positive_enough}")
print(f"부정 점수가 -0.5 이하인가?: {is_negative_low_enough}")
```

**실행 및 설명**

* 결과 확인: `긍정 점수가 0.5 이상인가?: True`, `부정 점수가 -0.5 이하인가?: False`
* `>=`는 크거나 같음, `<=`는 작거나 같음을 비교합니다. 감성 분석 결과 등을 특정 기준치와 비교하여 분류할 때 유용합니다.

### 할당 연산자 vs 비교 연산자
프로그래밍을 처음 시작하는 사람들이 가장 흔하게 혼동하는 두 연산자가 바로 ‘할당 연산자’와 ‘비교 연산자’입니다. 이는 우리가 일상에서 등호(=)를 비교 연산자로 사용하고 있기 때문입니다. 그러나 파이썬에서는 이중 등호(==)를 써서 좌우의 항을 비교합니다.

```
1+1=2  # 구문 에러(Syntax Error) 발생
1+1==2  # True
```

이 둘의 역할은 완전히 다르니 명확히 구분할 수 있어야 합니다.

| 연산자 | 이름 | 역할 | '프렌즈' 예시 |
| :---: | :--- | :--- | :--- |
| `=` | **할당 연산자** (Assignment operator) | 오른쪽의 값을 왼쪽의 변수에 **할당** (저장)합니다. | `joey_lines = 10`  (변수 `joey_lines`에 정수 `10`을 저장) |
| `==` | **비교 연산자** (Comparison operator) | 왼쪽의 값과 오른쪽의 값이 **같은지 확인**하고 그 결과를 "**불리언(True/False)**"으로 반환합니다. | `joey_lines == 10` (변수 `joey_lines`의 값이 `10`과 같은지 확인) |

만약 로스(Ross)의 대사 횟수(ross_lines)가 챈들러(Chandler)의 대사 횟수(chandler_lines)와 같은지 확인하고 싶다면, 반드시 이중 등호(==)를 사용해야 합니다.

```
# 잘못된 사용: 값을 비교해야 하는데, 값을 덮어쓰려고 시도합니다.
# if ross_lines = chandler_lines:
#     print("대사 횟수가 같습니다.")

# 올바른 사용: 두 변수의 값이 같은지 논리적으로 비교합니다.
if ross_lines == chandler_lines:
    print("대사 횟수가 같습니다.")
```

비교 연산자는 이후 학습할 ‘조건문’(if)에서 참/거짓을 판단하는 핵심 도구로 사용됩니다.


## 복합적인 상황 판단하기 (논리 연산자)

"**논리 연산자(Logical Operator)**"는 여러 개의 불리언(`True`/`False`) 값들을 조합하여 더 복잡한 조건을 만들어냅니다. 특정 인물들의 관계, 특정 장소에서의 사건 발생 여부 등을 판단하는 데 사용될 수 있습니다.

* **`and` (그리고):** 양쪽 조건이 모두 `True`일 때만 `True`.
* **`or` (또는):** 양쪽 조건 중 하나라도 `True`이면 `True`.
* **`not` (아니다):** 뒤의 불리언 값을 반대로 바꿈 (`True` -> `False`, `False` -> `True`).

이제 논리 연산자 개념의 숙지를 위해 간단한 코드를 실행시켜 보겠습니다.

```
# 로스와 레이첼의 등장 여부를 불리언 변수에 저장합니다.
ross_present = True
rachel_present = True

# 두 조건이 모두 True인지 확인합니다. ('and' 연산자 사용)
ross_and_rachel_together = ross_present and rachel_present

# 논리 연산 결과를 출력합니다.
print(f"로스와 레이첼이 함께 등장하는 장면인가?: {ross_and_rachel_together}")
```

**실행 및 설명**

* 결과 확인: `로스와 레이첼이 함께 등장하는 장면인가?: True`
* 두 변수가 모두 `True`이므로 `and` 연산의 결과는 `True`입니다. 이는 특정 인물들의 관계나 상호작용을 분석할 때 기초가 됩니다.

```
# 장소와 화자 정보를 불리언 변수에 저장합니다.
is_location_central_perk = False
speaker_is_gunther = True

# 둘 중 하나라도 True인지 확인합니다. ('or' 연산자 사용)
is_central_perk_or_gunther = is_location_central_perk or speaker_is_gunther

# 논리 연산 결과를 출력합니다.
print(f"센트럴 퍼크 장면이거나 건터의 대사인가?: {is_central_perk_or_gunther}")
```

**실행 및 설명**

* 결과 확인: `센트럴 퍼크 장면이거나 건터의 대사인가?: True`
* `speaker_is_gunther`가 `True`이므로, `or` 연산의 결과는 `True`가 됩니다. 여러 조건 중 하나만 만족해도 되는 경우를 판단할 때 사용됩니다.

```
# 아파트 언급 여부를 불리언 변수에 저장합니다.
apartment_not_mentioned = True

# 변수 값을 직접 사용하여 확인합니다. (또는 not apartment_mentioned 와 같이 반대 변수를 사용할 수도 있습니다)
print(f"아파트가 언급되지 않은 장면인가?: {apartment_not_mentioned}")

# (참고) not 연산자를 사용하는 다른 방식
# is_apartment_mentioned = False # apartment_not_mentioned가 True이므로 이것은 False
# result = not is_apartment_mentioned
# print(f"아파트가 언급되지 않은 장면인가? (not 사용): {result}")
```

**실행 및 설명**

* 결과 확인: `아파트가 언급되지 않은 장면인가?: True`
* `not` 연산자는 특정 조건이 아닐 경우를 확인할 때 유용합니다.

```
# 관련 조건들을 불리언 변수에 저장합니다.
monica_talks_cooking = True
is_monica_apt = True
is_central_perk = False

# 복합 조건을 논리 연산자 'and', 'or'와 괄호()를 사용하여 구성합니다.
# 모니카가 요리 이야기를 '하고' (그리고) 장소가 모니카 아파트 '이거나' 센트럴 퍼크 '이다'
is_monica_cooking_scene = monica_talks_cooking and (is_monica_apt or is_central_perk)

# 최종 논리 연산 결과를 출력합니다.
print(f"모니카가 아파트나 센트럴퍼크에서 요리 이야기를 하는 장면인가?: {is_monica_cooking_scene}")
```

**실행 및 설명**

* 결과 확인: `모니카가 아파트나 센트럴퍼크에서 요리 이야기를 하는 장면인가?: True`
* 괄호 안의 `is_monica_apt or is_central_perk`가 먼저 계산됩니다 (`True or False` -> `True`).
* 그 다음 `monica_talks_cooking and True`가 계산됩니다 (`True and True` -> `True`).
* 이처럼 `and`, `or`, `not`과 괄호를 조합하여 복잡한 조건을 만들어 특정 상황에 맞는 데이터를 필터링하거나 분석할 수 있습니다.


### 정리
이번 섹션에서는 파이썬의 기본 연산자들을 "프렌즈" 대본 분석이라는 인문학적 맥락에서 살펴보았습니다. 

숫자를 계산하는 **산술 연산자**, 값들을 비교하는 **비교 연산자**, 그리고 참/거짓 조건을 조합하는 **논리 연산자**는 대본 데이터에서 정량적 정보를 추출하고, 캐릭터나 장면의 특징을 비교하며, 복합적인 조건을 통해 특정 데이터를 선별하는 등 다양한 인문학적 분석의 기초가 됩니다. 각 연산자의 기능과 사용법을 잘 익혀두시기 바랍니다.