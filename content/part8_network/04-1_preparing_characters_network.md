---
title: 데이터 편찬 - 전체 인물 관계망을 위한 재료 준비
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

## 4.1. 데이터 편찬: 전체 인물 관계망을 위한 재료 준비

지난 3장까지의 여정은 '건축'에 비유하자면, 부지를 선정하고(1장. 이론), 공구를 점검하고(2장. 도구), 설계도를 완성하는(3장. 편찬 계획) 과정이었습니다. 이제 우리는 드디어 첫 삽을 뜰 준비를 마쳤습니다. 이번 4장에서는 그 설계도를 바탕으로, `Friends.xml`이라는 원재료를 사용하여 실제 '프렌즈' 관계망이라는 건축물을 한 층 한 층 쌓아 올리는 구체적인 실습을 진행합니다.

이번 섹션의 목표는 3장에서 확정한 최종 전략, 즉 **'발화자-장면참여자' 방향성 모델**을 기반으로 **전체 등장인물**의 관계 데이터를 추출하는 것입니다. 이 과정을 통해 우리는 `Friends.xml` 파일로부터 네트워크 분석에 필요한 두 가지 핵심 재료, **노드 리스트(Node List)**와 **엣지 리스트(Edge List)**를 생성하게 될 것입니다.

또한, 전체 네트워크 분석과 더불어 '핵심 그룹'의 특징을 별도로 살펴볼 경우를 대비하여, 이 단계에서 발화 횟수가 100회 이상인 **'주요 인물'** 목록도 함께 추출해 두겠습니다.

---

### 1단계: 초기 설정

모든 코딩 작업의 첫걸음은 필요한 도구(라이브러리)를 불러오고, 앞으로 사용할 설정값들을 미리 변수로 지정해두는 것입니다.

(아래 코드를 복사하여 Colab의 코드 셀에 붙여넣고 실행하세요. `Friends_Korean_TEI.xml` 파일이 Colab에 업로드되어 있어야 합니다.)

#### [코드]
```
# 필요한 라이브러리들을 작업 공간으로 불러옵니다.
import xml.etree.ElementTree as ET # XML 파일을 다루기 위한 라이브러리
from collections import Counter      # 리스트의 요소 개수를 쉽게 세기 위한 라이브러리
import itertools                   # 조합(combination)을 쉽게 만들기 위한 라이브러리

# 분석에 사용할 파일 이름과 각종 설정값들을 미리 변수로 정의합니다.
XML_FILE = 'Friends_Korean_TEI.xml'
TEI_NAMESPACE = '{http://www.tei-c.org/ns/1.0}' # TEI XML의 네임스페이스 주소
# 3장에서의 논의를 통해 확정된, 분석에서 제외할 이름 목록입니다.
UNWANTED_NAMES_EXPANDED = ['All', 'Scene', 'Note', 'Stage Direction', 'Voice', 'Man', 'Woman', 'Both', 'Crowd', 'Guy', '모두', '여자', '남자', '웨이터', '학생', '간호사', '선생님', '직원', '점원', '소방관', '배달원', '승무원', '손님', '아이', '감독', '둘', '다들', '여자들', '남자들', '친구들', '아이들', '웨이터들']

print("1단계: 초기 설정 완료")
```

#### [설명]
XML 파일을 다루기 위한 `ElementTree`, 빈도를 세기 위한 `Counter`, 조합을 만들기 위한 `itertools`를 불러왔습니다. 또한, 3장에서 우리가 데이터를 탐색하며 발견했던 여러 노이즈들을 한 번에 제거하기 위해, 제외할 이름들을 `UNWANTED_NAMES_EXPANDED` 라는 리스트에 미리 정의해 두었습니다.

---

### 2단계: 전체 등장인물(노드) 목록 생성

이제 `Friends.xml` 파일을 읽어, 3장에서 수립한 최종 정제 규칙을 적용하여 깨끗한 전체 등장인물 목록을 생성하겠습니다. 이 목록이 우리 네트워크의 전체 노드가 됩니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# XML 파일을 읽어와 파싱합니다.
tree = ET.parse(XML_FILE)
root = tree.getroot()

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
unique_characters_all = sorted(list(speaker_counts))

