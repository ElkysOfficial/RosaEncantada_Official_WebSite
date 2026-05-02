# ADR-0002: Checkout via WhatsApp (sem pagamento online)

#decisao/produto

- **Status:** ✅ Aceita
- **Data:** 2026-04-30

## Contexto

O cliente precisa fechar pedido. Há duas escolas: pagamento online (Stripe/Mercado Pago) ou redirecionamento para conversa humana.

## Decisão

**Toda finalização abre o WhatsApp** com mensagem pré-formatada contendo itens, quantidades e total estimado.

## Razões

- **Encomendas envolvem variáveis** (data, endereço, embalagem) — humano resolve melhor
- **Lorraine é a operação inteira** — ela quer controlar cada pedido
- **WhatsApp já é onde a maioria dos clientes está** no Brasil
- **Zero overhead** de gateway, taxa, conciliação
- Permite **vínculo afetivo** que casa com a marca

## Consequências

✅ Bom:
- Zero custo de gateway
- Atendimento personalizado
- Conversa abre porta para upsell ("posso embalar com cartão?")

⚠️ Atenção:
- Não escala para 50+ pedidos/dia
- Lorraine precisa estar atenta às mensagens
- Sem rastreio automático de "quem abriu o WhatsApp e fechou"

## Trigger para revisão

Quando a operação tiver > 10 pedidos/dia consistentemente, considerar:
- Pagamento online com confirmação automática
- CRM simples (Notion, Airtable, Trello)
- WhatsApp Business API com tagueamento

## Vê também

- [[09-operacoes/encomendas]]
- [[script.js]]
