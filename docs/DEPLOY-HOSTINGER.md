# Deploy na Hostinger — Rosa Encantada

Guia rápido e prático para subir o site no painel **hPanel** da Hostinger.

---

## 1. Pré-deploy (antes de subir)

Antes de enviar os arquivos, faça uma busca global no projeto e substitua:

| Encontrar | Substituir por |
|-----------|----------------|
| `green-hippopotamus-490496.hostingersite.com` | seu domínio real (sem `https://`) |
| `5531986977393` | número do WhatsApp com DDI+DDD (ex: `5511988887777`) |
| `@rosaencantada` | handle real do Twitter/X |
| `contato@rosaencantada.com` | e-mail real |

**Arquivos que contêm essas referências:**
`index.html`, `404.html`, `assets/js/script.js`, `sitemap.xml`, `site.webmanifest`, `robots.txt`, `humans.txt`.

> Use `.\scripts\update-site.ps1` (a partir da raiz) para fazer essa substituição em lote — edite o array `$replacements` no topo do script antes de rodar.

**Converter os SVGs para JPG:**
- `assets/social/og-image.svg` → `assets/social/og-image.jpg` (1200×630)
- `assets/social/twitter-card.svg` → `assets/social/twitter-card.jpg` (1200×600)
- Use cloudconvert.com, Figma ou Inkscape. Qualidade 85–90%, peso < 300KB.
- Ou rode `.\scripts\convert-images.ps1` (gera direto via System.Drawing, sem dependências).

---

## 2. Upload via hPanel

### Opção A — Gerenciador de arquivos (mais simples)
1. Entre em **hPanel → Arquivos → Gerenciador de arquivos**.
2. Vá até a pasta **`public_html/`**.
3. Apague o `default.php` ou `index.html` que vem por padrão.
4. Suba o **conteúdo** da pasta do projeto (não a pasta em si):
   - `index.html`
   - `404.html`
   - `robots.txt`
   - `sitemap.xml`
   - `site.webmanifest`
   - `humans.txt`
   - `.htaccess` ← **importante: ative "Mostrar arquivos ocultos"**
   - pasta `assets/` (com `css/`, `js/`, `img/`, `social/`)
   - pasta `data/` (catálogo `products.json`)

> **Não precisa subir:** `scripts/`, `docs/`, `obsidian_rosaencantada/`, `CLAUDE.md`, `README.md`, `.git/`, `.claude/` — são apenas locais.

### Opção B — FTP (FileZilla)
- Host: ftp.seudominio.com.br
- Usuário/senha: criados em **hPanel → Avançado → Contas FTP**
- Diretório remoto: `/public_html/`

### Opção C — Git (planos Premium+)
- **hPanel → Avançado → Git** → conecta repositório → deploy automático.

---

## 3. Configurações no hPanel

### SSL (HTTPS)
1. **hPanel → Segurança → SSL** → "Instalar SSL" (Let's Encrypt grátis).
2. Aguarde 5–15 min.
3. Ative **"Forçar HTTPS"**. *(O `.htaccess` já força como fallback.)*

### Domínio
- Aponte o domínio para a Hostinger (nameservers `ns1.dns-parking.com` / `ns2.dns-parking.com`) ou use o DNS da Hostinger.
- Se usar **www**, decida: o `.htaccess` está configurado para **redirecionar `www` para a versão sem www**. Para inverter, troque o bloco no `.htaccess`.

### LiteSpeed Cache
- Já configurado pelo `.htaccess`.
- Em **hPanel → Avançado → Cache do site**, mantenha o cache **ligado**.
- Se fizer alteração e não aparecer, clique em **"Limpar cache"**.

---

## 4. Pós-deploy: validar

- [ ] Abrir `https://seudominio.com.br` — site carrega com cadeado verde
- [ ] `https://seudominio.com.br/qualquer-coisa-inexistente` → mostra `404.html`
- [ ] `https://seudominio.com.br/robots.txt` abre
- [ ] `https://seudominio.com.br/sitemap.xml` abre
- [ ] `www.seudominio.com.br` redireciona para sem www
- [ ] `http://seudominio.com.br` redireciona para `https://`
- [ ] Console do navegador (F12) sem erros de CSP

---

## 5. SEO — submeter e validar

| Ferramenta | O que fazer |
|------------|-------------|
| [Google Search Console](https://search.google.com/search-console) | Adicionar propriedade, verificar via DNS/HTML, enviar `sitemap.xml` |
| [Bing Webmaster](https://www.bing.com/webmasters) | Mesmo processo (pode importar do Google) |
| [Rich Results Test](https://search.google.com/test/rich-results) | Validar JSON-LD (deve mostrar Organization, LocalBusiness, FAQ, HowTo, Recipe, Products) |
| [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/) | Forçar refresh do OG (quando trocar imagem) |
| [Twitter Card Validator](https://cards-dev.twitter.com/validator) | Preview do summary_large_image |
| [LinkedIn Post Inspector](https://www.linkedin.com/post-inspector/) | Preview e refresh de cache |
| [PageSpeed Insights](https://pagespeed.web.dev/) | Performance, SEO, Acessibilidade |
| [securityheaders.com](https://securityheaders.com/) | Verificar headers (meta: A+) |
| [ssllabs.com/ssltest](https://www.ssllabs.com/ssltest/) | Qualidade do SSL (meta: A) |

---

## 6. Solução de problemas comuns

**Erro 500 após upload do `.htaccess`:**
- Comente o bloco HSTS (`Strict-Transport-Security`) e teste.
- Comente a linha do `Content-Security-Policy` se algum recurso quebrar.
- Se `mod_brotli` não existir, comente esse bloco.

**Cards sociais não atualizam:**
- Use o Facebook Debugger e clique em **"Scrape Again"** para forçar.
- WhatsApp: o cache pode levar até 7 dias para limpar — adicione `?v=2` na URL ao compartilhar para forçar.

**SSL não aparece:**
- Verifique se o domínio aponta corretamente. Pode levar até 24h após mudar nameservers.

**Site abre, mas CSS/JS não carrega:**
- Confira no DevTools (F12 → Network) o caminho dos arquivos. Se aparecer `404`, o upload pode não ter ido para `public_html/` — está em uma subpasta.

**404.html não aparece:**
- Confirme que o `.htaccess` foi enviado e está no `public_html/`. Em alguns FTPs, ele fica oculto — habilite "mostrar arquivos ocultos".

---

## 7. Manutenção

- Sempre que editar `index.html`, faça também: `Limpar cache LiteSpeed` no hPanel.
- Mantenha `sitemap.xml` com `<lastmod>` atualizado quando alterar conteúdo importante.
- Backup: hPanel → Arquivos → **"Backups"** (mantém versões automáticas).
