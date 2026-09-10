# Começar na web: uma pequena equipe para os processos docentes

**FEELT-WEB-1 · 10/09/2026 · Matheus Dariva / DarivaBIM**

Comece pelo navegador. Você vai preparar uma pauta curta, conferir suas fontes em outra conversa,
decidir o que aceita e deixar um registro para continuar. A prática é **individual**, com duração
planejada de **12–15 minutos**, e não exige instalação na aula. [Licença e crédito](../LICENSE).

O caso é inteiramente fictício. Não use documentos, notas ou dados reais de alunos. A IA apoia
processos docentes; o professor mantém a decisão e a conferência. [Referências e limites](FONTES.md).

## Abra apenas o necessário

1. Abra uma conversa em [ChatGPT](https://chatgpt.com) e outra em [Claude](https://claude.ai), usando
   suas próprias contas, se houver acesso. Não precisa comprar plano para acompanhar.
2. Identifique a primeira como **Produção — documentos** e a segunda como **Conferência — fontes**.
   Se não puder renomear, escreva o papel na primeira mensagem e confira a resposta.
3. Abra e salve [equipe e acordos](equipe.md) e [fontes sintéticas](fontes-do-caso.md).
   Se a interface permitir, anexe os dois arquivos em cada conversa e use a
   [preparação curta P00-ANEXOS](prompts/00-preparar-com-anexos.md). Selecione Produção ou Conferência.
4. Sem anexos, use [P00 completo](prompts/00-preparar-conversa.md) ou os textos prontos abaixo.
   Copie somente o bloco do prompt; substitua os campos entre colchetes pelo material indicado.
   O navegador não lê uma pasta do disco porque você escreveu seu endereço.

**Cópia mais fácil:** abra [a preparação pronta de Produção](copiar/P00-PRODUCAO.txt) ou
[a preparação pronta de Conferência](copiar/P00-CONFERENCIA.txt), selecione todo o texto e cole
na conversa correspondente. Elas já incluem os acordos e as três fontes sintéticas.
Os [demais textos para copiar](copiar/README.md) seguem os IDs da aula. Campos entre colchetes
nos pedidos de revisão, correção e decisão precisam ser preenchidos pelo professor.

**Sem anexo ou com limite de upload:** copie o texto das fontes para a mensagem e preserve F1/F2/F3
e os itens. Se o texto for longo, divida em partes numeradas e peça que aguarde "FIM DAS FONTES".
Não transforme limite de acesso em permissão para inventar conteúdo.

**Com arquivos:** a interface pode permitir PDF, documento de texto, planilha, CSV, imagem ou outros
formatos. Use somente os formatos aceitos naquela conta e confira o que foi efetivamente lido.
Para uma tabela, prefira texto/CSV com cabeçalhos; para imagem, confira números e caracteres na
fonte. Se não conseguir ler, use a transcrição conferida. Um upload concluído não prova leitura correta.

## Prática individual

| Etapa | Ação | Resultado observável |
|---|---|---|
| 1 · 2 min | Leia o caso e os [acordos](equipe.md). O professor faz a gerência da própria tarefa. | Finalidade, dados permitidos e critérios claros |
| 2 · 4 min | No ChatGPT, use [P10 Produzir](prompts/10-produzir.md). | Rascunho de pauta com até 180 palavras, três fatos e duas perguntas |
| 3 · 3 min | No Claude, forneça o produto identificado como V1, as mesmas fontes e [P20 Conferir](prompts/20-conferir.md). | Parecer de até 120 palavras, com evidências |
| 4 · 3 min | Leia o parecer e use [P21](prompts/21-avaliar-parecer.md) se precisar organizar a decisão. Escolha a correção abaixo. | Aceitação ou rejeição dos achados com motivo |
| 5 · até 3 min de margem | Registre com [P30](prompts/30-decidir-e-registrar.md). Se houver tempo, teste [P40](prompts/40-retomar.md). | Decisão, autoria, versão e próximo passo preservados |

Os tempos são orçamento didático, não latência garantida dos modelos. Se faltar tempo, preserve
a leitura humana e o registro; faça a nova revisão/retomada depois, marcada como pendente.
Na aula conduzida, parte da prática acontece ao longo da explicação. O bloco final de seis
minutos pode concluir o trabalho já iniciado; os 12–15 minutos são o percurso autônomo completo.

## Corrigir e conferir a versão nova

**Caminho A — recomendado para começar:** leve os achados aceitos ao autor com
[P22 Corrigir com o autor](prompts/22-corrigir-com-autor.md). Ele cria V2; o outro cliente usa
[P24](prompts/24-revisar-correcao.md) para rever V2. O autor pode se autoconferir, mas isso não fecha
a revisão independente.

**Caminho B — alternativa demonstrada:** com autorização explícita, use
[P23 Corrigir com o revisor](prompts/23-corrigir-com-revisor.md). O revisor agora é autor de V2.
Leve V2 ao primeiro cliente com P24. O cliente que corrigiu não aprova sua própria alteração.
O professor confere e decide ao final em ambos os caminhos.

Se nenhum erro for encontrado, registre esse resultado com seu recorte. Não fabrique defeito
para justificar a segunda IA. Para estudar erros conhecidos, use o
[controle preparado](../controle-didatico/relatorio-com-erros.md), identificado como tal e separado
do produto ao vivo. O controle tem outro formato; confira suas afirmações, sem chamá-lo de saída de P10.

## Aprender a construir o pedido

São alternativas sobre o mesmo caso; **não é necessário executar todas** na prática individual.

| ID | Forma do pedido | O que observar |
|---|---|---|
| [E01](prompts/01-pedido-comum.md) | Pedido comum | O que ficou implícito |
| [E02](prompts/02-pedido-estruturado.md) | Objetivo, contexto, fontes, saída e limites | O que torna o resultado conferível |
| [E03](prompts/03-pedido-com-exemplo.md) | Um exemplo de formato | Exemplo ensina forma; não fornece fatos do caso |
| [E04](prompts/04-pedido-em-etapas.md) | Duas mensagens com decisão no meio | Analisar antes de produzir |
| [E05](prompts/05-direcao-aberta.md) | Convite à crítica e alternativa | Desancorar a avaliação sem garantir qualidade |
| [E06](prompts/06-corpo-padrao.md) | Corpo com campos para adaptar | Repetir o método em outro processo |

## Se não houver acesso a duas IAs

Com uma IA, faça a conferência humana em outra leitura e registre essa condição. Duas conversas
no mesmo serviço não demonstram revisão entre modelos diferentes. Sem acesso, confira o
[exemplo resolvido](exemplo-pauta.md) contra as fontes; não o apresente como geração ao vivo.
A entrega individual continua sendo uma conferência com fonte, uma lacuna preservada e uma decisão.

## Continuar depois

Para ver a Gerência organizar frentes permanentes, use [G01](prompts/07-organizar-frentes.md).
O apresentador pode demonstrá-la; o participante não precisa abrir uma terceira conversa
para concluir a prática individual.

- [Continuar na web](continuar.md): guardar o registro, fornecer a versão correta e retomar em outra conversa.
- [Conhecer a pasta local](local-opcional.md): o mesmo método com arquivos, Claude Code e Codex, em ambiente preparado.
- [Oficina local original](../README.md): relatório completo, scripts e sincronização opcionais preservados.

O GitHub distribui o kit público. Ele não recebe seus dados ou seus resultados reais. O registro
de passagem não dispara o outro aplicativo. A ponte automática é uma proposta posterior, com
autorização, versão, recibos e prova próprias.
