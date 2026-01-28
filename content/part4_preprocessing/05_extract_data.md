---
title: 구조적 데이터 추출
---

<!-- colab-button:start -->
<div class="colab-button">
  <a
    href="https://colab.research.google.com/github/digitalhumanitiestextbook/dh-textbook/blob/main/notebooks/part4_regex/03_regex_advanced.ipynb"
    target="_blank"
    rel="noopener"
  >
    Colab에서 실행하기
  </a>
</div>
<!-- colab-button:end -->

## 구조적 데이터 추출

> 💡 **인문학적 질문**
>
> "우리가 추출한 데이터에 빠진 정보는 없을까요? 대사를 둘러싼 맥락(에피소드, 장면)과 대사 속에 숨겨진 지문 정보는 어떻게 추출할 수 있을까요? 여러 명이 동시에 말하는 대사는 어떻게 처리해야 할까요?"

앞서 우리는 `pd.read_xml`이라는 편리한 도구를 사용했습니다. 하지만 그 결과, 우리는 대사를 둘러싼 중요한 맥락 정보인 "에피소드"와 "장면" 번호를 잃어버렸습니다. 또한, 아래 예시처럼 여러 명이 동시에 말하거나(`Monica, Joey, Phoebe`), 대사 안에 지문(`[...]`)이 포함된 경우를 정교하게 처리하지 못했습니다.

```xml
<sp who="#Monica, Joey, Phoebe">
  <speaker>Monica, Joey, Phoebe</speaker>
  <p>[노래하며] 세상의 꼭대기에서 창조물을 내려다보며...</p>
</sp>

<sp who="#Rachel">
  <speaker>Rachel</speaker>
  <p>저기 작은 고양이 좀 봐! [작은 새끼 고양이가 Ross 뒤 지붕에 있음] 귀엽다!</p>
</sp>
```

이런 문제들을 모두 해결하고 우리가 원하는 모든 정보를 담은 "완벽한" 데이터프레임을 만들기 위해, 이번에는 `ElementTree`와 "**정규 표현식(Regular Expression)**"이라는 기술을 조합하여 XML 파일을 정교하게 해부해 보겠습니다.

### 5.1. 구조와 맥락을 담아 데이터 추출하기

XML 파일에서 에피소드, 장면, 화자, 대사, 지문을 모두 추출하고, 여러 명의 화자와 대사 속 괄호 지문도 분리해 봅시다.

구체적으로, 파이썬의 `ElementTree`와 `re` 라이브러리를 사용해서 "Friends_Korean_TEI.xml" 파일을 파싱해 보겠습니다. 이를 위해 먼저, 에피소드와 장면을 순회하며 번호를 가져오고, 각 대사(sp 태그)에서는 화자, 대사, 지문을 추출합니다. 이후 화자가 "Monica, Joey, Phoebe"처럼 여러 명일 경우 각 화자를 별도의 행으로 분리하고, 대사 안에 `[... ]` 형식의 지문이 있다면 그 내용만 "inline_stage"라는 새 열로 분리해 보겠습니다.

```python
import xml.etree.ElementTree as ET
import pandas as pd
import re # 정규 표현식(Regular Expression) 라이브러리를 불러옵니다.

# 1. 파일 경로 및 네임스페이스 정의
file_path = 'Friends_Korean_TEI.xml'
# 네임스페이스 URL을 순수 문자열로 정확하게 지정합니다.
namespaces = {'tei': 'http://www.tei-c.org/ns/1.0'}

# 2. XML 파일 파싱
tree = ET.parse(file_path)
root = tree.getroot()

# 3. 모든 데이터를 담을 빈 리스트 준비
all_data = []

# 4. 구조적 데이터 추출 시작
# 에피소드(div)별로 반복
for episode in root.findall('.//tei:div[@type="episode"]', namespaces):
    episode_num = episode.get('n')
    
    # 장면(div)별로 반복
    for scene in episode.findall('.//tei:div[@type="scene"]', namespaces):
        scene_num = scene.get('n')
        
        # 발화(sp)별로 반복
        for sp in scene.findall('.//tei:sp', namespaces):
            # speaker 정보 추출
            speaker_tag = sp.find('tei:speaker', namespaces)
            speaker_text = speaker_tag.text if speaker_tag is not None else ""
            
            # line 정보 추출
            line_tag = sp.find('tei:p', namespaces)
            line_text = line_tag.text if line_tag is not None else ""
            
            # stage 정보 추출
            stage_tag = sp.find('tei:stage', namespaces)
            stage_text = stage_tag.text if stage_tag is not None else None
            
            # 대사 속 괄호 지문('[...]') 추출 및 분리
            inline_stage_text = ""
            if line_text:
                match = re.search(r'\[(.*?)\]', line_text)
                if match:
                    inline_stage_text = match.group(1).strip()
                    line_text = re.sub(r'\[(.*?)\]', '', line_text).strip()

            # 여러 명의 화자를 개별 행으로 분리
            speaker_list = [name.strip() for name in speaker_text.split(',') if name.strip()]
            if not speaker_list: # 화자 정보가 아예 없는 경우
                speaker_list = [None]

            for individual_speaker in speaker_list:
                data_dict = {
                    'episode': episode_num,
                    'scene': scene_num,
                    'speaker': individual_speaker,
                    'line': line_text,
                    'stage': stage_text,
                    'inline_stage': inline_stage_text
                }
                all_data.append(data_dict)

# 5. 리스트를 판다스 데이터프레임으로 변환
df = pd.DataFrame(all_data)

# 6. 결과 확인
print(df.head(10))
```

