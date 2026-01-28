---
title: 프렌즈 네트워크를 위한 데이터 편찬
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

## "프렌즈" 네트워크를 위한 데이터 편찬

지금까지 우리는 네트워크 분석의 이론적 배경(1장)과, NetworkX라는 도구를 다루는 기본적인 방법(2장)을 익혔습니다. 이제 우리는 이론과 도구를 손에 들고, 실제 연구의 심장부로 들어갈 준비를 마쳤습니다. 3장은 "프렌즈"라는 원석(raw material)을 우리의 연구 질문에 답할 수 있는 정제된 보석, 즉 **네트워크 데이터**로 가공하는 과정 전체를 다룹니다.

디지털 인문학 프로젝트의 성패는 바로 이 **데이터 편찬(Data Curation/Compilation)** 과정에 달려있다고 해도 과언이 아닙니다. 이는 단순히 존재하는 데이터를 긁어모으는 "수집(collection)"이 아니라, 원본 텍스트를 비판적으로 독해하고, 무엇을 분석 단위로 삼을지 결정하며, 관계를 어떻게 정의할지 선택하는, 한 편의 논문을 쓰는 것과 같은 지적이고 창의적인 과정입니다. "편찬"이라는 단어가 암시하듯, 여기에는 연구자의 깊은 해석과 철학이 담기게 됩니다.

이번 장에서 우리는 `Friends.xml` 이라는 실제 대본 파일을 다루며, 어떻게 등장인물(노드)을 식별하고, 그들 사이의 관계(엣지)를 정의하며, 관계의 강도(가중치)를 부여하여 우리만의 네트워크 데이터를 "편찬"해 나가는지를 단계별로 학습할 것입니다. 이 과정은 때로 좌절감을 안겨주기도 하지만, 동시에 가장 큰 학문적 희열을 선사하는 디지털 인문학 연구의 핵심적인 여정입니다.
