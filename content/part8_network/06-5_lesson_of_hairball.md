---
title: 전체 관계망 시각화 - '털 뭉치'의 교훈
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

## 6.5. 전체 관계망 시각화: '털 뭉치'의 교훈

지금까지 우리는 9명의 핵심 인물 네트워크를 통해, 분석 결과를 시각적 요소에 담아내는 구체적인 방법을 배웠습니다. 하지만 우리의 마음 한편에는 이런 질문이 남아있습니다: "그래서, 417명 전체가 포함된 '프렌즈' 세계의 진짜 지도는 어떻게 생겼을까?"

이번 섹션에서는 이 질문에 답하기 위해, 과감하게 전체 네트워크를 시각화하는 시도를 해보겠습니다. 이 과정은 우리에게 두 가지 중요한 교훈을 줄 것입니다. 첫째, 왜 대규모 네트워크의 시각화가 어려운지를 몸소 체험하게 될 것이고, 둘째, 그 '알아볼 수 없음' 자체가 우리에게 무엇을 말해주는지 해석하는 법을 배우게 될 것입니다.

---

### 1단계: 전체 네트워크 시각화를 위한 최종 코드

전체 417명의 네트워크를 그리는 코드는 6.4절에서 사용한 것과 기본적으로 동일합니다. 다만, 너무 많은 노드와 엣지를 효과적으로 표현하기 위해 몇 가지 전략적인 수정이 필요합니다.

- **라벨 생략:** 417개의 이름을 모두 표시하는 것은 물리적으로 불가능하므로, 라벨은 과감히 생략하고 전체적인 구조에 집중합니다.
- **엣지 투명도 조절:** 수천 개의 엣지가 겹치면 화면이 검게 변하므로, 투명도(`alpha`)를 매우 낮게 설정하여 엣지가 많이 겹치는 부분이 더 진하게 보이는 효과를 줍니다.
- **노드 크기 조정:** 발화량이 1인 단역들도 최소한의 점으로 표시될 수 있도록 기본 크기를 더해줍니다.

(아래 코드는 이전 단계의 어떤 변수도 필요 없이, 그 자체로 완벽하게 실행됩니다. Colab의 코드 셀에 붙여넣고 실행하세요.)

