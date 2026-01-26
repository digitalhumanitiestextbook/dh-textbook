---
title: NetworkX와 Matplotlib을 이용한 기본 시각화
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

## 6.2. NetworkX와 Matplotlib을 이용한 기본 시각화

시각화의 중요성을 알았다면, 이제 직접 우리의 손으로 '프렌즈' 네트워크라는 지도를 그려볼 차례입니다. 이번 섹션에서는 파이썬의 시각화 라이브러리인 **`Matplotlib`**과 `NetworkX`를 함께 사용하여, 네트워크를 그리고, 다양한 옵션을 통해 더 의미 있고 보기 좋게 만드는 구체적인 방법을 배우게 됩니다.

우리가 만든 전체 417명의 네트워크를 한 번에 그리면, 너무 복잡해서 알아볼 수 없는 '털 뭉치(hairball)'가 될 것입니다. 따라서 학습의 편의를 위해, 우선 **주인공 6명으로만 구성된 작은 샘플 네트워크**를 만들어 시각화의 기본 기능을 익히고, 그 원리를 이해한 뒤에 더 복잡한 네트워크에 도전해 보겠습니다.

---

### 6.2.1. 기본 그리기: `nx.draw()` 함수와 주요 옵션

NetworkX 그래프를 그리는 가장 기본이 되는 함수는 `nx.draw()`입니다. 이 함수에 우리가 만든 그래프 객체와 몇 가지 옵션을 전달하는 것만으로도 충분히 아름다운 그림을 그릴 수 있습니다.

#### [1단계: 샘플 네트워크 생성 및 라이브러리 불러오기]

먼저, 시각화 실습에 사용할 주인공 6명의 샘플 그래프 `G_sample`을 만들고, 시각화에 필요한 `matplotlib.pyplot`을 `plt`라는 별명으로 불러옵니다.

(아래 코드를 복사하여 Colab의 코드 셀에 붙여넣고 실행하세요.)

#### [코드]
```
import networkx as nx
import matplotlib.pyplot as plt

# 시각화 실습을 위한 샘플 그래프 생성
G_sample = nx.Graph()
characters = ['Rachel', 'Ross', 'Monica', 'Chandler', 'Joey', 'Phoebe']
G_sample.add_nodes_from(characters)
edges = [
    ('Rachel', 'Ross'), ('Rachel', 'Monica'),
    ('Monica', 'Chandler'), ('Monica', 'Ross'),
    ('Chandler', 'Joey'),
    ('Joey', 'Phoebe'), ('Joey', 'Rachel'),
    ('Phoebe', 'Ross')
]
G_sample.add_edges_from(edges)

print("1단계: 샘플 네트워크 생성 완료")
```

#### [설명]
주인공 6명과 그들 사이의 임의의 관계를 가진 `G_sample` 그래프를 만들었습니다. 이제 이 그래프를 가지고 다양한 시각화 옵션을 시험해 보겠습니다.

---

#### [2단계: 기본 네트워크 그리기]

