# Visão geral da arquitetura

#arquitetura

## O que é o site

Landing page institucional + catálogo de produtos da **Rosa Encantada by Lorraine**, com checkout via WhatsApp. **Site estático, sem backend.**

## Princípios

1. **Simples** — HTML/CSS/JS vanilla. Sem build, sem dependências de runtime.
2. **Rápido** — Sub-1s no LCP. Imagens otimizadas, fonte do Google com `display=swap`.
3. **Acessível** — ARIA, focus visível, prefers-reduced-motion respeitado.
4. **SEO-first** — meta tags completas, schemas estruturados, OG/Twitter cards.
5. **Editável por uma pessoa** — qualquer mudança no catálogo é uma edição em [[script.js]].

## Estrutura de arquivos

```
rosaencantada/
├── index.html          → estrutura semântica + JSON-LD
├── styles.css          → design system completo, mobile-first
├── script.js           → catálogo, carrinho, interações
├── 404.html            → página de erro estilizada
├── robots.txt          → policies por user-agent
├── sitemap.xml         → URLs + image extensions
├── site.webmanifest    → PWA mínima
├── humans.txt          → créditos
├── .htaccess           → Apache/LiteSpeed (Hostinger)
├── assets/             → imagens (logo, mascotes, OG, Twitter)
├── obsidian/           → este vault
└── (scripts locais .ps1, não vão para produção)
```

## Fluxo do usuário

1. Visitante chega pelo Google ou link compartilhado
2. Hero → conhece a marca em 5 segundos
3. Sobre → entende o "porquê"
4. Produtos → escolhe sabores, monta carrinho
5. Carrinho drawer → revisa
6. Checkout → abre WhatsApp com mensagem pré-formatada
7. Lorraine fecha o pedido manualmente

**Não há banco, não há login, não há pagamento online.** Toda transação termina no WhatsApp.

## Decisões fundamentais

- [[11-decisoes/0001-stack-vanilla]]
- [[11-decisoes/0002-checkout-whatsapp]]
- [[11-decisoes/0003-catalogo-em-js]]

## Vê também

- [[01-architecture/stack-tecnologica]]
- [[10-deploy/hostinger]]
