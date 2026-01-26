---
title: 추출된 데이터를 NetworkX 입력 형태로 변환 및 저장
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

[TOC]

## 3.5. 추출된 데이터를 NetworkX 입력 형태로 변환 및 저장

지금까지 우리는 '프렌즈' 대본이라는 원석을 탐험하며, 노드(등장인물)를 식별하고 정제했으며, 엣지(관계)를 정의하고 가중치를 부여하는 모든 개념적, 방법론적 논의를 마쳤습니다. 그 결과 우리의 손에는 이제 두 가지 중요한 재료가 들려 있습니다. 첫째는 분석 대상이 될 **인물 목록**과 각 인물의 **발화 횟수 정보**, 둘째는 인물들 사이의 방향과 강도를 모두 담고 있는 **가중치가 부여된 방향성 엣지 목록**입니다.

하지만 이 재료들은 아직 요리를 시작하기에 좋은 상태가 아닙니다. NetworkX라는 '요리사'가 바로 사용할 수 있도록, 레시피에 맞는 형태로 재료를 손질하고 그릇에 담아내는 과정이 필요합니다. 이번 섹션에서는 이렇게 추출된 원시 데이터를 NetworkX의 `add_nodes_from()`과 `add_edges_from()` 함수가 요구하는 정확한 입력 형태로 변환하는 방법을 배웁니다.

나아가, 이렇게 힘들여 편찬한 데이터를 파일로 저장하여, 다음번에 분석할 때는 지루하고 오래 걸리는 추출 과정을 반복할 필요 없이 곧바로 불러와 재사용하는, 효율적인 연구 워크플로우의 구축 방법까지 알아보겠습니다.

---

### 3.5.1. 노드 리스트 (노드 ID, 노드 속성 포함) 생성

수백 개의 노드와 그 속성을 한 번에 추가하려면, NetworkX가 요구하는 특별한 형식의 리스트를 만들어야 합니다.

* **NetworkX가 요구하는 형식:** **`(노드이름, 속성_딕셔너리)`** 형태의 튜플(tuple)들이 담긴 리스트

즉, `[ (노드1, {속성A: 값1, 속성B: 값2}), (노드2, {속성A: 값3, 속성B: 값4}), ... ]` 와 같은 구조입니다.

우리는 `unique_characters` 리스트와 `speaker_counts` 객체(Counter)를 가지고 있습니다. 이 두 가지를 조합하여, 각 노드에 '발화량(speech_count)' 속성을 포함하는 노드 리스트를 생성할 수 있습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# (3.2절에서 생성한 unique_characters와 speaker_counts 변수가 필요합니다)

# 1. 빈 노드 리스트 생성
node_list_for_nx = []

# 2. unique_characters 목록을 순회하며 NetworkX 형식에 맞게 데이터 추가
for character in unique_characters:
    # 각 인물의 속성 딕셔너리 생성
    attributes = {'speech_count': speaker_counts[character]}
    # (노드이름, 속성_딕셔너리) 튜플을 리스트에 추가
    node_list_for_nx.append((character, attributes))

print("3.5.1. NetworkX 입력용 노드 리스트 생성 완료")
# 생성된 리스트의 처음 5개 항목을 확인
print("생성된 노드 리스트 (상위 5개):", node_list_for_nx[:5])
```


#### [설명]
위 코드를 통해, 543명의 전체 인물 각각에 대해 이름과 발화 횟수 속성을 짝지어 `(인물이름, {'speech_count': 횟수})` 형태의 튜플로 만들고, 이 튜플들을 하나의 큰 리스트 `node_list_for_nx`에 담았습니다. 이제 이 리스트를 `G.add_nodes_from()`에 그대로 넣어주면, 모든 노드와 각 노드의 속성이 한 번에 그래프에 추가됩니다.

---

### 3.5.2. 엣지 리스트 (출발 노드, 도착 노드, 가중치 포함) 생성

가중치와 방향성이 있는 엣지를 한 번에 추가하기 위해 NetworkX가 요구하는 형식은 다음과 같습니다.

* **NetworkX가 요구하는 형식:** **`(출발_노드, 도착_노드, 속성_딕셔너리)`** 형태의 튜플들이 담긴 리스트

`[ (노드A, 노드B, {weight: 10}), (노드B, 노드C, {weight: 5}), ... ]` 와 같은 구조입니다. 우리는 `weighted_directed_edges` 객체(Counter)를 가지고 있으므로, 이를 이용해 이 형식에 맞는 리스트를 생성할 수 있습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# (3.4절에서 생성한 weighted_directed_edges 변수가 필요합니다)

# 1. 빈 엣지 리스트 생성
edge_list_for_nx = []

# 2. weighted_directed_edges 딕셔너리를 순회하며 데이터 추가
for edge, count in weighted_directed_edges.items():
    # edge는 ('발화자', '참여자') 형태의 튜플
    source = edge[0]
    target = edge[1]
    
    # 각 엣지의 속성 딕셔너리 생성
    attributes = {'weight': count}
    
    # (출발_노드, 도착_노드, 속성_딕셔너리) 튜플을 리스트에 추가
    edge_list_for_nx.append((source, target, attributes))

print("3.5.2. NetworkX 입력용 엣지 리스트 생성 완료")
# 생성된 리스트의 처음 5개 항목을 확인
print("생성된 엣지 리스트 (상위 5개):", edge_list_for_nx[:5])
```

