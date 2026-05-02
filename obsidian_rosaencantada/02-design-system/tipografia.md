# Tipografia

#design/tipografia

Três famílias, papéis bem definidos. Nunca usar uma para função da outra.

## Famílias

| Família | Uso | Token CSS |
|---------|-----|-----------|
| **Playfair Display** | títulos de seção, marca, números (preço) | `--f-display` |
| **Dancing Script** | acentos manuscritos — palavras "encanto", "afeto", eyebrows | `--f-script` |
| **Inter** | corpo de texto, UI, labels, botões | `--f-body` |

## Pesos disponíveis

- Playfair: 500, 600, 700
- Dancing: 600, 700
- Inter: 300, 400, 500, 600

## Hierarquia

| Nível | Tamanho | Família | Peso | Uso |
|-------|---------|---------|------|-----|
| H1 hero | `clamp(2.6rem, 5.8vw, 4.4rem)` | Playfair | 600 | Título principal do hero |
| H2 seção | `clamp(2.1rem, 4.2vw, 3rem)` | Playfair | 600 | Cada seção |
| H3 card | `1.05–1.22rem` | Playfair | 600 | Títulos de produto, feature |
| Lead | `1.05–1.08rem` | Inter | 400 | Parágrafo de abertura |
| Body | `1rem` | Inter | 400 | Texto corrente |
| Eyebrow | `1.35rem` | Dancing | 700 | Pré-título de cada seção |
| Preço | `1.4–1.7rem` | Playfair | 600 | Sempre destacado |
| Label/UI | `.78–.92rem` | Inter | 500/600 | Botões, labels, tags |

## Padrão de mistura "Playfair + Dancing"

A marca constrói voz misturando serifa elegante e manuscrito caloroso. Receita visual:

> **Pequenos** *encantos* **de chocolate.**
> ╰── Playfair ──╯  ╰── Dancing ──╯  ╰── Playfair ──╯

Use `<em>` no HTML para a parte manuscrita e estilize via CSS:

```css
.hero__title em {
  font-family: var(--f-script);
  font-style: normal;
  color: var(--rosa-vivo);
}
```

## Regras

- Nunca Dancing em texto longo (ilegível)
- Nunca Playfair em UI (botões, inputs, labels)
- Letter-spacing negativo (`-.02em`) em títulos grandes
- Line-height: `1.7` no body, `1.15` em títulos
- Sempre `font-display: swap` no Google Fonts

## Vê também

- [[02-design-system/paleta]]
- [[04-conteudo/tom-de-voz]]