#### [코드]
```
# --- 1. 초기 설정 및 라이브러리 불러오기 ---
import xml.etree.ElementTree as ET
from collections import Counter
import itertools
import networkx as nx
import matplotlib.pyplot as plt

# --- 2. 데이터 편찬 (4.1절 과정 요약) ---
# 설정값 정의
XML_FILE = 'Friends_Korean_TEI.xml'
TEI_NAMESPACE = '{http://www.tei-c.org/ns/1.0}'
UNWANTED_NAMES_EXPANDED = ['All', 'Scene', 'Note', 'Stage Direction', 'Voice', 'Man', 'Woman', 'Both', 'Crowd', 'Guy', '모두', '여자', '남자', '웨이터', '학생', '간호사', '선생님', '직원', '점원', '소방관', '배달원', '승무원', '손님', '아이', '감독', '둘', '다들', '여자들', '남자들', '친구들', '아이들', '웨이터들']

# 파일 파싱 및 노드 목록 생성
tree = ET.parse(XML_FILE)
root = tree.getroot()
all_speakers_normalized = []
for speaker_tag in root.findall(f'.//{TEI_NAMESPACE}speaker'):
    if speaker_tag.text:
        speaker_text = speaker_tag.text.strip()
        separators = [',', '그리고', '과', '와', '&', 'And']
        for sep in separators:
            speaker_text = speaker_text.replace(sep, ',')
        names_raw = speaker_text.split(',')
        for name_raw in names_raw:
            name = name_raw.strip().title()
            all_speakers_normalized.append(name)

final_cleaned_speakers = [name for name in all_speakers_normalized if name and name not in UNWANTED_NAMES_EXPANDED and name[0].isalpha() and not any(char.isdigit() for char in name) and '(' not in name and ')' not in name]
speaker_counts = Counter(final_cleaned_speakers)
unique_characters_all = sorted(list(speaker_counts))

# 엣지 목록 생성
directed_edge_pairs = []
for scene in root.findall(f'.//{TEI_NAMESPACE}div[@type="scene"]'):
    speakers_in_scene = {s.text.strip().title() for s in scene.findall(f'.//{TEI_NAMESPACE}speaker') if s.text}
    characters_in_scene_final = [name for name in speakers_in_scene if name in unique_characters_all]
    if len(characters_in_scene_final) >= 2:
        for sp_tag in scene.findall(f'.//{TEI_NAMESPACE}sp'):
            speaker_tag = sp_tag.find(f'{TEI_NAMESPACE}speaker')
            if speaker_tag is not None and speaker_tag.text:
                speaker = speaker_tag.text.strip().title()
                if speaker in characters_in_scene_final:
                    targets = [target for target in characters_in_scene_final if target != speaker]
                    for target in targets:
                        directed_edge_pairs.append((speaker, target))
weighted_directed_edges = Counter(directed_edge_pairs)

# --- 3. 그래프 객체 및 시각화 데이터 생성 ---
# 전체 인물 그래프 생성
G_directed = nx.DiGraph()
node_list = [(char, {'speech_count': speaker_counts.get(char, 0)}) for char in unique_characters_all]
G_directed.add_nodes_from(node_list)
edge_list = [(u, v, {'weight': w}) for (u,v), w in weighted_directed_edges.items()]
G_directed.add_edges_from(edge_list)

# 분석 값 계산
total_strength = dict(G_directed.degree(weight='weight'))
eigenvector_centrality = nx.eigenvector_centrality(G_directed, weight='weight', max_iter=1000)

# 시각적 요소 리스트 생성
node_sizes = [total_strength.get(node, 0) / 20 + 10 for node in G_directed.nodes()]
node_colors = [eigenvector_centrality.get(node, 0) for node in G_directed.nodes()]
edge_alpha = 0.05

print("데이터 준비 및 시각화 요소 생성 완료")

# --- 4. 전체 네트워크 시각화 ---
plt.figure(figsize=(20, 20)) # 그림 크기를 매우 크게 설정
# 전체 네트워크는 spring_layout이 계산에 매우 오래 걸릴 수 있습니다.
# 여기서는 학습을 위해 그대로 진행합니다. (컴퓨터 사양에 따라 수 분 소요될 수 있음)
print("레이아웃 계산 중... (시간이 다소 소요될 수 있습니다)")
pos = nx.spring_layout(G_directed, iterations=50, seed=42)
print("레이아웃 계산 완료. 그림을 생성합니다.")

# 노드 그리기
nx.draw_networkx_nodes(G_directed, pos, 
                       node_size=node_sizes,
                       node_color=node_colors,
                       cmap=plt.cm.YlOrRd,
                       alpha=0.8)

# 엣지 그리기
nx.draw_networkx_edges(G_directed, pos, 
                       width=0.5,
                       edge_color='gray',
                       alpha=edge_alpha)

plt.title("Full 'Friends' Network Visualization (417 Nodes, 2962 Edges)", fontsize=20)
plt.axis('off') # 축을 없애서 더 깔끔하게 보입니다.
plt.show()
```


---

### 2단계: '털 뭉치(Hairball)' 현상과 그 의미 해석하기

코드를 실행하면, 우리는 매우 복잡하고 혼란스러운 그림과 마주하게 됩니다. 중앙에는 무엇인지 알아볼 수 없는 빽빽한 점과 선의 뭉치가 있고, 그 주변으로 수많은 작은 점들이 희미한 선들로 연결된 모습일 것입니다. 네트워크 시각화 분야에서는 이러한 현상을 '**털 뭉치(Hairball)**'라고 부릅니다.

이 '털 뭉치'는 시각화의 실패가 아닙니다. 오히려 이것이야말로 **가장 정직하고 중요한 분석 결과**입니다.

- **구조의 시각적 증명:** 왜 그림이 이렇게 보일까요? 이는 4장에서 숫자로 확인했던 '**핵심-주변부 구조**'가 시각적으로 그대로 드러난 것입니다. 주인공 6명과 소수의 주요 조연으로 이루어진 '핵심 그룹'은 서로 너무나도 빽빽하게 연결되어 있어, 하나의 거대한 '점'처럼 뭉개져 보이는 것입니다. 그리고 수백 명의 '주변부' 인물들은 이 핵심 그룹에만 희미하게 연결되어, 마치 행성을 도는 위성들처럼 그 주변을 맴돌고 있습니다.

