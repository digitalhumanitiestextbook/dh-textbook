---
title: 네트워크 정보 기반 고급 시각화
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

## 6.3. 네트워크 정보 기반 고급 시각화

6.2절에서 우리는 네트워크의 기본적인 "뼈대"를 그리는 법을 배웠습니다. 하지만 진정한 의미의 데이터 시각화는 여기서 한 걸음 더 나아가, 우리가 5장에서 힘들여 계산한 **분석 결과(중심성 점수, 관계의 가중치 등)를 그림 위에 덧입히는 것**입니다.

이는 마치 흑백 지도 위에 인구 밀도나 자원의 분포를 색과 크기로 표현하여, 한눈에 핵심 정보를 파악할 수 있는 "주제도(thematic map)"를 만드는 것과 같습니다. 노드의 크기를 다르게 하여 누가 중요한지 보여주고, 엣지의 굵기를 조절하여 누구의 관계가 더 끈끈한지 표현하며, 노드의 색을 바꾸어 소속 그룹을 나타내는 등, 다양한 시각적 장치를 통해 우리는 데이터 속에 숨겨진 이야기를 더욱 설득력 있게 전달할 수 있습니다.

이번 섹션에서는 9명의 핵심 인물로 구성된 `G_core` 네트워크를 대상으로, 다양한 분석 정보를 시각적 요소에 "인코딩"하는 구체적인 코드 기법들을 단계별로 배워보겠습니다.

---

### 1단계: 분석을 위한 데이터 준비

먼저, 시각화에 사용할 `G_core` 네트워크와, 5장에서 계산했던 각 인물의 중심성 데이터를 다시 준비하겠습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요. `G_directed`와 `main_characters_100` 변수가 필요합니다.)

#### [코드]
```
import networkx as nx
import matplotlib.pyplot as plt

# 1. 핵심 그룹(9명) 네트워크 생성
G_core = G_directed.subgraph(main_characters_100)

# 2. 시각화에 사용할 중심성 데이터 계산
# (가중) 연결 중심성 (총 상호작용량)
total_strength = dict(G_core.degree(weight='weight'))

# 아이겐벡터 중심성 (간접적 영향력)
eigenvector_centrality = nx.eigenvector_centrality(G_core, weight='weight', max_iter=1000)

print("1단계: 시각화를 위한 핵심 그룹 네트워크 및 중심성 데이터 준비 완료")
```

#### [설명]
9명의 핵심 인물로 구성된 `G_core` 그래프를 생성하고, 이들의 총 상호작용량(가중 연결 중심성)과 아이겐벡터 중심성 값을 다시 계산하여 각각 딕셔너리에 저장했습니다. 이제 이 숫자들을 시각적 요소로 변환할 준비를 마쳤습니다.

---

### 6.3.1. 노드 크기를 "총 상호작용량"에 따라 조절하기

네트워크에서 가장 중요한 노드를 시각적으로 강조하는 가장 효과적인 방법은 **크기**를 다르게 하는 것입니다. "총 상호작용량(가중 연결 중심성)"이 높은 인물일수록 더 큰 노드로 그려서, 누가 이 네트워크의 "주인공"인지 한눈에 보여줄 수 있습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 1. 노드 크기 리스트 생성
# total_strength 딕셔너리에서 각 노드의 상호작용량을 가져옵니다.
# G_core.nodes() 순서에 맞게 크기 값을 리스트에 담아야 합니다.
node_sizes = [total_strength[node] for node in G_core.nodes()]

# 2. 크기가 너무 크므로 적절한 비율로 축소합니다. (예: 20으로 나누기)
# 이 비율(scaling factor)은 데이터에 맞게 조절해야 합니다.
scaled_node_sizes = [size / 20 for size in node_sizes]

# 3. 시각화
plt.figure(figsize=(10, 10))
pos = nx.kamada_kawai_layout(G_core) # 미학적으로 보기 좋은 레이아웃 선택

