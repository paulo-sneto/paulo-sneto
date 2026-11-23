#!/usr/bin/env bash
# Valida se cada imagem usada no README responde 200, é SVG e não é um card de erro.
set -uo pipefail

OWNER="${OWNER:-paulo-sneto}"
RAW="https://raw.githubusercontent.com/${OWNER}/${OWNER}"

URLS=(
  "${RAW}/main/metrics.svg"
  "${RAW}/output/streak-dark.svg"
  "${RAW}/output/streak-light.svg"
  "${RAW}/output/snake.svg"
  "${RAW}/output/snake-dark.svg"
  "https://skillicons.dev/icons?i=php,laravel,mysql,postgresql,mongodb,js,nodejs,docker,git&theme=dark"
)

ERROR_PATTERNS='No languages data|Something went wrong|rate limit|Could not fetch|Maximum user capacity'

fail=0
for url in "${URLS[@]}"; do
  body="$(curl -fsSL --max-time 30 "$url")" || { echo "❌ HTTP falhou:      $url"; fail=1; continue; }

  if ! grep -q '<svg' <<<"$body"; then
    echo "❌ Não é SVG:       $url"; fail=1; continue
  fi

  if grep -qiE "$ERROR_PATTERNS" <<<"$body"; then
    echo "❌ Card de erro:    $url"; fail=1; continue
  fi

  echo "✅ OK:              $url"
done

exit "$fail"