**결과 확인:**
```
   episode scene   speaker                                               line     stage inline_stage
0        1     1    Monica  내 생각에 저 남자가 저 여자한테 큰 파이프 오르간을 사줬는데, 여자가 그걸 별로 ...      None           
1        1     1  Chandler                         참치 샐러드 할래? 계란 샐러드 할래? 결정해!   등장인물들처럼           
2        1     1      Ross                            난 Christine이 시키는 걸로 할게.   낮은 목소리로           
3        1     1    Rachel  아빠, 나 그냥... 그 사람과 결혼 못 하겠어! 미안해. 그 사람을 사랑하지 않아...   전화 통화 중           
4        1     1    Phoebe                             내가 머리를 놓으면 머리가 떨어질 거야.      None           
5        1     1  Chandler                                오, 저 바지를 입으면 안 되는데.     TV 보며           
6        1     1      Joey                                  난 계단에서 밀어버리라고 할래.      None           
7        1     1    Phoebe                         계단에서 밀어! 계단에서 밀어! 계단에서 밀어!      None           
8        1     1      Ross                         계단에서 밀어! 계단에서 밀어! 계단에서 밀어!      None           
9        1     1  Chandler                         계단에서 밀어! 계단에서 밀어! 계단에서 밀어!      None           
```

* `import re`: 텍스트에서 특정 패턴(규칙)을 찾거나 변경할 때 사용하는 강력한 도구인 "정규 표현식" 라이브러리를 불러옵니다.
* `for episode in ... for scene in ... for sp in ...`: 3중 반복문을 통해 XML의 계층 구조(에피소드 > 장면 > 대사)를 그대로 따라가며 데이터를 추출합니다. 이 덕분에 각 대사가 어떤 에피소드와 장면에 속하는지 맥락 정보를 놓치지 않을 수 있습니다.
* `re.search(r'\[(.*?)\]', line_text)`: `re.search()` 함수는 `line_text`에서 `[...]` 패턴을 찾습니다. `r'\[(.*?)\]'`는 "대괄호(`[`, `]`)로 시작하고 끝나며, 그 안에는 어떤 문자(`.*`)가 와도 좋다"는 규칙을 의미합니다.
* `for individual_speaker in speaker_list: ...`: 이 부분이 바로 여러 명의 화자를 처리하는 핵심 로직입니다. `speaker_text.split(',')`으로 쉼표를 기준으로 화자 이름을 분리하고, `for` 반복문을 통해 각 화자에 대한 데이터를 개별적인 행으로 만들어 `all_data` 리스트에 추가합니다. 이 덕분에 "Monica, Joey, Phoebe"는 이제 세 개의 독립된 행으로 저장되어, 각 인물의 대사량을 정확하게 분석할 수 있게 됩니다.
* `pd.DataFrame(all_data)`: 모든 정보가 차곡차곡 쌓인 리스트를 마침내 우리가 원하는 최종 데이터프레임으로 변환합니다.

이제 `df.head()`를 출력해보면, `episode`, `scene` 정보가 추가되고, `line`에서 분리된 `inline_stage` 정보까지 완벽하게 담긴, 훨씬 더 풍부하고 구조적인 데이터프레임을 만날 수 있습니다.
