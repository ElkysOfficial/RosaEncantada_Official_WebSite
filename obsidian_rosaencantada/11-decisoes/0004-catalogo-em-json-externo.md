# ADR-0004: Catálogo migrado para `data/products.json`

#decisao/arquitetura

- **Status:** ✅ Aceita (substitui [[11-decisoes/0003-catalogo-em-js]])
- **Data:** 2026-05-02

## Contexto

A primeira versão (ADR-0003) deixava o array `PRODUCTS` no topo de `script.js`. Conforme a Lorraine começou a precisar editar preços/descrições com mais frequência, ficou claro que misturar dados e código atrapalha — qualquer ajuste de catálogo virava commit em arquivo de comportamento, com risco de quebrar o JS.

## Decisão

Catálogo passa a viver em `data/products.json`. `script.js` carrega via `fetch('data/products.json')` em `loadProducts()` (init assíncrono); até resolver, `PRODUCTS = []`.

## Razões

- **Separação dados × código** — editar catálogo não toca JS
- **Diff legível** em PR de mudança de preço/sabor
- **`injectProductSchema()`** continua gerando JSON-LD dinâmico a partir do mesmo array
- Custo: 1 round-trip extra (compensado pelo cache do navegador)

## Consequências

✅ Bom:
- Lorraine edita 1 arquivo JSON com estrutura óbvia
- `robots.txt` bloqueia `*.json$` para crawlers (não indexa o catálogo cru)

⚠️ Atenção:
- **Servir por HTTP** em dev (`python -m http.server`) — `file://` quebra o fetch por CORS
- Se adicionar fotos reais (substituir emojis), incluir campo `image` no JSON e propagar no `injectProductSchema()`
- JSON-LD `Product` estático no `@graph` do `index.html` precisa continuar batendo com o JSON

## Vê também

- [[11-decisoes/0003-catalogo-em-js]] (superseded)
- [[05-produtos/catalogo]]
