---
title: 라이브러리 설치
---

<!-- colab-button:start -->
<div class="colab-button">
  <a
    href="https://colab.research.google.com/github/digitalhumanitiestextbook/dh-textbook/blob/main/notebooks/part2_computing/03_network_web_history.ipynb"
    target="_blank"
    rel="noopener"
  >
    Colab에서 실행하기
  </a>
</div>
<!-- colab-button:end -->

## 라이브러리 설치

파이썬에는 `math`, `random`처럼 기본적으로 포함되어 바로 `import`해서 쓸 수 있는 "**내장 라이브러리(Built-in Library)**"도 있지만, 훨씬 더 많은 종류의 강력한 기능들을 담은 "**외부 라이브러리(External Library)**"들이 존재합니다. 

특히 인문학 연구, 그중에서도 텍스트 데이터를 다룰 때는 자연어 처리(Natural Language Processing, NLP) 라이브러리가 매우 중요합니다. 대표적으로 영어 텍스트 분석에 널리 쓰이는 `nltk`와 한국어 분석에 유용한 `konlpy`가 있습니다.

이러한 외부 라이브러리는 파이썬을 처음 설치할 때 함께 설치되지 않는 경우가 많습니다. 이는 컴퓨터를 샀을 때 기본 프로그램 이외의 잡다한 프로그램이 설치되어 있지 않은 것과 유사합니다. 사용자가 실제로 사용할지, 사용하지 않을지 알 수 없기에 굳이 미리 설치해 둘 필요가 없는 것입니다.

Colab 환경의 경우, 자주 사용되는 외부 라이브러리들이 상당수 미리 설치되어 있지만, 우리가 사용하려는 라이브러리가 없거나 특정 버전이 필요할 때는 직접 설치해야 합니다. 이는 필요한 소프트웨어를 따로 설치하는 것과 비슷합니다.

## 라이브러리 설치하기 (pip)

파이썬에서는 **pip**라는 패키지 관리 도구를 사용하여 외부 라이브러리를 쉽게 설치하고 관리할 수 있습니다. 

Colab의 코드 셀에서 `pip` 명령어를 사용하려면 명령어 앞에 느낌표(`!`)를 붙여 주어야 합니다. 이는 해당 명령어가 파이썬 코드가 아니라, Colab의 운영체제인 리눅스(Linux) 환경에서 실행되는 명령어임을 알려 주는 표시입니다.

다음은 pip 명령어를 사용한 라이브러리 설치 및 업그레이드 방법의 예시입니다.

* **라이브러리 설치:** `!pip install 라이브러리이름`
* **특정 버전 설치:** `!pip install 라이브러리이름==버전번호`
* **라이브러리 업그레이드:** `!pip install --upgrade 라이브러리이름`

## 영어 자연어 처리 맛보기 (`nltk`)

먼저 영어 텍스트 분석에 널리 사용되는 `nltk` 라이브러리를 설치하고, 문장을 단어 단위로 나누는 "**토큰화(Tokenization)**"를 체험해 봅시다.

다음의 과정에 따라, 영어 텍스트 분석을 위한 `nltk` 라이브러리를 설치하고 사용해 보겠습니다.

1. Colab 코드 셀에서 `pip` 명령어를 사용하여 `nltk` 라이브러리를 설치합니다.
2. `nltk` 라이브러리를 `import`하고, 문장 토큰화 등에 필요한 "`punkt`" 데이터 패키지를 `nltk.download()` 함수로 다운로드합니다.
3. `nltk.tokenize` 모듈에서 `word_tokenize` 함수를 불러온 후, 영어 문장 `"Friends is a popular sitcom."`을 단어 단위로 토큰화하고 그 결과를 출력하는 코드를 작성하고 실행시킵니다.

```
# 1. nltk 라이브러리를 설치합니다.
!pip install nltk

# 2. nltk 라이브러리를 불러오고 필요한 데이터를 다운로드합니다.
import nltk
nltk.download("punkt")

# 3. nltk의 단어 토큰화 기능을 불러와 사용합니다.
from nltk.tokenize import word_tokenize

# 영어 문장 정의
english_sentence = "Friends is a popular sitcom."

# 영어 단어 토큰화 수행
english_tokens = word_tokenize(english_sentence)
print("영어 단어 토큰화 결과:", english_tokens)
```

**실행 및 설명**