`nx.draw()` 함수에 그래프 객체와 함께, 가장 필수적인 `with_labels=True` 옵션을 추가하여 각 노드가 누구인지 표시해 보겠습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 기본적인 네트워크 시각화
plt.figure(figsize=(8, 8)) # 그림의 크기를 지정합니다. (가로 8인치, 세로 8인치)
nx.draw(G_sample, with_labels=True)
plt.show() # 최종적으로 그림을 화면에 보여줍니다.
```

#### [설명]
`nx.draw()` 함수를 실행하면, 노드와 엣지로 구성된 기본적인 네트워크 그림이 나타납니다. 하지만 아직은 미적으로 부족하고, 더 많은 정보를 담을 수 있을 것 같습니다. 이제 다양한 옵션을 추가하여 이 그림을 더 풍부하게 만들어 보겠습니다.

---

#### [3단계: 다양한 시각화 옵션 적용하기]

`nx.draw()` 함수는 다양한 옵션(파라미터)을 통해 노드, 엣지, 라벨 등의 스타일을 자유자재로 변경할 수 있게 해줍니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 다양한 옵션을 적용하여 네트워크 시각화
plt.figure(figsize=(10, 10))

# 노드 관련 옵션
node_options = {
    'node_color': 'skyblue',  # 노드 색상
    'node_size': 2500,        # 노드 크기
    'edgecolors': 'darkblue', # 노드 테두리 색상
    'linewidths': 2           # 노드 테두리 두께
}

# 엣지 관련 옵션
edge_options = {
    'width': 2,               # 엣지 두께
    'edge_color': 'gray',     # 엣지 색상
    'style': 'dashed'         # 엣지 스타일 ('solid', 'dashed', 'dotted')
}

# 라벨 관련 옵션
label_options = {
    'font_size': 12,          # 라벨 폰트 크기
    'font_color': 'black',    # 라벨 폰트 색상
    'font_family': 'sans-serif', # 폰트 종류
    'font_weight': 'bold'     # 폰트 굵기
}

nx.draw(G_sample, with_labels=True, **node_options, **edge_options, **label_options)
plt.show()
```

#### [설명]
위 코드처럼, 딕셔너리를 이용해 옵션을 체계적으로 관리하면 코드가 훨씬 깔끔해집니다. `**` 기호는 딕셔너리에 있는 모든 키-값 쌍을 함수의 파라미터로 풀어헤쳐 전달하는 파이썬 문법입니다. 이제 훨씬 더 보기 좋고 정돈된 네트워크 그림이 만들어졌습니다. 이 옵션들을 조합하여 연구의 목적과 디자인 취향에 맞는 다양한 시각화를 시도해볼 수 있습니다.

---

### 6.2.2. 다양한 레이아웃 알고리즘 비교 및 선택 기준

네트워크 시각화에서 **레이아웃 알고리즘(Layout Algorithm)**은 **'노드를 어디에 위치시킬 것인가'**를 결정하는 규칙입니다. 어떤 레이아웃을 선택하느냐에 따라 동일한 네트워크라도 전혀 다른 모습으로 보일 수 있으며, 이는 우리의 해석에 큰 영향을 미칩니다.

NetworkX는 다양한 레이아웃 알고리즘을 제공하며, 각 알고리즘은 특정한 목적에 더 적합합니다. `nx.draw()`는 기본적으로 `spring_layout`을 사용하지만, 우리는 다른 레이아웃을 명시적으로 지정할 수 있습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 다양한 레이아웃 비교 시각화
fig, axes = plt.subplots(2, 2, figsize=(12, 12)) # 2x2 격자 형태의 그림판 생성
fig.suptitle("Various Layouts Comparison", fontsize=16)

# 1. Spring Layout (기본값)
# 노드들은 서로 밀어내고, 엣지는 노드들을 당기는 물리 시뮬레이션 기반
pos_spring = nx.spring_layout(G_sample, seed=42) # seed 값을 고정하여 항상 같은 모양으로 그리게 함
nx.draw(G_sample, pos=pos_spring, with_labels=True, ax=axes[0, 0])
axes[0, 0].set_title("Spring Layout")

# 2. Circular Layout
# 모든 노드를 원형으로 배치
pos_circular = nx.circular_layout(G_sample)
nx.draw(G_sample, pos=pos_circular, with_labels=True, ax=axes[0, 1])
axes[0, 1].set_title("Circular Layout")

# 3. Kamada-Kawai Layout
# 엣지 가중치를 노드 간의 이상적인 거리로 간주하여 에너지 최소화
pos_kk = nx.kamada_kawai_layout(G_sample)
nx.draw(G_sample, pos=pos_kk, with_labels=True, ax=axes[1, 0])
axes[1, 0].set_title("Kamada-Kawai Layout")

