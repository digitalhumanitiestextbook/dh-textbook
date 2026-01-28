---
title: NetworkX 첫걸음 - 파이썬으로 네트워크 만들기 (실습 준비)
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

## NetworkX 첫걸음 - 파이썬으로 네트워크 만들기 (실습 준비)

지금까지 우리는 네트워크가 무엇인지, 어떤 구성요소로 이루어져 있으며 인문학 연구에 어떤 새로운 가능성을 열어주는지에 대해 충분히 탐색했습니다. 관계를 바라보는 새로운 "관점"이라는 안경을 썼다면, 이제는 그 관점을 현실로 구현할 "손과 도구"를 익힐 차례입니다.

이번 장부터 우리는 본격적으로 "**파이썬(Python)**"이라는 프로그래밍 언어와 **NetworkX**라는 강력한 라이브러리를 사용하여 직접 네트워크를 만들고, 조작하고, 분석하는 실습의 세계로 뛰어들 것입니다. 프로그래밍 경험이 전혀 없어도 괜찮습니다. 이 교재의 핵심 교육 방식은 모든 코드를 처음부터 끝까지 직접 작성하는 "코딩"이 아니라, 우리가 원하는 바를 명확한 언어로 AI에게 요청하여 코드를 생성하고 그 의미를 이해하는 "**입코딩**"이기 때문입니다. 여러분에게 필요한 것은 어려운 문법을 암기하는 능력이 아니라, "무엇을 하고 싶은가"를 명확히 정의하고 AI와 소통하는 능력입니다.

이 장의 모든 실습은 웹 브라우저만 있으면 어디서든 무료로 파이썬을 실행할 수 있는 **Google Colaboratory (Colab)** 환경을 기준으로 진행됩니다. 자, 이제 이론을 현실로 만들 첫걸음을 함께 내디뎌 봅시다.