* 결과 확인
    * `nltk` 설치 메시지, `punkt` 다운로드 메시지, 그리고 마지막으로 `영어 단어 토큰화 결과: ["Friends", "is", "a", "popular", "sitcom", "."]`가 출력됩니다.
    * `!pip install nltk`로 라이브러리를 설치했습니다.
    * `nltk.download("punkt")`로 토큰화에 필요한 데이터를 받았습니다.
    * `from nltk.tokenize import word_tokenize`로 특정 함수를 불러왔습니다.
    * `word_tokenize()` 함수가 영어 문장을 단어와 구두점 단위로 잘 나누어 리스트로 반환했습니다. 이것이 가장 기본적인 텍스트 처리 단계 중 하나입니다.
* **주의:** 런타임 재시작 시 nltk 라이브러리를 다시 설치해야 `nltk`를 사용할 수 있습니다.

## 한국어 자연어 처리 맛보기 (`konlpy`)

이제 한국어 텍스트 분석에 유용한 `konlpy` 라이브러리를 설치하고, 문장을 의미있는 가장 작은 단위인 "형태소"로 나누는 분석을 체험해 봅시다.

다음은 `konlpy` 라이브러리를 pip로 설치하고, Okt 분석기로 "프렌즈는 정말 재미있는 시트콤이야." 문장을 형태소 분석하는 과정입니다.

1. Colab 코드 셀에서 `pip` 명령어를 사용하여 `konlpy` 라이브러리를 설치합니다.
2. `konlpy.tag` 모듈에서 `Okt` 형태소 분석기를 불러오는 코드를 작성합니다.
3. `Okt` 분석기 객체를 생성한 후, 한국어 문장 "프렌즈는 정말 재미있는 시트콤이야."를 형태소 단위로 분석(`morphs` 메소드 사용)하고 그 결과를 출력하는 코드를 작성하고 실행시킵니다.

```
# 1. konlpy 라이브러리를 설치합니다. (시간이 조금 걸릴 수 있습니다)
!pip install konlpy

# 2. konlpy의 Okt 형태소 분석기를 불러옵니다.
from konlpy.tag import Okt

# 한국어 문장 정의
korean_sentence = "프렌즈는 정말 재미있는 시트콤이야."

# 3. Okt 형태소 분석기 객체를 생성하고 형태소 분석 수행
okt = Okt() # Okt 객체 생성
korean_morphemes = okt.morphs(korean_sentence)  # morphs 메소드로 형태소 분석
print("한국어 형태소 분석 결과:", korean_morphemes)
```

**실행 및 설명**

* 결과 확인
    * `konlpy` 설치 메시지 이후, `한국어 형태소 분석 결과: ["프렌즈", "는", "정말", "재미있는", "시트콤", "이야", "."]`가 출력됩니다.
    * `!pip install konlpy`로 라이브러리를 설치했습니다.
        * konlpy는 설치에 필요한 다른 요소들이 많아 시간이 조금 더 걸릴 수 있습니다.
    * `from konlpy.tag import Okt`로 `Okt` 분석기를 불러왔습니다. 
        * `Okt` 외에도 `Kkma`, `Komoran` 등 다양한 분석기가 `konlpy`에 포함되어 있습니다.
    * `okt = Okt()` 코드로 분석기 객체를 생성해야 관련 메소드(`.morphs()`)를 사용할 수 있습니다.
    * `.morphs()` 메소드는 문장을 형태소 단위로 나누어 리스트로 반환합니다. 
        * "프렌즈", "는", "정말", "재미있는" 등이 각각의 형태소로 분리된 것을 볼 수 있습니다. 이는 한국어 텍스트 분석의 핵심적인 전처리 단계입니다.
* **주의:** 역시 런타임 재시작 시 라이브러리를 다시 설치해야 `konlpy`를 사용할 수 있습니다.

## 내용 정리
이번 실습에서는 파이썬의 강력한 기능 중 하나인 라이브러리(모듈)의 개념을 배우고, `import` 문을 사용하여 라이브러리를 불러오는 방법을 익혔습니다. 또한, 기본 내장 라이브러리인 `math`와 `random`의 간단한 함수들을 직접 사용해보며 라이브러리 활용법을 체험했습니다. 마지막으로, Colab 환경에 기본적으로 포함되지 않은 외부 라이브러리(예: `nltk`, `konlpy`)를 `!pip install` 명령어를 사용하여 설치하고, 각 라이브러리를 활용한 간단한 영어 단어 토큰화 및 한국어 형태소 분석 기능을 맛보는 것까지 알아보았습니다. 

앞으로 우리는 데이터 분석(Pandas), 텍스트 처리(NLTK, KoNLPy), 네트워크 분석(NetworkX) 등 더욱 전문적인 작업을 위해 다양한 외부 라이브러리들을 `import`하고, 필요하다면 직접 `!pip install`하여 적극적으로 활용하게 될 것입니다. 라이브러리를 잘 활용하는 것이 파이썬을 효과적으로 사용하는 핵심 열쇠 중 하나입니다.