---
title: 노드(Node) 정의 - '프렌즈' 등장인물 식별 및 목록화
---

<!-- colab-button:start -->
<div class="colab-button">
  <a
    href="https://colab.research.google.com/github/digitalhumanitiestextbook/dh-textbook/blob/main/notebooks/part8_ai/03_gen_ai_llm.ipynb"
    target="_blank"
    rel="noopener"
  >
    Colab에서 실행하기
  </a>
</div>
<!-- colab-button:end -->

## 3.2. 노드(Node) 정의: '프렌즈' 등장인물 식별 및 목록화

3.1절에서 우리는 연구 전략을 '핵심 그룹' 중심에서 드라마의 '사회적 세계 전체'를 조망하는 것으로 확장했습니다. 이 새로운 질문에 답하기 위한 첫 번째 실질적인 단계는 바로 우리 네트워크의 '배우'들, 즉 **노드(Node) 목록을 확정하는 것**입니다.

이번 섹션에서는 `Friends.xml` 파일의 구조를 먼저 샅샅이 살펴보고, 그 구조를 바탕으로 화자(speaker) 정보를 추출할 것입니다. 그리고 그 과정에서 마주치는 현실 세계의 '지저분한' 데이터를 함께 확인하며, 이를 분석 가능한 형태로 깨끗하게 다듬는 '데이터 정규화(Normalization)' 과정을 거쳐, 최종적으로 우리 네트워크의 기반이 될 '전체 등장인물' 목록을 편찬하는 과정을 단계별로 밟아나가겠습니다.

---

### 3.2.1. 원본 데이터 구조 탐색: 화자 정보는 어디에 있는가?

코드를 작성하기에 앞서, 우리는 먼저 데이터의 '설계도'를 읽는 법을 배워야 합니다. 우리가 사용할 `Friends.xml` 파일은 '**TEI(Text Encoding Initiative)**'라는 인문학 텍스트 표준을 따르는 XML(eXtensible Markup Language) 문서입니다. XML은 마치 컴퓨터의 폴더와 파일처럼, `<태그이름>`과 `</태그이름>`으로 정보를 감싸 계층적인 구조를 만듭니다.

우리의 목표는 이 구조 속에서 '화자(speaker)의 이름'이라는 정보가 어디에 저장되어 있는지 그 '경로'를 찾는 것입니다. `Friends_Korean_TEI.xml` 파일의 일부를 잠시 들여다봅시다.

(아래는 XML 파일 내용의 일부입니다)

```
<div type="scene" n="1" xml_id="episode1_scene1">
  <head>Monica의 아파트, ...</head>
  <sp who="#Monica">
    <speaker>Monica</speaker>
    <p>내 생각에 저 남자가...</p>
  </sp>
  <sp who="#Chandler">
    <speaker>Chandler</speaker>
    <p>참치 샐러드 할래? ...</p>
  </sp>
</div>
```

위 구조에서 우리는 다음과 같은 사실을 알 수 있습니다.

* 하나의 대사 단위는 `<sp>` ... `</sp>` 태그로 묶여 있습니다. `sp`는 speech(대사)를 의미합니다.
* 대사를 한 사람의 이름은 **`<speaker>` ... `</speaker>`** 태그 안에 텍스트 형태로 들어있습니다. 바로 **여기가 우리가 원하는 정보가 있는 곳**입니다.

즉, 우리가 앞으로 할 일은 파이썬을 이용해 이 XML 문서를 열고, 문서 전체를 샅샅이 뒤져서 모든 `<speaker>` 태그를 찾아낸 다음, 그 안에 들어있는 이름들을 모두 수집하는 것입니다.

---

### 3.2.2. 1차 추출 및 데이터의 '현실' 마주하기

이제 화자 이름이 어디 있는지 알았으니, 직접 추출해보고 어떤 문제들이 있는지 자세히 살펴보겠습니다. 처음에는 기본적인 정규화(공백 제거, 대소문자 통일)만 적용하여 데이터를 추출하고, 그 결과를 함께 검토해 보겠습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 1차 정규화된 모든 화자 이름을 저장할 빈 리스트를 생성합니다.
all_speakers_1st_pass = []
# XML 파일 전체를 순회합니다.
for speaker_tag in root.findall(f'.//{TEI_NAMESPACE}speaker'):
    if speaker_tag.text:
        # .strip()으로 양쪽 공백 제거, .title()로 첫 글자만 대문자화 합니다.
        speaker_text = speaker_tag.text.strip().title()
        all_speakers_1st_pass.append(speaker_text)

# Counter를 이용해 어떤 이름들이 얼마나 나오는지 확인해봅니다.
from collections import Counter
speaker_counts_1st = Counter(all_speakers_1st_pass)

