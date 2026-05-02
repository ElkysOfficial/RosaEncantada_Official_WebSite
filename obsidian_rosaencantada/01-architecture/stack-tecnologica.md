# Stack tecnológica

#arquitetura/stack

## Front-end

| Camada | Tecnologia | Por quê |
|--------|-----------|---------|
| HTML | HTML5 semântico | acessibilidade + SEO |
| CSS | CSS3 puro, custom properties | manutenção fácil, sem build |
| JS | JavaScript ES2020+ vanilla | catálogo dinâmico, carrinho, schemas dinâmicos |
| Fontes | Google Fonts (Playfair, Dancing Script, Inter) | tipografia da marca |
| Ícones | SVG inline | sem requests extras |

## Hospedagem

- **Hostinger** (plano compartilhado)
- Apache + LiteSpeed
- SSL Let's Encrypt automático
- Sem CI/CD — upload via FTP/Gerenciador de Arquivos

## Sem o que (intencionalmente)

- ❌ Sem framework (React/Vue/etc.)
- ❌ Sem build step (Webpack/Vite)
- ❌ Sem TypeScript
- ❌ Sem backend (Node/PHP)
- ❌ Sem banco de dados
- ❌ Sem CMS
- ❌ Sem dependências npm

## Por quê manter mínimo

- Lorraine é confeiteira, não desenvolvedora — qualquer ajuste de catálogo precisa ser explicável
- Site institucional pequeno não justifica complexidade
- Hospedagem simples, sem Node — economiza no plano
- Lighthouse 95+ sem esforço

## Quando justificaria mudar

- Catálogo passar de ~50 itens → considerar CMS headless
- Precisar de pagamento online → backend ou Stripe Checkout
- Mais de uma pessoa editando conteúdo → CMS
- Multi-idioma de verdade → considerar Astro

Ver também: [[11-decisoes/0001-stack-vanilla]]