# 4. Random Layout
# 노드를 무작위로 배치 (분석에는 거의 사용되지 않음)
pos_random = nx.random_layout(G_sample, seed=42)
nx.draw(G_sample, pos=pos_random, with_labels=True, ax=axes[1, 1])
axes[1, 1].set_title("Random Layout")

plt.show()
```

#### [결과 해석]

| 레이아웃 | 특징 | 장점 | 단점 |
| :--- | :--- | :--- | :--- |
| **Spring** | 물리 시뮬레이션 기반, 노드 간의 인력/척력 | 군집(Cluster) 구조를 직관적으로 파악하기 좋음 | 실행할 때마다 모양이 조금씩 바뀜, 큰 네트워크에서는 계산 시간이 오래 걸릴 수 있음 |
| **Circular** | 모든 노드를 원 위에 배치 | 전체적인 구조와 대칭성을 보기 좋음, 엣지 교차를 최소화 | 군집이나 중심-주변부 구조를 파악하기 어려움 |
| **Kamada-Kawai** | 에너지 최소화 모델 | 미학적으로 균형 잡힌 결과를 자주 보여줌, 구조적 특징을 잘 표현 | Spring과 마찬가지로 계산량이 많을 수 있음 |
| **Random** | 무작위 배치 | 빠름 | 분석적인 통찰을 얻기 거의 불가능함 |

어떤 레이아웃이 '정답'이라고는 할 수 없습니다. 연구자는 자신이 시각화를 통해 **무엇을 보여주고 싶은지**에 따라 가장 적합한 레이아웃을 '선택'해야 합니다. 군집을 강조하고 싶다면 `Spring`이나 `Kamada-Kawai`를, 전체적인 연결 패턴을 보여주고 싶다면 `Circular`를 사용하는 등, 레이아웃 선택은 시각화의 목적과 의도를 반영하는 중요한 과정입니다.

### 🤖 AI와 함께 탐색하기: 시각화 코드 요청하기

**학습 목표:** 자연어 설명을 통해, 자신이 원하는 형태의 시각화 결과물을 만들어내는 구체적인 코드를 AI에게 요청하고 생성하는 '입코딩' 실습을 진행합니다.

**간단 프롬프트:**
`NetworkX로 그래프 G를 그리는 파이썬 코드를 만들어줘. 노드 라벨도 보이게 해줘.`

**상세 프롬프트:**
`내가 만든 NetworkX 그래프 G가 있어. 이 그래프를 Matplotlib을 사용해서 시각화하는 코드를 생성해줘.`
`다음 구체적인 요구사항을 모두 반영해줘:`
`1. 레이아웃은 'kamada_kawai_layout'을 사용해.`
`2. 노드에는 라벨이 표시되어야 해.`
`3. 노드의 크기는 2000으로 설정해.`
`4. 노드의 색깔은 'lightgreen'으로 해줘.`
`5. 엣지의 색깔은 'gray'로 설정해.`
`6. 엣지의 너비는 2로 해줘.`
`7. 마지막에는 plt.show()를 꼭 포함해줘.`

**인문학적 프롬프트:**
`네트워크 시각화에서 '레이아웃 알고리즘'(노드의 위치를 결정하는 규칙)의 선택은 매우 중요해. 우리가 사용한 'spring' 레이아웃은 중심적인 노드를 가운데로 모으는 경향이 있어. 만약 'circular' 레이아웃처럼 모든 노드를 원형으로 배치한다면, 동일한 네트워크 데이터라도 전혀 다르게 보일 거야. 이처럼 레이아웃의 선택이 우리의 '해석'에 어떤 영향을 미칠 수 있을까? 연구자가 의도적으로 또는 비의도적으로 레이아웃을 선택함으로써 어떻게 특정 주장을 강화하거나 약화시킬 수 있는지, 시각화의 '수사학적' 측면에 대해 논해줘.`