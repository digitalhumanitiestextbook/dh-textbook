#!/usr/bin/env bash
set -euo pipefail

CONTENT_DIR="content"
NOTEBOOKS_DIR="notebooks"
KERNEL="python3"

mkdir -p "$NOTEBOOKS_DIR"

find "$CONTENT_DIR" -type f -name "*.md" | while read -r SRC; do
  REL="${SRC#$CONTENT_DIR/}"
  DST_MD="$NOTEBOOKS_DIR/$REL"
  DST_IPYNB="${DST_MD%.md}.ipynb"

  mkdir -p "$(dirname "$DST_MD")"

  # frontmatter 여부 확인
  if ! head -n 1 "$SRC" | grep -q '^---'; then
    continue
  fi

  # frontmatter 끝 위치
  FM_END_LINE=$(awk '
    NR==1 && $0=="---" {in_fm=1; next}
    in_fm && $0=="---" {print NR; exit}
  ' "$SRC")

  [[ -z "${FM_END_LINE:-}" ]] && continue

  FRONTMATTER=$(sed -n "2,$((FM_END_LINE-1))p" "$SRC")

  # jupytext 있는 경우만 처리
  if ! echo "$FRONTMATTER" | grep -q '^jupytext:'; then
    continue
  fi

  # title 추출
  TITLE=$(echo "$FRONTMATTER" \
    | sed -n 's/^title:[[:space:]]*//p' \
    | sed 's/^"\(.*\)"$/\1/' \
    | sed "s/^'\(.*\)'$/\1/" \
    | head -n 1)

  {
    # 제목
    if [[ -n "$TITLE" ]]; then
      echo "# $TITLE"
      echo
    fi

    # 본문 출력 + colab 버튼 제거
    sed -n "$((FM_END_LINE+1)),\$p" "$SRC" \
      | sed '/<!-- colab-button:start -->/,/<!-- colab-button:end -->/d'
  } > "$DST_MD"

  # ipynb 생성
  jupytext --to ipynb --set-kernel "$KERNEL" "$DST_MD"

  # md 중간 산출물 삭제
  rm "$DST_MD"

  echo "📓 Generated notebook → $DST_IPYNB"
done

echo "✅ Done. notebooks/에는 ipynb만 남았습니다."