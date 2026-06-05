# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Rosa Encantada by Lorraine — a single-page marketing/catalog site for an artisanal Brazilian chocolate brand. Pure static HTML/CSS/JS (no build step, no framework, no package manager). Deployed to Hostinger shared hosting (Apache + LiteSpeed) via hPanel/FTP. All copy is in Brazilian Portuguese.

## Repo layout

```
/
├── index.html, 404.html         ← entry points (must stay at root)
├── robots.txt, sitemap.xml, humans.txt, site.webmanifest, .htaccess
├── assets/
│   ├── css/styles.css           ← all styles (hand-written, no preprocessor)
│   ├── js/script.js             ← all behavior (vanilla JS)
│   ├── img/                     ← logo, mascote, fotos do produto
│   └── social/                  ← og-image / twitter-card (svg + jpg)
├── data/
│   └── products.json            ← catálogo (carregado via fetch pelo script.js)
├── scripts/
│   ├── update-site.ps1          ← bulk find/replace de domínio/WhatsApp
│   └── convert-images.ps1       ← gera og/twitter jpg via System.Drawing
├── docs/
│   └── DEPLOY-HOSTINGER.md      ← runbook de deploy (autoritativo)
├── obsidian_rosaencantada/      ← vault pessoal da dona; NÃO refatorar
└── CLAUDE.md, README.md, .gitignore
```

Os **caminhos referenciados em HTML/JSON-LD/sitemap são relativos à raiz** (ex: `assets/css/styles.css`). Mover qualquer arquivo desse layout exige atualizar referências em pelo menos: `index.html`, `404.html`, `site.webmanifest`, `sitemap.xml`, e `assets/js/script.js`.

## Architecture

- **`index.html`** — documento único contendo todas as seções (`#hero`, `#sobre`, `#produtos`, `#processo`, `#encomendas`, depoimentos, `#contato`). O `<head>` é grande porque carrega toda a superfície de SEO: meta tags, OpenGraph, Twitter cards, hreflang, e um `<script type="application/ld+json">` `@graph` declarando entidades `Organization`, `LocalBusiness`, `FAQPage`, `HowTo`, `Recipe`, `Product`. **Trate o JSON-LD como infraestrutura de produção** — quando dados de produto/contato mudam (em `data/products.json` ou no HTML visível), o JSON-LD precisa ser sincronizado.

- **`assets/js/script.js`** — JS vanilla. Busca o catálogo via `fetch('data/products.json')` em `loadProducts()` (init assíncrono); até resolver, `PRODUCTS` é `[]`. Cart state vive em `localStorage` sob a chave `rosa-cart`. Checkout é deep-link de WhatsApp: `WHATSAPP_NUMBER` está hard-coded e o cart serializa em URL `wa.me` — **não há backend**. Há também um `injectProductSchema()` que gera JSON-LD `ItemList` dinâmico a partir de `PRODUCTS`.

- **`data/products.json`** — array canônico de produtos (`id`, `cat` ∈ `trufa|bombom|caixa`, `name`, `desc`, `price`, `badge` opcional, `emoji`). Editar este arquivo = editar o catálogo. **Atenção:** se as imagens de produto deixarem de ser emojis e virarem fotos reais, adicionar campo `image` aqui e propagar pra `injectProductSchema` no `script.js`.

- **`styles.css`** — hand-written, sem preprocessor.

Arquivos auxiliares: `404.html` (página de erro custom), `.htaccess` (HTTPS force, www→apex redirect, cache headers, CSP, Brotli, error documents), `sitemap.xml`, `robots.txt`, `humans.txt`, `site.webmanifest`.

`obsidian_rosaencantada/` é o vault pessoal da dona — notas de conteúdo, não código. Não refatorar nem reestruturar.

## Common tasks

Não há build, test runner ou linter. Para rodar localmente, **é preciso servir os arquivos por HTTP** (o `fetch('data/products.json')` falha em `file://` por CORS). Da raiz do projeto:

```powershell
python -m http.server 8000
# ou
npx serve .
```

Depois abra `http://localhost:8000/`.

Dois helpers PowerShell em `scripts/` (rode da raiz do projeto):

- **`.\scripts\update-site.ps1`** — find/replace em lote por todos os arquivos texto, trocando o domínio de produção, número de WhatsApp e telefone display. Edite o array `$replacements` no topo antes de rodar. Pula `.git`, `node_modules`, e os próprios `.ps1`. Escreve UTF-8 sem BOM. Já processa `.json` (importante pro `data/products.json`).
- **`.\scripts\convert-images.ps1`** — gera `assets/social/og-image.jpg` e `assets/social/twitter-card.jpg` do zero usando `System.Drawing` (sem dependências externas). Re-rodar após mudanças visuais da marca.

## Convenções específicas deste repo

- **Domínio/contato:** o source usa o domínio de produção `rosaencantada.vercel.app` (Vercel) e WhatsApp `5531986977393`. As referências de domínio vivem em `index.html`, `404.html`, `robots.txt`, `sitemap.xml` e `assets/js/script.js` (constante `ORIGIN` em `injectProductSchema`). Para trocar domínio/WhatsApp em lote, ajuste o array `$replacements` em `update-site.ps1` e rode-o, em vez de editar à mão.
- **Consistência cross-file:** dados de produto vivem em `data/products.json`. JSON-LD `Product` no `index.html` (entidades estáticas no `@graph`) precisa bater com nomes/preços/descrições do JSON. O `injectProductSchema()` em `script.js` gera entidades adicionais dinâmicas baseadas no JSON.
- **CSP:** `.htaccess` envia uma `Content-Security-Policy` estrita. Adicionar novo host de script/font/imagem de terceiros exige atualizar a diretiva CSP, ou o recurso é bloqueado em produção.
- **Cache busting:** Hostinger LiteSpeed cacheia agressivamente. Após deploy o usuário limpa cache via hPanel; pra previews sociais (WhatsApp em especial), adicionar `?v=N` na URL.
- **`robots.txt` bloqueia `*.json$` para crawlers** — isso é intencional (não queremos que SEO indexe `data/products.json`). O browser fetcha normalmente; só afeta bots.

## Reference

`docs/DEPLOY-HOSTINGER.md` é o runbook autoritativo de deploy (passos de upload, SSL, checklist de validação, troubleshooting). Consulte antes de sugerir mudanças relacionadas a deploy.
