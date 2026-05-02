# Estratégia SEO

#seo/estrategia

## Posicionamento orgânico

**Quem somos** para o Google:
- Confeitaria artesanal
- Trufas e bombons
- Encomendas para eventos (casamento, lembrancinha)
- Brasil (geo BR — refinar quando definir cidade)

## Pilares

1. **SEO local** (quando definir cidade/CEP)
2. **SEO de produto** (cada sabor com schema Product)
3. **SEO de receita** (Trufa Belga com schema Recipe)
4. **SEO de serviço** (encomendas para casamento, eventos)
5. **Cards sociais** (OG/Twitter para compartilhamento orgânico)

## Schemas implementados

Total: **8 schemas JSON-LD** ativos

| Schema | Onde | Função |
|--------|------|--------|
| Organization | `<head>` | quem é a empresa |
| LocalBusiness | `<head>` | negócio local + reviews + horários |
| WebSite | `<head>` | identidade do site + SearchAction |
| BreadcrumbList | `<head>` | trilha de navegação |
| HowTo | `<head>` | "Como nasce uma trufa" (4 passos) |
| Recipe | `<head>` | Receita Trufa Belga Clássica |
| FAQPage | `<head>` | 5 perguntas frequentes |
| ItemList (Product) | injetado via JS | catálogo de 12 produtos |

## Meta tags principais

- Title com palavra-chave + marca + diferencial
- Description com CTA e 150 caracteres
- Keywords (ainda valem para Bing)
- Canonical absoluto
- Hreflang pt-BR + x-default

## Open Graph + Twitter

- `og:image` → 1200×630 JPG
- `twitter:card` → `summary_large_image` 1200×600 JPG
- Ambos referenciados em URL absoluta
- Validar após cada deploy importante

## Performance e Core Web Vitals

| Métrica | Meta | Status |
|---------|------|--------|
| LCP | < 2.5s | preload do mascote |
| CLS | < 0.1 | reserve de espaço em todas as imagens |
| INP | < 200ms | JS leve, sem libs pesadas |

## Vê também

- [[06-seo/palavras-chave]]
- [[06-seo/schemas-estruturados]]
