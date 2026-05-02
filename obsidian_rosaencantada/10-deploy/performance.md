# Performance

#deploy/performance

## Metas (Lighthouse mobile)

| Categoria | Meta |
|-----------|------|
| Performance | ≥ 90 |
| Acessibilidade | ≥ 95 |
| Boas práticas | 100 |
| SEO | 100 |

## Estratégias aplicadas

### Carregamento

- `preconnect` para fonts.googleapis e fonts.gstatic
- `dns-prefetch` para wa.me
- `preload` da imagem do mascote (LCP candidato) com `fetchpriority="high"`
- `font-display: swap` no Google Fonts
- CSS inline crítico? **não** — arquivo único pequeno (~44KB)

### Imagens

- PNGs otimizados (logo + mascotes)
- JPGs sociais com qualidade 88
- Sem CDN (Hostinger LiteSpeed entrega rápido para BR)

### JS

- Vanilla, ~18KB minimizado
- Sem libs externas
- IntersectionObserver para reveal-on-scroll
- Schemas dinâmicos injetados após load

### Cache

- Assets: `max-age=31536000, immutable` (1 ano)
- HTML: `no-cache, must-revalidate`
- LiteSpeed cache ativo

### Compressão

- Gzip + Brotli configurados no `.htaccess`

## Otimizações futuras

- [ ] WebP/AVIF para imagens (criar `<picture>` com fallback)
- [ ] Lazy load nas imagens abaixo da dobra
- [ ] Subset das fontes Google (só latin + pt-BR)
- [ ] Inline crítico do CSS (FOUC)
- [ ] Service Worker para offline-first (PWA real)

## O que monitorar

- Core Web Vitals no Search Console
- PageSpeed Insights mensalmente
- Tempo de resposta do servidor (TTFB) — se > 600ms, considerar Cloudflare na frente

## Vê também

- [[10-deploy/hostinger]]
- [[11-decisoes/0001-stack-vanilla]]