#### [설명]
`weighted_directed_edges`에 저장된 모든 관계에 대해, `(출발자, 도착자, {'weight': 횟수})` 형태의 튜플로 변환하여 `edge_list_for_nx`에 담았습니다. 이제 이 리스트를 `G.add_edges_from()`에 넣어주면, 가중치 정보가 포함된 모든 방향성 엣지가 그래프에 한 번에 추가됩니다.

---

### 3.5.3. 데이터 파일 저장 및 재사용

'프렌즈' 대본 전체를 읽고, 파싱하고, 정규화하고, 빈도를 세어 노드와 엣지 리스트를 만드는 과정은 꽤 많은 시간이 걸릴 수 있습니다. 분석을 할 때마다 이 과정을 반복하는 것은 매우 비효율적입니다. 따라서 **한 번 힘들여 편찬한 데이터는 파일 형태로 저장해두고, 다음부터는 저장된 파일을 바로 불러와 사용**하는 것이 현명한 연구자의 작업 방식입니다.

네트워크 데이터를 저장하는 가장 보편적이고 이해하기 쉬운 형식은 **CSV(Comma-Separated Values)** 입니다. 우리는 `노드 리스트`와 `엣지 리스트`를 각각 별도의 CSV 파일로 저장할 것입니다. 데이터를 표 형태로 다루고 CSV로 저장하는 데는 **Pandas** 라이브러리가 최고의 도구입니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# pandas 라이브러리 불러오기
import pandas as pd

# --- 노드 리스트를 CSV로 저장 ---
# 1. 노드 데이터를 표(DataFrame)로 변환
node_df_data = [{'node_id': node, 'speech_count': attr['speech_count']} for node, attr in node_list_for_nx]
node_df = pd.DataFrame(node_df_data)

# 2. CSV 파일로 저장
node_df.to_csv('friends_all_nodes.csv', index=False, encoding='utf-8-sig')
print("'friends_all_nodes.csv' 파일 저장 완료.")
print(node_df.head())


# --- 엣지 리스트를 CSV로 저장 ---
# 1. 엣지 데이터를 표(DataFrame)로 변환
edge_df_data = [{'source': u, 'target': v, 'weight': attr['weight']} for u, v, attr in edge_list_for_nx]
edge_df = pd.DataFrame(edge_df_data)

# 2. CSV 파일로 저장
edge_df.to_csv('friends_all_edges.csv', index=False, encoding='utf-8-sig')
print("\n'friends_all_edges.csv' 파일 저장 완료.")
print(edge_df.head())
```


#### [설명]
위 코드를 실행하면, 여러분의 Colab 작업 공간에 `friends_all_nodes.csv`와 `friends_all_edges.csv` 두 개의 파일이 생성됩니다. `node_df.head()`와 `edge_df.head()`는 저장된 데이터의 처음 5줄을 보여주어, 데이터가 표 형태로 잘 정리되었는지 확인하게 해줍니다.

이렇게 두 개의 파일을 저장해두면, 다음번에는 복잡한 XML 파싱 과정 없이 `pd.read_csv()`라는 함수로 이 파일들을 바로 읽어들여 네트워크 분석을 시작할 수 있습니다. 이는 연구의 재현성과 효율성을 높이는 핵심적인 습관입니다.

### 🤖 AI와 함께 탐색하기: 데이터를 NetworkX '레시피'로 변환하기

**학습 목표:** 파이썬의 기본 데이터 구조(딕셔너리, 리스트)로 표현된 정보를, NetworkX 라이브러리가 요구하는 정형화된 입력 데이터(튜플의 리스트)로 변환하는 프로그래밍 로직을 구상하고 AI에게 요청하는 연습을 합니다.

**간단 프롬프트:**
`파이썬으로, ['Monica', 'Rachel'] 노드 리스트와 [('Monica', 'Rachel')] 엣지 리스트를 NetworkX에 추가하는 코드를 만들어줘.`

**상세 프롬프트:**
`나는 두 개의 파이썬 딕셔너리를 가지고 있어.`
`- 첫 번째 딕셔너리: node_attributes = {'A': {'role': 'leader'}, 'B': {'role': 'member'}}`
`- 두 번째 딕셔너리: edge_weights = {('A', 'B'): 5}`
`이 두 딕셔너리의 정보를 사용해서, NetworkX의 add_nodes_from과 add_edges_from 함수에 바로 입력할 수 있는 '노드 리스트'와 '엣지 리스트'를 생성하는 파이썬 코드를 짜줘. (힌트: 리스트는 [(노드, 속성dict), ...] 와 [(노드1, 노드2, 속성dict), ...] 형태여야 해)`

**인문학적 프롬프트:**
`데이터를 CSV나 GraphML 같은 표준화된 파일 형식으로 '저장'하는 행위는, 우리의 복잡하고 뉘앙스 가득한 인문학적 해석을 기계가 읽을 수 있는 형태로 '고정'하고 '납작하게' 만드는 과정이야. 이 과정에서 어떤 정보나 맥락이 필연적으로 사라지게 될까? 그리고 미래의 다른 연구자가 우리의 데이터 파일을 재사용할 때, 원본 텍스트나 우리의 '데이터 편찬 결정 과정'에 대한 정보 없이 데이터 파일만 본다면 어떤 오해를 할 수 있을까? 데이터의 '투명성'과 '재현성'을 위해 데이터 파일과 함께 반드시 제공되어야 하는 것은 무엇인지 논해줘. (예: README 파일, 데이터 사전 등)`