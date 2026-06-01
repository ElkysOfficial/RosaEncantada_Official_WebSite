# Fotos de produtos

Cada JPG aqui é renderizado num card do catálogo do site (`#produtos`).
Se o arquivo não existir, o card cai automaticamente no emoji do produto (definido em `data/products.json`).

## Convenção
- Formato: **JPG** quadrado (1:1), **800×800 px**, < 200 KB
- Nome do arquivo: igual ao `id` do produto em `data/products.json` + `.jpg`
- O campo `image` em `data/products.json` aponta para `assets/img/products/<id>.jpg`

## Fluxo: adicionar/trocar uma foto
1. Coloque a foto original (qualquer tamanho) em `assets/img/products/`
2. Adicione o nome do arquivo + slug ao mapa `$map` em `scripts/optimize-products.ps1`
3. Rode `.\scripts\optimize-products.ps1` da raiz — ele corta pra quadrado,
   redimensiona pra 800×800, salva o JPG otimizado e move o original pra `_src/`
4. Garanta que o produto em `data/products.json` tem `"image": "assets/img/products/<id>.jpg"`

> `_src/` guarda os originais pesados e **não é versionado** (ver `.gitignore`).

## Fotos atuais
- `tr-ninho-morango.jpg` — Trufa de Ninho com Geleia de Morango
- `tr-brigadeiro.jpg`    — Trufa de Brigadeiro
- `tr-limao.jpg`         — Trufa de Limão
- `tr-coco.jpg`          — Trufa de Coco
- `tr-maracuja.jpg`      — Trufa de Maracujá
- `rosa-encantada.jpg`   — Rosa Encantada (presente)
- `buque-rosas.jpg`      — Buquê de Rosas (presente)
- `docinhos-encantados.jpg` — Docinhos Encantados (presente)
- `cesta-encantada.jpg`  — Cesta Encantada (presente)

Sem foto (usam emoji): `tr-pacoca`, `cx-06`, `cx-12`, `cx-24`.
