# Paleta de cores

#design/paleta

A paleta foi extraída da logo. Tom dominante: rosa acolhedor com âncora em chocolate.

## Tokens (CSS custom properties)

| Token | Hex | Uso |
|-------|-----|-----|
| `--rosa-claro` | `#fdeef2` | Fundos amplos, áreas de respiro |
| `--rosa-suave` | `#fbd5dd` | Bordas, divisores, gradientes |
| `--rosa-medio` | `#f7c6d3` | Hovers, blobs decorativos |
| `--rosa-pink`  | `#e87a9a` | Detalhes, acentos secundários |
| `--rosa-vivo`  | `#d6336c` | **Cor primária** — CTAs, links, destaques |
| `--rosa-deep`  | `#b1264e` | Estados ativos, gradiente do primary |
| `--choco`      | `#4a2418` | **Texto principal**, footer, contrastes fortes |
| `--choco-soft` | `#6b3525` | Texto secundário em rosa-claro |
| `--creme`      | `#fffaf7` | Background do site |
| `--creme-warm` | `#fcf3ec` | Cards alternativos |
| `--cinza-100`  | `#f5eef0` | Bordas suaves |
| `--cinza-300`  | `#d9c9cd` | Placeholders |
| `--cinza-500`  | `#8a7479` | Texto secundário |
| `--cinza-700`  | `#4a3a3d` | Texto corpo |
| `--gold`       | `#c69963` | Estrelas de avaliação, selos |

## Princípios de uso

- **Rosa-vivo nunca em texto longo** — só em CTAs, links e palavras-chave
- **Choco como texto-base**, nunca preto puro
- **Creme como fundo padrão**, nunca branco puro
- **Gradiente primário**: rosa-vivo → rosa-deep (135deg)
- **Sombras tingidas**: sempre baseadas em choco com baixa opacidade

## Tema escuro

`[data-theme="dark"]` redefine apenas superfícies e texto-base — as cores de marca (`--rosa-vivo`, `--rosa-deep`, `--rosa-pink`, `--choco`, `--choco-soft`) **não mudam**. Bases viram tons profundos de vinho/chocolate (não pretos chapados): `--creme: #1a1216`, `--rosa-claro: #2a1d22`, `--text-strong: #fbeae3`. Persistência em `localStorage['rosa-theme']`. Ver [[11-decisoes/0005-tema-escuro-com-toggle]].

## Acessibilidade

- choco sobre creme: contraste **13.4:1** ✓ AAA
- rosa-vivo sobre creme: contraste **4.7:1** ✓ AA
- rosa-vivo sobre branco: contraste **4.5:1** ✓ AA (limite)

> **Atenção**: nunca colocar texto rosa-vivo sobre rosa-claro — falha em WCAG.

## Vê também

- [[02-design-system/tipografia]]
- [[02-design-system/componentes]]
