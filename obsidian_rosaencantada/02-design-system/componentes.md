# Componentes

#design/componentes

Inventário dos componentes do site, com variações e regras.

## Botões

| Variante | Uso | Classe |
|----------|-----|--------|
| Primary | CTAs principais (1 por seção) | `.btn--primary` |
| Ghost | CTAs secundários | `.btn--ghost` |
| Block | Largura total (formulários) | `.btn--block` |

**Regra do CTA único**: cada seção tem **um** botão primary. Múltiplos primaries em campo = nenhum se destaca.

**Comportamento**: efeito magnético sutil seguindo o cursor (desktop), `translateY(-3px)` no hover, gradiente primário invertido para choco.

## Cards

- **`.product`** — catálogo de sabores. Hover: lift 8px + zoom no emoji + sombra XL.
- **`.feature`** — destaque na seção Sobre. Hover: desliza 6px à direita.
- **`.testimonial`** — depoimentos. Hover: lift 6px + aspas mais visíveis.
- **`.encomendas__card`** — kits/personalizado/eventos. Hover: desliza 8px + borda esquerda engrossa.
- **`.step`** — passos do processo. Hover: número numérico ganha cor.

## Floating cards (hero)

3 cards (`+500 clientes`, `★ 5,0`, `72h frescor`). Animação `bob` infinita, parallax sutil seguindo o mouse.

## Drawer (carrinho)

- Abre da direita, 440px desktop, 100% mobile
- Overlay com blur(4px)
- Focus trap ativo
- Fecha em ESC, click no overlay ou X (que rotaciona 90°)

## Toast

- Aparece bottom-right (acima do floating WhatsApp)
- 2.6s de duração
- Borda esquerda rosa, ícone ✓ rosa
- Acessível: `role="status" aria-live="polite"`

## Header

- Sticky, blur(16px)
- Encolhe ao rolar (`is-scrolled` class)
- Scroll-spy ativa link da seção visível
- **Theme toggle** (`#themeToggle`): botão sol/lua à direita do nav. Click alterna `data-theme` no `<html>` e persiste em `localStorage['rosa-theme']`. Ver [[11-decisoes/0005-tema-escuro-com-toggle]].

## Marquee

Faixa entre Hero e Sobre, choco com selos rolando: "Feito à mão • Chocolate belga • Recheios cremosos…"

## Loader

- Logo girando
- Aparece no `is-loading`, sai com fade no `load`
- Fallback de 2.2s caso `load` demore

## Estados de foco

- Outline 2.5px sólido rosa-vivo
- Offset 3px
- Border-radius 4px

## Vê também

- [[02-design-system/paleta]]
- [[02-design-system/tipografia]]
- [[03-paginas/hero]]
