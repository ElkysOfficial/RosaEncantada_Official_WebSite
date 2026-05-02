# Catálogo

#produto/catalogo

Fonte de verdade do catálogo (quase) — o catálogo **executável** vive em [[script.js|script.js]]. Ao mudar aqui, sincronizar lá.

> Última sincronização: **2026-05-01**

## Trufas (R$ 6,50–8,50)

| ID | Sabor | Preço | Destaque | Descrição curta |
|----|-------|-------|----------|-----------------|
| `tr-bel` | **Trufa Belga Clássica** | R$ 6,50 | Mais vendida | Ganache de chocolate belga 60% cacau, finalizada com cacau em pó. |
| `tr-mor` | **Trufa de Morango** | R$ 7,00 | — | Recheio cremoso de morango fresco, casca de chocolate ao leite. |
| `tr-pis` | **Trufa de Pistache** | R$ 8,50 | Novidade | Pasta de pistache italiano, casquinha de chocolate branco. |
| `tr-mar` | **Trufa de Maracujá** | R$ 7,00 | — | Polpa fresca em ganache de chocolate branco. |
| `tr-cap` | **Trufa de Café** | R$ 7,00 | — | Espresso intenso em chocolate meio amargo. |

## Bombons (R$ 5,00–5,50)

| ID | Sabor | Preço | Descrição curta |
|----|-------|-------|-----------------|
| `bm-amen` | **Praliné** | R$ 5,50 | Praliné de amêndoas torradas, chocolate ao leite. |
| `bm-coco` | **Coco** | R$ 5,00 | Beijinho cremoso, chocolate branco. |
| `bm-doce` | **Doce de Leite** | R$ 5,50 | Doce de leite caseiro, chocolate ao leite. |

## Caixas presente

| ID | Caixa | Preço | Destaque |
|----|-------|-------|----------|
| `cx-mini` | **Mini Lembrança** (3 trufas) | R$ 16,90 | Lembrancinhas |
| `cx-09`   | **Caixa Encantada · 9** | R$ 49,90 | Presente |
| `cx-16`   | **Caixa Encantada · 16** | R$ 84,90 | — |
| `cx-25`   | **Caixa Encantada · 25** | R$ 129,90 | Premium |

## Como adicionar/remover sabor

1. Abra `script.js`, encontre o array `PRODUCTS`
2. Adicione/remova o objeto seguindo o padrão:
   ```js
   { id: 'tr-xxx', cat: 'trufa', emoji: '🌟', name: 'Nome',
     desc: 'Descrição sensorial.', price: 7.00, badge: 'Opcional' }
   ```
3. Atualize esta tabela aqui no vault
4. Faça upload do `script.js` (apenas ele) para a Hostinger
5. Limpe o LiteSpeed cache no hPanel

## Regras de descrição

- Sempre mencionar **textura** ("cremoso", "aveludado", "crocante")
- Sempre mencionar **chocolate** usado (belga, ao leite, branco, meio amargo)
- Não usar palavras genéricas ("delicioso", "saboroso", "gostoso")
- Limite: **140 caracteres** (cabe no card sem quebrar layout)

## Categorias

- `trufa` — esfera de ganache + cobertura
- `bombom` — recheio cremoso (não-ganache) + cobertura
- `caixa` — embalagem com várias unidades

## Vê também

- [[05-produtos/categorias]]
- [[09-operacoes/processo-producao]]
- [[script.js]]