print(f"3.2.2. 1차 정규화 후 고유 등장인물 수: {len(speaker_counts_1st)}명")
print("\n발화 횟수 전체 목록 확인:")
# 전체 목록을 모두 출력하여 데이터의 현실을 확인합니다.
print(speaker_counts_1st)
```



#### [실행 결과 및 문제점 발견]
코드를 실행하고 그 결과를 자세히 들여다보면, 데이터가 예상보다 훨씬 '지저분하다'는 현실을 마주하게 됩니다. 실제 출력된 결과(교수님께서 제공해주신 결과)를 바탕으로 문제점을 유형별로 정리해 보겠습니다.

* **① 일반 역할명 포함:** `'여자': 52회`, `'남자': 31회`, `'웨이터': 38회`, `'학생': 7회`, `'감독': 28회` 등, 고유한 이름이 아닌 일반적인 역할명이 다수 포함되어 있습니다.
* **② 여러 캐릭터명 포함:** `'Chandler와 Joey': 9회`, `'Monica와 Phoebe': 8회`, `'Carol과 Susan': 3회`, `'Phoebe, Ross, Rachel': 2회` 처럼 두 사람 혹은 그 이상의 관계를 나타내는 이름이 정제되지 않고 남아있습니다.
* **③ 설명 및 특수기호 포함:** `'Rachel (Monica인 척하며)': 2회`, `'>>> Joey의 속마음': 1회`, `'Buffay, The Vampire Layer': 2회` 처럼 괄호 안에 설명이 붙어 있거나 특수 기호(`>`)를 포함하는 이름들이 있습니다.
* **④ 숫자 포함 이름:** `'소방관 #1': 5회`, `'Gate Attendant #2': 6회`, `'Fireman No. 3': 3회` 와 같이 식별을 위해 숫자가 포함된 이름도 보입니다.
* **⑤ 불필요한 태그명:** `'All'`, `'모두'`, `'Scene'`(만약 있다면) 등 분석에 필요 없는 이름들이 여전히 남아있습니다.

이러한 '노이즈(noise)' 데이터는 우리 네트워크 분석의 정확성을 심각하게 저해합니다. 따라서 우리는 더 정교하고 강력한 **2차 정규화 전략**을 수립해야 합니다.

---

### 3.2.3. 강화된 정규화 전략 수립 및 최종 노드 목록 생성

앞서 발견한 문제점들을 해결하기 위해, 우리는 다음과 같이 한층 더 강화된 정규화 규칙을 적용해야 합니다.

1.  **공동 발화자 분리:** 이름에 쉼표(`,`)나 '그리고', '와/과', '&', 'And'가 포함된 경우, 이를 기준으로 문자열을 분리하여 각각을 개별적인 이름으로 처리합니다. (기존 규칙 강화)
2.  **유효한 이름 형식 필터링:**
    * 이름이 알파벳으로 시작하는 경우만 유효한 등장인물로 간주하여, `>>>` 와 같은 특수 기호로 시작하는 항목을 제거합니다.
    * 이름에 괄호`()`가 포함된 경우를 제거합니다.
    * 이름에 숫자가 포함된 경우를 제거합니다.
3.  **제외 목록 강화:** `UNWANTED_NAMES` 목록에 `'모두'`를 추가하고, 1차 분석에서 발견된 `'여자'`, `'남자'`, `'웨이터'` 등의 일반 역할명들을 추가하여 필터링을 강화합니다.

이러한 규칙들을 적용하여 최종적으로 깨끗한 등장인물 목록을 생성하는 코드는 다음과 같습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 2차 정제를 위한 새로운 제거 목록
# 1차 분석에서 발견한 일반 역할명 등을 추가합니다.
UNWANTED_NAMES_EXPANDED = UNWANTED_NAMES + ['여자', '남자', '웨이터', '학생', '간호사', '선생님', '직원', '점원', '소방관', '배달원', '승무원', '손님', '아이', '감독', '둘', '다들', '여자들', '남자들', '친구들', '아이들', '웨이터들']

# 정규화된 모든 화자 이름을 저장할 빈 리스트를 생성합니다.
all_speakers_normalized = []
for speaker_tag in root.findall(f'.//{TEI_NAMESPACE}speaker'):
    if speaker_tag.text:
        speaker_text = speaker_tag.text.strip()
        
        # 쉼표, '그리고', '과', '와', '&' 등을 모두 쉼표로 통일하여 분리합니다.
        separators = [',', '그리고', '과', '와', '&', 'And']
        for sep in separators:
            speaker_text = speaker_text.replace(sep, ',')
        
        names_raw = speaker_text.split(',')
        
        for name_raw in names_raw:
            name = name_raw.strip().title()
            all_speakers_normalized.append(name)

# 정규화된 전체 이름 목록에서, 강화된 규칙에 따라 최종적으로 필터링합니다.
final_cleaned_speakers = []
for name in all_speakers_normalized:
    # 이름이 비어있거나, 제외 목록에 있거나, 알파벳으로 시작하지 않거나, 숫자가 포함되거나, 괄호가 포함된 경우 제외
    if not name: continue
    if name in UNWANTED_NAMES_EXPANDED: continue
    if not name[0].isalpha(): continue
    if any(char.isdigit() for char in name): continue
    if '(' in name or ')' in name: continue
    
    final_cleaned_speakers.append(name)

# 최종 정제된 목록으로 Counter와 고유 인물 목록을 다시 생성합니다.
speaker_counts = Counter(final_cleaned_speakers)
unique_characters = sorted(list(speaker_counts))

print(f"3.2.3. 최종 노드 목록 생성 완료")
print(f"최종 고유 등장인물 수: {len(unique_characters)}명")
print("\n발화 횟수 전체 목록 확인 (최종 정제 후):")
print(speaker_counts)
```