# [추가] 차후 분석을 위해, 100회 이상 발화한 '주요 인물' 목록도 별도로 추출합니다.
main_characters_100 = [name for name, count in speaker_counts.items() if count >= 100]

print("2단계: 전체 등장인물(노드) 목록 생성 완료")
print(f"  - 전체 고유 등장인물 수: {len(unique_characters_all)}명")
print(f"  - 발화 100회 이상 주요 인물 수: {len(main_characters_100)}명")
print(f"  - 주요 인물 목록: {main_characters_100}")
```

#### [실행 결과]
2단계: 전체 등장인물(노드) 목록 생성 완료
  - 전체 고유 등장인물 수: 417명
  - 발화 100회 이상 주요 인물 수: 9명
  - 주요 인물 목록: ['Monica', 'Chandler', 'Ross', 'Rachel', 'Phoebe', 'Joey', 'Janice', 'Mike', 'Frank']

#### [결과 해석]
최종 정제 규칙을 적용한 결과, '프렌즈' 세계에는 총 **417명**의 고유한 인물이 등장했음을 확인할 수 있습니다. 이 417명의 전체 인물 목록(`unique_characters_all`)이 우리 네트워크의 기본 노드가 될 것입니다. 동시에, 우리는 발화 횟수가 100회 이상인 **9명**의 **주요 인물** 목록(`main_characters_100`)도 별도로 추출해 두었습니다. 이 목록은 나중에 핵심 그룹의 특징을 집중적으로 분석하거나, 전체 네트워크에서 이들을 시각적으로 강조하는 데 유용하게 사용될 것입니다.

---

### 3단계: 방향성 엣지 및 가중치 정보 추출

이제 우리의 핵심 전략인 **'발화자-장면참여자' 모델**을 적용하여, 417명의 인물들 사이에 어떤 방향성 관계(엣지)가 얼마나 많이(가중치) 생성되는지 추출하겠습니다.

(앞선 코드에 이어서, 아래 코드를 다음 셀에 복사하여 실행하세요.)

#### [코드]
```
# 방향성 엣지 쌍을 모두 저장할 빈 리스트를 생성합니다.
directed_edge_pairs = []
# 모든 scene 태그를 순회합니다.
for scene in root.findall(f'.//{TEI_NAMESPACE}div[@type="scene"]'):
    # 해당 장면에 등장한 모든 화자의 이름 집합(set)을 구합니다.
    speakers_in_scene = {s.text.strip().title() for s in scene.findall(f'.//{TEI_NAMESPACE}speaker') if s.text}
    # 이 장면의 등장인물 중, 우리의 최종 노드 목록(unique_characters_all)에 있는 인물만 필터링합니다.
    characters_in_scene_final = [name for name in speakers_in_scene if name in unique_characters_all]
    
    # 장면에 인물이 2명 이상 있을 경우에만 엣지를 생성합니다.
    if len(characters_in_scene_final) >= 2:
        # 이 장면의 모든 발화(<sp> 태그)를 하나씩 확인합니다.
        for sp_tag in scene.findall(f'.//{TEI_NAMESPACE}sp'):
            speaker_tag = sp_tag.find(f'{TEI_NAMESPACE}speaker')
            if speaker_tag is not None and speaker_tag.text:
                # 발화자 이름 역시 최종 정제된 목록에 있는지 확인합니다.
                speaker = speaker_tag.text.strip().title()
                if speaker in characters_in_scene_final:
                    # 발화자를 제외한 나머지 참여자(타겟) 목록을 생성합니다.
                    targets = [target for target in characters_in_scene_final if target != speaker]
                    # 발화자 -> 타겟으로의 엣지를 추가합니다.
                    for target in targets:
                        directed_edge_pairs.append((speaker, target))

# 엣지별 빈도를 계산하여 가중치로 사용합니다.
weighted_directed_edges = Counter(directed_edge_pairs)