nx.draw(G_core, pos, with_labels=True, 
        node_size=scaled_node_sizes, # 계산된 크기 리스트를 전달
        node_color='gold',
        edge_color='lightgray',
        width=1.5,
        font_size=12,
        font_weight='bold')

plt.title("Node Size by Total Interaction Volume", fontsize=16)
plt.show()
```

#### [설명]
`total_strength` 딕셔너리에서 각 노드의 총 상호작용량을 가져와 리스트 `node_sizes`를 만들었습니다. 하지만 이 숫자(수만 단위)를 그대로 노드 크기로 사용하면 화면을 가득 채우므로, `20`이라는 비율로 나누어 적절히 크기를 조절했습니다. `nx.draw` 함수의 `node_size` 파라미터에 이 리스트를 전달하면, NetworkX는 노드 순서에 맞게 각 노드에 다른 크기를 적용하여 그림을 그려줍니다. 결과적으로, 상호작용량이 많은 주인공 6명의 노드가 그렇지 않은 조연들보다 훨씬 더 크게 그려져, 핵심 그룹의 존재감을 시각적으로 확인할 수 있습니다.

---

### 6.3.2. 노드 색상을 "아이겐벡터 중심성"에 따라 구분하기

**색상**은 노드의 또 다른 속성이나 분석 결과를 표현하는 데 매우 효과적입니다. 이번에는 "관계의 질"과 "간접적 영향력"을 나타내는 "아이겐벡터 중심성" 점수에 따라 노드의 색을 다르게 칠해 보겠습니다. 점수가 높을수록 더 진한 색으로 표현하여, 누가 "인싸들의 인싸"인지 강조할 수 있습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 1. 노드 색상 리스트 생성
# eigenvector_centrality 딕셔너리에서 각 노드의 중심성 점수를 가져옵니다.
node_colors = [eigenvector_centrality[node] for node in G_core.nodes()]

# 2. 시각화
plt.figure(figsize=(10, 10))
# pos는 이전 단계에서 계산한 값을 재사용하여 같은 위치에 그리게 합니다.

# cmap=plt.cm.YlOrRd 옵션은 숫자 값을 색상으로 변환하는 '컬러맵'을 지정합니다.
# 숫자가 낮으면 노란색 계열, 높으면 붉은색 계열로 표현됩니다.
nx.draw(G_core, pos, with_labels=True, 
        node_size=scaled_node_sizes, # 이전 단계의 크기 조절을 함께 사용
        node_color=node_colors,      # 계산된 색상 리스트를 전달
        cmap=plt.cm.YlOrRd,
        edge_color='lightgray',
        width=1.5,
        font_size=12,
        font_weight='bold')

plt.title("Node Color by Eigenvector Centrality", fontsize=16)
plt.show()
```

#### [설명]
아이겐벡터 중심성 점수 리스트를 `node_color` 파라미터에 전달하고, `cmap` 옵션을 지정하면 Matplotlib이 자동으로 각 노드의 숫자 값에 해당하는 색상을 입혀줍니다. `YlOrRd`는 노랑-주황-빨강으로 이어지는 컬러맵으로, 값의 높낮이를 인지하기 좋습니다. 시각화 결과, 아이겐벡터 중심성이 가장 높았던 챈들러와 모니카의 노드가 가장 진한 붉은색으로, 다른 주인공들은 그보다 옅은 색으로 표현되어, 이들 커플이 그룹 내에서 가장 큰 간접적 영향력을 가졌음을 한눈에 파악할 수 있습니다.

---

### 6.3.3. 엣지 두께를 "관계의 강도"에 따라 조절하기

지금까지는 노드에만 정보를 입혔지만, **엣지(관계)** 역시 중요한 정보를 담고 있습니다. 엣지의 **두께**를 관계의 강도, 즉 `weight` 값에 비례하도록 조절하면, 누구와 누구의 관계가 특별히 더 끈끈한지를 시각적으로 강조할 수 있습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 1. 엣지 두께 리스트 생성
# G_core의 모든 엣지를 순회하며 'weight' 속성 값을 가져옵니다.
edge_weights = [d['weight'] for u, v, d in G_core.edges(data=True)]

