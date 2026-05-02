# ADR-0001: Stack vanilla (sem framework)

#decisao/arquitetura

- **Status:** ✅ Aceita
- **Data:** 2026-04-30
- **Decisor:** Lorraine + dev

## Contexto

O site precisa ser uma landing page institucional com catálogo + carrinho + checkout via WhatsApp. Não há backend, não há pagamento online, não há login.

## Opções consideradas

1. **HTML/CSS/JS vanilla** ← escolhida
2. Astro (zero JS por padrão, ótimo para sites de conteúdo)
3. Next.js / SvelteKit (overkill)
4. Plataforma "no-code" (Wix/Squarespace)

## Decisão

**HTML/CSS/JS vanilla, sem build.**

## Razões

- **Simplicidade:** qualquer desenvolvedor júnior consegue ajustar
- **Custo zero de build/CI:** upload direto via FTP
- **Hospedagem barata:** roda em qualquer plano compartilhado
- **Performance excelente** sem otimização agressiva
- **Sem lock-in** de framework

## Consequências

✅ Bom:
- Lighthouse 90+ sem esforço
- Manutenção previsível
- Deploy = upload de arquivos

⚠️ Atenção:
- Se o catálogo passar de ~50 itens, considerar CMS headless
- Se precisar de A/B test de verdade, considerar plataforma

## Vê também

- [[01-architecture/stack-tecnologica]]
- [[11-decisoes/0003-catalogo-em-js]]