print("3단계: 방향성 엣지 및 가중치 정보 추출 완료")
print(f"  - 생성된 총 방향성 상호작용 수 (중복 포함): {len(directed_edge_pairs)}")
print(f"  - 생성된 고유 방향성 엣지 수: {len(weighted_directed_edges)}")
print("\n가장 가중치가 높은 상위 10개 관계 (Source -> Target):")
for edge, weight in weighted_directed_edges.most_common(10):
    print(f"    {edge[0]} -> {edge[1]}: {weight}회")
```

#### [실행 결과]
3단계: 방향성 엣지 및 가중치 정보 추출 완료
  - 생성된 총 방향성 상호작용 수 (중복 포함): 92093
  - 생성된 고유 방향성 엣지 수: 2962

가장 가중치가 높은 상위 10개 관계 (Source -> Target):
    Monica -> Chandler: 2928회
    Ross -> Rachel: 2804회
    Chandler -> Monica: 2767회
    Rachel -> Ross: 2678회
    Chandler -> Joey: 2554회
    Monica -> Phoebe: 2517회
    Joey -> Chandler: 2452회
    Rachel -> Phoebe: 2396회
    Rachel -> Monica: 2382회
    Monica -> Rachel: 2379회

#### [결과 해석]
'발화자-장면참여자' 모델을 전체 인물에 적용한 결과, 총 **92,093**번의 방향성 상호작용이 발생했으며, 이를 통해 **2,962개**의 고유한 방향성 관계(엣지)가 생성되었음을 확인했습니다.

가장 가중치가 높은 상위 10개 관계를 보면, 주인공 6명 사이의 상호작용이 압도적으로 높게 나타납니다. 특히 `Monica → Chandler` (2928회) 와 `Chandler → Monica` (2767회), 그리고 `Ross → Rachel` (2804회) 와 `Rachel → Ross` (2678회) 등 핵심 커플 사이의 상호작용이 매우 빈번하고, 그 수치 또한 **비대칭적**임을 알 수 있습니다. 예를 들어, 모니카가 챈들러가 있는 곳에서 발화한 횟수가 챈들러가 모니카가 있는 곳에서 발화한 횟수보다 약 160회 더 많습니다. 이는 관계의 방향성을 고려한 우리 모델이 인물 간의 미묘한 역할 차이를 잘 포착하고 있음을 보여줍니다.

이것으로 우리는 417개의 노드와 2,962개의 엣지, 그리고 각 엣지의 가중치와 방향성이라는, '프렌즈' 전체 세계를 담은 네트워크의 핵심 재료 준비를 모두 마쳤습니다.

### 🤖 AI와 함께 탐색하기: 데이터 편찬의 핵심 논리

**학습 목표:** 데이터 편찬 과정에서 노드와 엣지를 정의하는 핵심 로직을 이해하고, 이를 AI에게 명확한 언어로 요청하는 연습을 합니다.

**간단 프롬프트:**
`장면에 [A, B, C]가 있고, A가 발화했을 때, '발화자-장면참여자' 모델에 따라 어떤 엣지들이 생성되는지 알려줘.`

**상세 프롬프트:**
`내가 만든 파이썬 리스트가 있어: `
`all_characters = ['철수', '영희', '민수', '선생님']`
`interactions = [ ('철수', ['영희', '민수']), ('영희', ['철수', '민수']), ('선생님', ['철수', '영희', '민수']) ]`
`위 interactions 리스트는 '발화자'와 '그 발화를 들은 사람들'의 목록이야.`
`이 데이터를 바탕으로, ('발화자', '청자') 형태의 방향성 엣지 쌍을 모두 추출하는 파이썬 코드를 생성해줘.`

**인문학적 프롬프트:**
`우리의 '발화자-장면참여자' 모델은 한 사람의 발언이 그 장면에 있는 모든 사람에게 동일한 영향을 미친다고 가정해. 하지만 현실에서는 특정인을 겨냥한 귓속말도 있고, 모두를 향한 외침도 있으며, 특정 발언에 아무도 관심을 기울이지 않는 경우도 있어. 우리 모델이 포착하지 못하는 이러한 '상호작용의 다양한 결'은 무엇이며, 이러한 모델의 한계를 인지하는 것이 왜 인문학적 분석에서 중요한지에 대해 논해줘.`