#### [결과 해석]
두 번에 걸친 정제 과정을 통해, 우리는 훨씬 더 신뢰도 높은 고유 등장인물 목록을 얻었습니다. 최종적으로 '프렌즈' 세계에는 **423명**의 고유한 인물이 등장했음을 확인할 수 있습니다.

`speaker_counts`의 전체 결과를 살펴보면, `'여자'`, `'Chandler와 Joey'` 와 같은 노이즈들이 성공적으로 제거되었음을 알 수 있습니다. 또한 주인공들의 발화 횟수가 1차 정제 때보다 소폭 상승했는데, 이는 `'Phoebe, Ross, Rachel'`과 같이 묶여 있던 이름들이 각 개인에게 합산되었기 때문입니다.

이처럼, 데이터 정제는 단 한 번에 끝나지 않습니다. **[추출 → 전체 확인 → 문제점 발견 → 규칙 수립 → 재추출]** 의 과정을 반복하며 점진적으로 데이터의 질을 높여가는 것, 이것이 바로 디지털 인문학 연구에서 데이터를 다루는 핵심적인 자세입니다. 이제 우리는 이 최종 노드 목록을 가지고 다음 단계로 나아갈 준비를 마쳤습니다.

### 🤖 AI와 함께 탐색하기: 지저분한 데이터 목록 정리하기

**학습 목표:** 정규화(Normalization)가 왜 필요한지 이해하고, 다양한 예외 상황이 포함된 데이터 목록을 정제하기 위한 구체적인 규칙을 AI에게 요청하는 프롬프트를 작성하는 연습을 합니다.

**간단 프롬프트:**
`파이썬으로 ['Ross', 'ross', 'RACHEL', 'Chandler!'] 이 리스트를 ['Ross', 'Rachel', 'Chandler'] 로 깨끗하게 만드는 코드를 짜줘.`

**상세 프롬프트:**
`다음과 같은 파이썬 리스트가 있어: guest_list = ['Kim Hyun', 'Prof. Lee', 'kim hyun', 'Park', 'Dr. Park', 'Choi', 'Guest (unknown)'].`
`이 리스트를 정규화하여 고유한 인물 목록을 만드는 파이썬 코드를 생성해줘. 다음 규칙을 모두 적용해줘:`
`1. 모든 이름은 'Kim Hyun'처럼 Title Case로 변환해.`
`2. 'Prof.', 'Dr.' 같은 직함은 제거하고 이름 앞뒤 공백을 없애줘.`
`3. 괄호 안의 설명 '(unknown)' 같은 부분은 제거해줘.`
`4. 모든 처리 후, 중복된 이름을 제거하여 고유한 이름 목록만 최종적으로 출력해줘.`

**인문학적 프롬프트:**
`우리가 발화 빈도를 기준으로 '주요 인물'과 '보조 인물'을 나누는 것은 편리한 방법이지만, 이는 서사적 '중요성'을 단순히 '발화량'과 동일시하는 것이야. 하지만 한 마디의 결정적인 대사를 하는 인물이 수백 마디의 일상적인 대사를 하는 인물보다 더 중요할 수도 있어. 이처럼 '정량적 지표(등장 빈도)'에 기반한 인물 구분이 가질 수 있는 한계는 무엇이며, 인문학 연구자는 이러한 단순화를 보완하기 위해 어떤 '질적 분석'을 함께 수행해야 할지에 대해 논해줘.`