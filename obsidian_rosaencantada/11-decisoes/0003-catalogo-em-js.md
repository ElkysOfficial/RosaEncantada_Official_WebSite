# ADR-0003: Catálogo como array no `script.js`

#decisao/arquitetura

- **Status:** ⛔ Superseded por [[11-decisoes/0004-catalogo-em-json-externo]] (2026-05-02)
- **Data:** 2026-04-30

## Contexto

12 produtos. Precisam ser exibidos no site, filtráveis, viráveis em itens de carrinho, e expostos no JSON-LD.

## Opções

1. **Array de objetos no `script.js`** ← escolhida
2. JSON externo carregado via fetch
3. CMS headless (Sanity, Contentful, Strapi)
4. HTML estático com cada card escrito à mão

## Decisão

Array `PRODUCTS` no topo de `script.js`. O renderProducts() gera o HTML, o catálogo passa para os schemas via injectProductSchema().

## Razões

- **Single source of truth** dentro do código
- **Sem fetch extra** = mais rápido
- **Schema dinâmico** consegue reaproveitar a mesma fonte
- **Edição de uma pessoa só** (Lorraine ou dev), poucas mudanças/mês

## Consequências

✅ Bom:
- Adicionar sabor = editar 1 arquivo + upload
- JSON-LD sempre em sincronia

⚠️ Atenção:
- Lorraine precisa de instrução clara para editar (ver [[05-produtos/catalogo]] passo-a-passo)
- Sem multi-idioma trivial (cada texto em português)
- Sem histórico de edições além do git

## Quando reavaliar

- Catálogo passar de ~50 itens
- Mais de 1 pessoa editando regularmente
- Precisar de rascunho/agendamento de publicação

## Vê também

- [[05-produtos/catalogo]]
- [[11-decisoes/0001-stack-vanilla]]
