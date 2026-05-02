# Schemas estruturados (JSON-LD)

#seo/schema

## Resumo

8 schemas ativos. 7 inline em `index.html`, 1 (`ItemList` de produtos) injetado dinamicamente em `script.js`.

## Schemas ativos

### 1. Organization
- **Onde:** `<head>` do `index.html`
- **Função:** identifica a empresa, fundadora (Lorraine), logo, slogan, redes sociais
- **Vital para:** Knowledge Panel do Google

### 2. LocalBusiness
- **Onde:** `<head>` do `index.html`
- **Função:** negócio local — telefone, e-mail, horários, faixa de preço, formas de pagamento, **aggregateRating** + 2 reviews
- **Vital para:** SEO local + estrelas no resultado

### 3. WebSite
- **Onde:** `<head>` do `index.html`
- **Função:** identidade do site, idioma, link para Organization, **SearchAction** (`/?s={search}`)
- **Vital para:** sitelinks e busca interna no Google

### 4. BreadcrumbList
- **Onde:** `<head>` do `index.html`
- **Função:** trilha Início → Sabores → Encomendas → Contato
- **Vital para:** breadcrumbs no resultado

### 5. HowTo
- **Onde:** `<head>` do `index.html`
- **Função:** "Como nasce uma trufa" — 4 passos (Seleção, Receita, Acabamento, Embalagem)
- **Vital para:** rich result educacional

### 6. Recipe
- **Onde:** `<head>` do `index.html`
- **Função:** Receita "Trufa Belga Clássica" — ingredientes, modo de preparo, info nutricional, rating
- **Vital para:** aparecer em busca de receitas (quando essa intenção bater)

### 7. FAQPage
- **Onde:** `<head>` do `index.html`
- **Função:** 5 perguntas (mínimo, eventos, pedido, pagamento, validade)
- **Vital para:** caixa de FAQ no resultado

### 8. ItemList (Product)
- **Onde:** injetado em runtime via `script.js` → `injectProductSchema()`
- **Função:** lista os 12 produtos do catálogo, cada um com Product + Offer + AggregateRating
- **Vital para:** rich snippets de produto

## Validação

| Ferramenta | URL |
|-----------|-----|
| Rich Results Test | https://search.google.com/test/rich-results |
| Schema Validator | https://validator.schema.org/ |
| Google Search Console | https://search.google.com/search-console |

## Atualizando

- **Catálogo mudou** → atualiza automaticamente via JS
- **Endereço/horários mudou** → editar JSON-LD em `index.html` (LocalBusiness)
- **Reviews mudaram** → editar `aggregateRating` e `review[]` em LocalBusiness
- **FAQ mudou** → editar bloco FAQPage e replicar visualmente em uma seção do site (boa prática)

## Pendências

- [ ] Adicionar endereço completo no LocalBusiness (rua, cidade, CEP, lat/long)
- [ ] Conectar reviews reais quando tiver volume
- [ ] Considerar `Event` schema para datas sazonais (Páscoa, Dia das Mães)

## Vê também

- [[06-seo/estrategia]]
- [[06-seo/palavras-chave]]
