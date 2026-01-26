---
title: 추출된 노드와 엣지 정보를 사용하여 NetworkX 그래프 객체 생성
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

## 4.2. 그래프 객체 생성: 데이터로 '프렌즈' 세계 조립하기

앞선 4.1절에서 우리는 `Friends.xml`이라는 광산에서 원석을 캐내고, 제련하여 마침내 두 개의 빛나는 보물을 손에 넣었습니다. 바로 분석의 대상이 될 **417명의 전체 등장인물 목록(노드)**과, 그들 사이의 **2,962개의 방향성 관계 및 강도 정보(엣지)**입니다.

이제 남은 과정은 이 재료들을 가지고 실제 NetworkX 그래프라는 '건축물'을 조립하는 일뿐입니다. 이 과정은 이미 2장과 3장에서 개념적으로 모두 학습했기 때문에 훨씬 수월하게 느껴질 것입니다. 흩어져 있던 데이터 조각들이 하나의 의미 있는 `G_directed`라는 그래프 객체로 통합되는, 이 프로젝트의 가장 만족스러운 순간 중 하나를 경험하게 될 것입니다.

---

### 1단계: 비어있는 방향성 그래프 캔버스 준비하기

모든 것의 시작은 비어있는 그래프 객체를 생성하는 것입니다. 우리의 '발화자-장면참여자' 모델은 관계의 방향이 중요하므로, 방향성 그래프를 만들 수 있는 `nx.DiGraph()` 함수를 사용해야 합니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# NetworkX 라이브러리를 불러옵니다. (이미 불러왔다면 생략 가능)
import networkx as nx

# 방향성 그래프(Directed Graph) 객체를 생성합니다.
G_directed = nx.DiGraph()

print("1단계: 비어있는 방향성 그래프 G_directed 생성 완료.")
```

#### [설명]
NetworkX의 `DiGraph()` 함수를 이용해 방향성이 있는 빈 그래프 객체를 만들고, `G_directed`라는 변수에 저장했습니다. 지금 `G_directed`는 417명의 배우가 오를 무대이지만, 아직 아무도 올라오지 않은 깨끗한 캔버스 상태입니다.

---

### 2단계: 노드와 노드 속성 추가하기

이제 4.1절에서 확정한 417명의 전체 등장인물(`unique_characters_all`)을 노드로 추가합니다. 이때, 각 인물의 '총 발화 횟수'를 `speech_count`라는 속성으로 함께 부여하여, 그래프를 더 풍부한 정보를 담은 객체로 만들겠습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요. 4.1절에서 생성된 `unique_characters_all`과 `speaker_counts` 변수가 필요합니다.)

#### [코드]
```
# (4.1절에서 생성한 unique_characters_all과 speaker_counts 변수가 필요합니다)

# 3.5.1절에서 배운 (노드, {속성}) 형태의 리스트를 생성합니다.
node_list_for_nx = [(char, {'speech_count': speaker_counts[char]}) for char in unique_characters_all]

# 생성된 리스트를 이용해 그래프에 노드와 속성을 한 번에 추가합니다.
G_directed.add_nodes_from(node_list_for_nx)

print("2단계: 노드와 'speech_count' 속성 추가 완료.")

# --- 작업 확인 (노드) ---
print(f"현재 그래프의 노드 수: {G_directed.number_of_nodes()}")
# 특정 노드의 속성이 잘 들어갔는지 확인합니다.
print(f"'Monica' 노드의 속성 정보: {G_directed.nodes['Monica']}")
print(f"'Gunther' 노드의 속성 정보: {G_directed.nodes['Gunther']}")
```


#### [실행 결과]
2단계: 노드와 'speech_count' 속성 추가 완료.
현재 그래프의 노드 수: 417
'Monica' 노드의 속성 정보: {'speech_count': 4460}
'Gunther' 노드의 속성 정보: {'speech_count': 55}

#### [결과 해석]
417명의 전체 인물이 `G_directed`에 노드로 성공적으로 추가되었습니다. `G.number_of_nodes()`를 통해 그 개수를 확인할 수 있습니다. 더 중요한 것은, 각 노드에 우리가 부여하고자 했던 속성 정보가 잘 저장되었다는 점입니다. 예를 들어, `Monica` 노드의 속성을 확인해 보니, 그녀의 총 발화 횟수인 `4460`이 `speech_count`라는 이름표와 함께 잘 기록되어 있습니다. 이는 `Gunther`와 같은 다른 모든 조연, 단역에게도 동일하게 적용됩니다. 이 속성 데이터는 향후 '발화량이 많은 인물의 노드 크기를 더 크게' 그리는 등, 시각화나 분석을 더 풍부하게 만드는 데 사용될 수 있습니다.

---

### 3단계: 엣지와 엣지 가중치 추가하기

다음으로, 인물들 사이의 관계, 즉 엣지를 추가합니다. 4.1절에서 계산한 `weighted_directed_edges` 객체에는 A가 발화했을 때 B가 함께 있었던 횟수 정보가 담겨있습니다. 이 횟수를 `weight`라는 엣지 속성으로 부여하여 관계의 강도를 표현해 보겠습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요. 4.1절에서 생성된 `weighted_directed_edges` 변수가 필요합니다.)

#### [코드]
```
# (4.1절에서 생성한 weighted_directed_edges 변수가 필요합니다)

