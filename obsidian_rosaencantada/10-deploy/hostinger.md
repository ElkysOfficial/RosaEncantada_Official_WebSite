# Hostinger

#deploy/hostinger

## Plano e ambiente

- **Plano:** (a confirmar — Premium/Business?)
- **Stack:** Apache + LiteSpeed
- **PHP:** não usado (site estático)
- **Domínio temporário:** `green-hippopotamus-490496.hostingersite.com`
- **Domínio próprio:** *(a comprar)*

## Painel

- hPanel: https://hpanel.hostinger.com/
- Gerenciador de Arquivos → `public_html/`

## O que vai para `public_html/`

Ver [[10-deploy/checklist]] para a lista canônica.

## .htaccess

Configurado com:
- HTTPS forçado
- Redirect www → sem www
- Remove `.html` da URL
- 404 customizado (`404.html`)
- Headers de segurança (HSTS, CSP, X-Frame, Referrer)
- Compressão Gzip + Brotli
- Cache imutável 1 ano para assets, sem cache para HTML
- Bloco LiteSpeed específico

> Se der erro 500 após upload: comente HSTS ou CSP e teste.

## LiteSpeed Cache

- Cache automático para assets estáticos (1 ano)
- HTML sempre revalidado
- **Limpar cache** no hPanel após mudanças importantes em `index.html`

## SSL

- Let's Encrypt (grátis)
- Auto-renovação habilitada
- Forçar HTTPS no hPanel ✓

## Upload

- Via Gerenciador de Arquivos (drag-drop) ou FTP (FileZilla)
- **Atenção:** ativar "mostrar arquivos ocultos" para enxergar o `.htaccess`
- Upload em chunks: enviar `assets/` primeiro, depois HTML/CSS/JS

## O que NÃO sobe

- `.git/`, `.claude/`, `obsidian/`
- Scripts `.ps1`
- Arquivos `.svg` da pasta assets (templates editáveis)
- README/docs

## Vê também

- [[10-deploy/checklist]]
- [[10-deploy/performance]]
- [[../../DEPLOY-HOSTINGER|DEPLOY-HOSTINGER.md]] (na raiz do repo)
