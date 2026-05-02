# Contato

#pagina/contato

A última seção. Onde indecisos viram conversas.

## Objetivo

Reduzir atrito ao primeiro contato. Oferecer múltiplos caminhos (form, WhatsApp direto, e-mail).

## Estrutura

- **Eyebrow** — "Fale com a gente"
- **Título** — "Vamos adoçar o seu *dia*?"
- **Lead** — promessa de resposta rápida
- **Lista** — WhatsApp, Instagram, e-mail, atendimento
- **Form** — nome, e-mail, assunto, mensagem → envia para WhatsApp

## Decisões de copy

- Labels do form em forma de **pergunta**, não comando:
  - "Como podemos te chamar?" em vez de "Nome"
  - "Sobre o que vamos conversar?" em vez de "Assunto"
- Placeholder do textarea convida a contar detalhes ("Data, quantidade, sabores que pensou…")

## Comportamento do form

- Validação client-side (nome, e-mail, mensagem obrigatórios)
- No submit válido → abre WhatsApp com mensagem formatada
- Mensagem de sucesso visível 5s

## Acessibilidade

- Todos os inputs com `<label>` explícito
- Autocomplete (`name`, `email`)
- Focus ring visível no estilo da marca

## Vê também

- [[09-operacoes/encomendas]]
- [[04-conteudo/copy-principal]]
