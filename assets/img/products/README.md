# Fotos de produtos

Cada arquivo JPG aqui é renderizado num card do catálogo do site (`#produtos`).
Se o arquivo não existir, o card cai automaticamente no emoji do produto (definido em `data/products.json`).

> **Estado atual (placeholder):** os 9 produtos estão usando fotos do
> Unsplash apontadas diretamente em `data/products.json` (campo `image`
> com URL `https://images.unsplash.com/...`). Para trocar por fotos reais,
> coloque os JPGs aqui (nomes abaixo) e mude o `image` de cada produto
> em `data/products.json` para `assets/img/products/<id>.jpg`.

## Convenção
- Formato: **JPG** (ou PNG, mas JPG comprime melhor para fotos)
- Proporção: **quadrada (1:1)** — o site faz `object-fit: cover`, mas começar quadrado evita corte
- Resolução recomendada: **800×800 px** (peso < 200 KB cada)
- Nome do arquivo: igual ao `id` do produto em `data/products.json`, com extensão `.jpg`

## Arquivos esperados (substituir pelas fotos reais)

- `tr-ninho-morango.jpg` — Trufa de Ninho com Morango
- `tr-brigadeiro.jpg`    — Trufa de Brigadeiro
- `tr-limao.jpg`         — Trufa de Limão
- `tr-pacoca.jpg`        — Trufa de Paçoca
- `tr-coco.jpg`          — Trufa de Coco
- `tr-maracuja.jpg`      — Trufa de Maracujá
- `cx-06.jpg`            — Caixa Encantada · 6
- `cx-12.jpg`            — Caixa Encantada · 12
- `cx-24.jpg`            — Caixa Encantada · 24

## Como otimizar antes de subir
- TinyPNG (https://tinypng.com) — comprime sem perda visível
- Squoosh (https://squoosh.app) — converte e ajusta qualidade
