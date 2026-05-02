# Checklist de deploy

#deploy/checklist

Cole esta lista a cada deploy importante.

## Antes do deploy

- [ ] Substituições aplicadas (domínio, WhatsApp, e-mail) — script `update-site.ps1`
- [ ] Imagens sociais geradas (`og-image.jpg`, `twitter-card.jpg`) — script `convert-images.ps1`
- [ ] Catálogo em [[05-produtos/catalogo]] sincronizado com `script.js`
- [ ] Sitemap com `<lastmod>` atualizado se conteúdo crítico mudou
- [ ] Versão local testada em http-server (sem hard refresh quebrando nada)

## Arquivos que sobem para `public_html/`

```
public_html/
├── .htaccess              ✓
├── 404.html               ✓
├── index.html             ✓
├── styles.css             ✓
├── script.js              ✓
├── robots.txt             ✓
├── sitemap.xml            ✓
├── site.webmanifest       ✓
├── humans.txt             ✓
└── assets/
    ├── logo.png           ✓
    ├── mascote.png        ✓
    ├── mascote2.png       ✓
    ├── og-image.jpg       ✓
    ├── twitter-card.jpg   ✓
    └── (PNGs ChatGPT)     ✓ se quiser manter
```

## Arquivos que NÃO sobem

- `convert-images.ps1` / `update-site.ps1`
- `*.svg` em assets (templates locais)
- `obsidian/` (vault)
- `.git/`, `.claude/`, `.gitignore`
- `DEPLOY-HOSTINGER.md`, `README.md`

## Pós-deploy

- [ ] Acessar `https://green-hippopotamus-490496.hostingersite.com/` — site abre com SSL
- [ ] Acessar `/qualquer-coisa-inexistente` — 404 customizado aparece
- [ ] Acessar `/sitemap.xml` — XML carrega
- [ ] Acessar `/robots.txt` — texto carrega
- [ ] Acessar `/assets/og-image.jpg` — imagem aparece direto
- [ ] DevTools (F12) aberto: nenhum erro de CSP no console
- [ ] DevTools → Network: assets vêm com `cache-control: max-age=31536000`
- [ ] Mobile: testar no celular real (Lighthouse no Chrome)
- [ ] WhatsApp: clicar no botão flutuante e ver se abre o número certo

## Validações sociais

- [ ] [Facebook Debugger](https://developers.facebook.com/tools/debug/) — colar URL, "Scrape Again", ver preview
- [ ] [Twitter Card Validator](https://cards-dev.twitter.com/validator) — preview com twitter-card.jpg
- [ ] [LinkedIn Post Inspector](https://www.linkedin.com/post-inspector/) — preview e refresh
- [ ] WhatsApp: enviar a URL para si mesma e ver se o card aparece

## Validações SEO

- [ ] [Rich Results Test](https://search.google.com/test/rich-results) — todos os 8 schemas detectados
- [ ] [PageSpeed Insights](https://pagespeed.web.dev/) — meta: Performance ≥ 90, SEO 100, Acessibilidade ≥ 95
- [ ] [securityheaders.com](https://securityheaders.com/) — meta: A+
- [ ] Google Search Console: sitemap enviado e processado

## Limpar cache

- [ ] LiteSpeed cache limpo no hPanel
- [ ] Cloudflare (se usar): purge tudo
- [ ] Browser local: hard refresh (Ctrl+Shift+R)

## Vê também

- [[10-deploy/hostinger]]
- [[10-deploy/performance]]
