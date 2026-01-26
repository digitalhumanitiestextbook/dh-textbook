---
title: 프렌즈 등장인물 관계망 구축 및 기본 분석 (실습)
---

<!-- colab-button:start -->
<div class="colab-button">
  <a
    href="https://colab.research.google.com/github/digitalhumanitiestextbook/dh-textbook/blob/main/notebooks/part8_ai/02_deep_learning_basics.ipynb"
    target="_blank"
    rel="noopener"
  >
    Colab에서 실행하기
  </a>
</div>
<!-- colab-button:end -->

## '프렌즈' 등장인물 관계망 구축 및 기본 분석 (실습)

지금까지 우리는 네트워크 분석의 이론적 배경(1장)과, NetworkX라는 도구를 다루는 기본적인 방법(2장)을 익혔습니다. 또한 3장에서는 '프렌즈'라는 원석(raw material)을 분석 가능한 데이터로 가공하기 위한 설계도를 완성했습니다. 이제 우리는 드디어 첫 삽을 뜰 준비를 마쳤습니다. 이번 4장에서는 그 설계도를 바탕으로, `Friends.xml`이라는 원재료를 사용하여 실제 '프렌즈' 관계망이라는 건축물을 한 층 한 층 쌓아 올리는 구체적인 실습을 진행합니다.

지금까지 논의했던 모든 개념, 즉 노드와 엣지의 정의, 이름 정규화, 관계 정의 전략, 가중치 부여 방식 등이 하나의 파이썬 코드로 통합되어 실행되는 과정을 목격하게 될 것입니다. 이 과정을 통해 여러분은 텍스트 데이터라는 추상적인 원본이 어떻게 분석 가능한 구조를 가진 구체적인 네트워크 객체로 변환되는지를 직접 체험하게 될 것입니다.

완성된 네트워크를 통해 우리는 간단한 분석을 수행하여, "과연 '프렌즈'의 사회는 어떤 모습일까?"라는 첫 번째 질문에 대한 답을, 이제 실제 데이터를 통해 구해보겠습니다.