# 2. 두께가 너무 두꺼워지지 않도록 적절한 비율로 축소합니다. (예: 500으로 나누기)
scaled_edge_widths = [weight / 500 for weight in edge_weights]

# 3. 모든 것을 통합한 최종 시각화
plt.figure(figsize=(12, 12))

nx.draw(G_core, pos, with_labels=True, 
        node_size=scaled_node_sizes,   # 크기는 총 상호작용량
        node_color=node_colors,        # 색상은 아이겐벡터 중심성
        cmap=plt.cm.YlOrRd,
        width=scaled_edge_widths,      # 두께는 관계의 강도
        edge_color='salmon',           # 엣지 색상도 변경
        font_size=12,
        font_weight='bold')

plt.title("Friends Core Network: 종합 시각화", fontsize=16)
plt.show()
```

#### [설명]
`G_core.edges(data=True)`를 통해 각 엣지의 속성 딕셔너리에 접근하여 `weight` 값을 추출하고, 이를 적절히 축소하여 `width` 파라미터에 전달했습니다.

최종 시각화 결과물은 이제 여러 층의 정보를 동시에 담고 있습니다.
- **노드의 크기**는 그 인물의 "총 상호작용량"을,
- **노드의 색상**(진할수록 높음)은 "인싸들 사이에서의 영향력"을,
- **엣지의 두께**는 두 사람의 "관계의 강도"를 나타냅니다.

이 한 장의 그림을 통해 우리는, "주인공 6명은 모두 상호작용이 많지만(큰 노드), 그중에서도 챈들러와 모니카가 다른 중요한 인물들과의 관계를 통해 가장 높은 간접적 영향력을 가지며(진한 노드 색상), 특히 이들 커플과 로스-레이첼 커플 사이에는 다른 관계보다 훨씬 더 강한 유대가 존재한다(굵은 엣지)"는 복합적인 이야기를 한눈에 설득력 있게 전달할 수 있게 되었습니다.

### 🤖 AI와 함께 탐색하기: 데이터로 그림에 생명 불어넣기

**학습 목표:** 분석 결과를 시각적 요소(크기, 색, 두께 등)에 인코딩하는 구체적인 방법을 이해하고, 이를 조합하여 풍부한 정보를 담은 네트워크를 시각화하는 능력을 기릅니다.

**간단 프롬프트:**
`네트워크를 그릴 때, 중요한 노드는 더 크게, 중요한 관계는 더 굵게 표현하는 파이썬 코드를 알려줘.`

**상세 프롬프트:**
`내가 만든 NetworkX 그래프 G가 있어. 이 그래프를 다음과 같은 규칙으로 시각화하는 코드를 생성해줘.`
`1. 각 노드의 "연결 중심성"을 계산해서, 그 값에 비례하여 노드 크기를 정해줘.`
`2. 각 노드에 "gender"라는 속성("male" 또는 "female")이 저장되어 있어. 남성은 "blue"로, 여성은 "red"로 노드 색깔을 다르게 칠해줘.`
`3. 각 엣지에는 "weight" 속성이 있어. 이 값에 비례하여 엣지의 두께를 정해줘.`
`4. 최종적으로 이 모든 정보를 담은 하나의 네트워크 그림을 그려줘.`

**인문학적 프롬프트:**
`우리는 지금 분석 결과를 노드의 크기, 색, 엣지 두께 등 다양한 시각적 변수에 "인코딩"했어. 이러한 인코딩 과정은 연구자의 "해석"과 "주장"이 개입되는 행위야. 만약 우리가 매개 중심성이 아닌 아이겐벡터 중심성을 노드 색상에 매핑했다면, 이 그림은 전혀 다른 이야기를 했을 거야. 연구자가 어떤 데이터를 어떤 시각적 요소에 매핑할지 "선택"하는 과정의 중요성에 대해 논해줘. 이 선택이 어떻게 독자의 해석을 유도하고, 연구자의 주장을 강화하는 "수사학적 장치"로 작동하는지 설명해줘.`