# ADR-0005: Tema escuro com toggle manual no header

#decisao/design

- **Status:** ✅ Aceita
- **Data:** 2026-05-02

## Contexto

O modo escuro estava como nice-to-have no [[12-tarefas/backlog]] com a dúvida "faz sentido para confeitaria?". Decidiu-se pelo sim porque:

- Maioria dos celulares já roda em dark à noite (quando muita gente faz pedido)
- Fundos cremes puros queimam a vista no escuro
- A paleta da marca (rosa + chocolate) tem âncora suficiente para sobreviver à inversão sem virar genérico

## Decisão

Toggle manual no header (botão sol/lua), persistido em `localStorage` sob a chave `rosa-theme`. Inicialização inline no `<head>` lê a preferência antes do CSS aplicar — evita flash branco.

Implementação por **tokens**: `[data-theme="dark"]` redefine apenas as superfícies (`--creme`, `--rosa-claro/suave/medio`, cinzas, sombras) e o `--text-strong`. As cores de marca (`--choco`, `--choco-soft`, `--rosa-vivo`, `--rosa-deep`, `--rosa-pink`) **não mudam** — são âncoras visuais.

## Alternativas

1. Só `prefers-color-scheme` automático — descartado: usuário precisa controle (ambiente vs. preferência pessoal)
2. Tema único claro — descartado pelas razões acima
3. Tema único escuro — descartado: contradiz o tom acolhedor/cremoso da marca

## Consequências

✅ Bom:
- Marca continua reconhecível em ambos os modos
- Sem flash de tema errado no carregamento

⚠️ Atenção:
- Cada componente novo precisa testar **ambos os modos** — fundos cremes puros viram pretos chapados se esquecidos
- Imagens com fundo branco (futuras fotos de produto) precisarão de tratamento (transparência ou borda) para não destoar no dark
- `meta theme-color` tem duas variantes (`light`/`dark` via `media`), mas o toggle manual não atualiza essa meta — limitação aceita

## Vê também

- [[02-design-system/paleta]]
- [[02-design-system/componentes]]