- **'알아볼 수 없음'의 의미:** 핵심 그룹 내부를 알아볼 수 없다는 사실 자체가, 그들의 관계가 얼마나 폐쇄적이고 강렬한지를 역설적으로 보여줍니다. 그들은 외부와는 질적으로 다른, 그들만의 세상을 형성하고 있는 것입니다. 이처럼, 때로는 시각화의 '가독성 부족'이 데이터의 중요한 특성을 폭로하는 단서가 되기도 합니다.

결론적으로, 전체 네트워크 시각화는 우리에게 세부적인 관계를 보여주지는 못하지만, '프렌즈' 세계의 거시적인 권력 구조와 불균형을 그 어떤 통계표보다도 강력하고 직관적으로 전달합니다.

---

### 3단계: 복잡성을 다루는 다음 단계로

그렇다면 이렇게 복잡한 네트워크는 어떻게 더 깊이 탐색할 수 있을까요? 이 '털 뭉치'를 푸는 것은 정적인 그림만으로는 불가능합니다. 이를 위해서는 더 진보된 시각화 전략이 필요하며, 이러한 내용들은 이 교재의 후반부 심화 과정에서 자세히 다루게 될 것입니다.

- **필터링(Filtering):** 특정 조건(예: 가중치가 100 이상인 관계만)을 만족하는 노드나 엣지만 선택하여 시각화함으로써, 복잡성을 줄이고 핵심적인 구조만 볼 수 있습니다.
- **인터랙티브 시각화(Interactive Visualization):** `pyvis`나 `Gephi`와 같은 도구를 사용하면, 네트워크를 확대/축소하고, 노드를 클릭하여 정보를 확인하며, 실시간으로 필터링하는 등 동적인 탐색이 가능해집니다. (**제13장 고급 시각화 기법**에서 다룹니다.)

따라서 이번 장에서는, 전체 네트워크의 모습을 통해 '핵심-주변부' 구조를 확인하는 것만으로도 큰 수확이라 할 수 있습니다. 이 시각화는 왜 우리가 이전 절에서 '핵심 그룹'에 집중하여 분석했는지, 그 이유를 명확하게 보여주는 근거가 됩니다.

### 🤖 AI와 함께 탐색하기: 복잡한 세상 그리기

**학습 목표:** 대규모 네트워크 시각화의 한계인 '털 뭉치' 현상을 이해하고, 이를 극복하기 위한 다양한 전략적 사고를 탐색합니다.

**간단 프롬프트:**
`우리나라 모든 사람들의 친구 관계를 시각화하면 왜 알아볼 수 없을까?`

**상세 프롬프트:**
`전 세계 모든 도시와 그 도시들을 잇는 항공 노선을 하나의 네트워크로 시각화한다고 상상해보자.`
`1. 이 네트워크를 아무 처리 없이 그리면 왜 '털 뭉치'처럼 보일까?`
`2. 이 지도를 더 유용하게 만들기 위해 어떤 정보들을 시각적으로 표현할 수 있을까? (예: 대륙별로 노드 색깔을 다르게 하기, 이용객 수에 따라 공항 크기를 다르게 하기 등)`
`3. 특정 지역(예: 동아시아)만 확대해서 보는 것은 어떤 종류의 분석에 도움이 될까?`

**인문학적 프롬프트:**
`16세기에 제작된 고지도는 당시 사람들이 알고 있던 유럽, 아프리카, 아시아는 비교적 상세하지만, 아직 발견되지 않은 아메리카나 오세아니아 대륙은 그려져 있지 않거나 '미지의 땅(Terra Incognita)'으로 표시되어 있어. 이는 당시 사람들이 가진 세계관의 한계를 보여주는 동시에, 그들이 무엇을 '중요하게' 여겼는지를 보여주는 시각 자료야. 우리가 '프렌즈'의 전체 네트워크를 보고 '털 뭉치'가 된 핵심 그룹에 집중하기로 결정하는 것이, 옛 지도 제작자들이 미지의 세계를 생략하고 자신들의 세계를 중심에 놓았던 것과 어떤 점에서 비슷하고 다를까? 데이터 시각화에서 '무엇을 보여주지 않을 것인가'를 결정하는 것이 '무엇을 보여줄 것인가'만큼 중요한 이유에 대해 논해줘.`