# 3.5.2절에서 배운 (출발노드, 도착노드, {속성}) 형태의 리스트를 생성합니다.
edge_list_for_nx = [(source, target, {'weight': count}) for (source, target), count in weighted_directed_edges.items()]

# 생성된 리스트를 이용해 그래프에 엣지와 가중치를 한 번에 추가합니다.
G_directed.add_edges_from(edge_list_for_nx)

print("3단계: 엣지와 'weight' 속성 추가 완료.")

# --- 작업 확인 (엣지) ---
print(f"현재 그래프의 엣지 수: {G_directed.number_of_edges()}")
# 특정 엣지의 속성이 잘 들어갔는지 확인합니다.
print(f"'Monica' -> 'Chandler' 엣지 속성 정보: {G_directed.edges[('Monica', 'Chandler')]}")
print(f"'Chandler' -> 'Monica' 엣지 속성 정보: {G_directed.edges[('Chandler', 'Monica')]}")

#### [실행 결과]
3단계: 엣지와 'weight' 속성 추가 완료.
현재 그래프의 엣지 수: 2962
'Monica' -> 'Chandler' 엣지 속성 정보: {'weight': 2928}
'Chandler' -> 'Monica' 엣지 속성 정보: {'weight': 2767}
```

#### [결과 해석]
`weighted_directed_edges`에 저장된 **2,962개**의 모든 방향성 관계가 `G_directed`에 엣지로 모두 추가되었습니다. `G.number_of_edges()`를 통해 이를 확인했습니다. 또한 `G_directed.edges[]`를 통해 특정 엣지의 속성을 확인해 보니, `Monica`가 `Chandler`를 향해 생성한 관계의 강도는 2928, 반대로 `Chandler`가 `Monica`를 향해 생성한 관계의 강도는 2767로, 그 방향성과 가중치가 정확하게 기록되었음을 알 수 있습니다.

이것으로, 우리는 **417개의 노드**와 **2,962개의 방향성 엣지**를 가진, '프렌즈'의 사회적 세계 전체를 담고 있는 완전한 네트워크 모델을 성공적으로 조립했습니다.

### 🤖 AI와 함께 탐색하기: 재료부터 그래프 완성까지 한번에 요청하기

**학습 목표:** 데이터 준비부터 그래프 객체 생성 및 확인까지, 여러 단계로 나뉜 작업을 하나의 논리적 흐름으로 묶어 AI에게 요청하는 종합적인 프롬프트 작성 능력을 훈련합니다.

**간단 프롬프트:**
`파이썬으로, 노드는 ['A', 'B'], 엣지는 [('A', 'B')]인 NetworkX 방향성 그래프를 만들고, 노드와 엣지의 개수를 출력해줘.`

**상세 프롬프트:**
`내가 만든 파이썬 리스트가 있어: `
`all_characters = ['A', 'B', 'C']`
`interactions = [('A', 'B'), ('A', 'C'), ('A', 'B')]`
`위 interactions 리스트는 ('발화자', '청자') 관계를 나타내.`
`이 데이터를 바탕으로, NetworkX 방향성 그래프(DiGraph)를 생성하고 확인하는 전체 과정을 수행하는 코드를 생성해줘. 다음 요구사항을 모두 포함해줘:`
`1. all_characters 리스트를 이용해 노드를 추가해.`
`2. interactions 리스트를 분석해서, 각 방향성 엣지의 발생 횟수를 'weight' 속성으로 하여 엣지를 추가해. (예: ('A', 'B')의 weight는 2)`
`3. 최종적으로 생성된 그래프의 노드 수와 엣지 수를 출력해서 확인해줘.`

**인문학적 프롬프트:**
`우리가 만든 그래프 객체 G_directed는 '프렌즈'라는 원본 텍스트의 '모델'이지, 텍스트 그 자체는 아니야. 이 '모델'을 분석해서 얻은 결론(예: '모니카가 가장 중심적인 인물이다')을 다시 원본 텍스트의 '해석'으로 가져올 때, 우리는 어떤 점을 주의해야 할까? 모델의 단순화된 규칙(우리의 경우 '발화자-장면참여자')이 현실의 복잡성을 어떻게 축소했는지 잊어버리고, 모델의 결과를 현실 그 자체인 것처럼 착각하는 '모델의 함정'에 대해 논해줘. 그리고 이러한 함정을 피하기 위해 디지털 인문학 연구자가 항상 견지해야 할 비판적 자세는 무엇일까?`