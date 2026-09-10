# Oficina FEELT — uma casa, duas IAs, trabalho verificável

Material didático de **Matheus Dariva / DarivaBIM**, preparado para a aula de 10/09/2026.
Esta oficina complementa o material UNITRI existente no repositório; ele continua preservado.

**Objetivo:** organizar o acompanhamento de um laboratório didático fictício. Claude prepara
um relatório e uma pauta a partir de fontes curtas; Codex confere as alegações; o professor decide o que
aceitar. A turma registra o estado e testa uma retomada sem repetir toda a conversa.

Todos os fatos, códigos, reuniões e compromissos do caso são **sintéticos**. Não representam
pessoas, decisões, equipamentos ou prazos reais da FEELT/UFU. Não use dados reais de alunos.

## Comece aqui — sem precisar de Git

1. Abra [DarivaBIM/equipe-de-ia](https://github.com/DarivaBIM/equipe-de-ia).
2. Clique em **Code → Download ZIP** e extraia o arquivo pelo Explorador de Arquivos.
3. Crie a pasta `C:\IA-Professor` no seu computador. Se não tiver permissão para criar
   uma pasta em C:, use uma pasta sua em Documentos e substitua o início de todos os caminhos
   nos prompts e comandos, inclusive os guias de verificação e sincronização.
4. Copie **a pasta inteira `oficina-feelt` extraída** para `C:\IA-Professor`.
5. Confirme que existe `C:\IA-Professor\oficina-feelt\casa\AGENTS.md`.
6. Abra **somente `C:\IA-Professor\oficina-feelt\casa`** como projeto no Codex e como
   pasta de trabalho do Claude Code. Evite abrir o repositório inteiro para a demonstração.
7. Use os prompts de `prompts` na ordem abaixo. Se os arquivos de saída já existirem,
   preserve a tentativa anterior e faça uma nova cópia da oficina para recomeçar.

Baixe a versão indicada pelo professor caso a revisão da oficina ainda esteja em uma branch.
O ZIP de uma branch contém o nome da branch na pasta extraída; a pasta interna a copiar
continua sendo `oficina-feelt`.

O Git é opcional. Para quem já usa Git, a alternativa é clonar o repositório e copiar sua
pasta `oficina-feelt` para o mesmo destino. Não é preciso fazer fork, commit ou push na aula.

## Antes da prática

- Prepare os clientes antes da aula pelas instruções oficiais de
  [Claude Code](https://code.claude.com/docs/en/setup),
  [app com Codex](https://learn.chatgpt.com/docs/app) ou
  [Codex CLI](https://learn.chatgpt.com/docs/codex/cli). Entre com sua própria conta;
  não compartilhe credenciais. No app, abra a pasta da casa como projeto local e confira
  `C:\IA-Professor\oficina-feelt\casa` antes de enviar o primeiro pedido.
- O apresentador usa sua própria conta Claude Max e uma conta com acesso ao Codex.
  Assinaturas, limites e acesso dos participantes variam. Não é necessário comprar plano
  para acompanhar: trabalhe em dupla com acesso ou analise a saída preparada em `referencia`.
- Claude Code é o agente que trabalha na pasta local; Claude no navegador tem outra interface.
  No Codex, escolha o projeto local correto. Confirme pasta, instruções e permissões antes de agir.
- Verifique as opções de privacidade na conta real. Max é plano consumidor; usar Code não
  torna o processamento offline. As preferências de treinamento dessa conta também alcançam Code.
- Mantenha documentos de alunos, notas, contatos, credenciais e memória pessoal fora desta pasta.
  O gerente da oficina administra a **casa didática**. Não altere configurações globais reais.

**Alternativa pelo terminal, com os clientes já instalados:** abra o PowerShell e entre na casa.

```powershell
Set-Location -LiteralPath 'C:\IA-Professor\oficina-feelt\casa'
```

Inicie Claude Code nessa janela:

```powershell
claude
```

Para Codex CLI, abra outro PowerShell, repita o `Set-Location` acima e inicie:

```powershell
codex
```

Confirme a pasta e execute P00 em cada cliente. Instalação e login não fazem parte
da tentativa ao vivo; se faltar acesso, use a dupla ou a saída de referência.

## Sequência da oficina

| Etapa | O professor faz | Resultado que a turma confere |
| --- | --- | --- |
| 0. Reconhecer a casa | Abre a pasta e usa `prompts/00-iniciar.md`. | O agente identifica cliente, pasta, papel e fontes. |
| 1. Planejar e avaliar | Usa `prompts/01-avaliar.md` no Claude. | Plano curto, premissas e alternativa, ainda sem relatório. |
| 2. Executar | Usa `prompts/02-executar.md` no Claude. | Relatório, pauta e registro de uso de IA em `casa/gestao`. |
| 3. Revisar com o par | Abre Codex na mesma casa e usa `prompts/03-revisar.md`. | Parecer com fontes; o relatório permanece sem alteração. |
| 4. Confirmar e corrigir | Decide sobre os achados e usa [P03-D](prompts/03c-corrigir-e-registrar.md) com o autor. | Versão verificada após a leitura humana, com as pendências preservadas. |
| 5. Handoff | Pede ao executor para atualizar estado e passagem. | Outro agente entende o próximo passo pelos arquivos. |
| 6. Retomar | Usa `prompts/04-retomar.md` em nova conversa. | Entendimento e pendências corretos antes de executar. |

Um único agente escreve o produto por vez. O revisor escreve apenas seu parecer.
Uma nova janela não é automaticamente um novo papel: a entrada e o pedido precisam
definir responsabilidade, entregas e limites. Papéis não determinam qual marca deve ocupá-los.

### Ver o gerente construir uma frente

O percurso principal parte de uma casa pronta para poupar instalação e permitir recuperação.
Para mostrar construção de fato, use `prompts/00b-construir-frente.md`: gerência cria a
nova frente `casa/artigos`, com CLAUDE.md, AGENTS.md e README próprios, sem mexer nos arquivos
existentes ou nas configurações globais. Depois, abra essa frente e confira as regras herdadas.
Faça esta extensão no fechamento se houver tempo. Ela não exige novo canal ou sincronização.

## Onde está cada coisa

```text
oficina-feelt/
  casa/                  # abrir esta pasta nos agentes
    AGENTS.md            # entrada nativa Codex
    CLAUDE.md            # entrada nativa Claude Code
    regras-comuns.md     # acordos compartilhados e limites
    contexto.md          # objetivo da atividade
    estado-atual.md      # situação recuperável e próximo passo
    handoff.md           # passagem de responsável
    papeis/              # contratos de gerência, gestão e pesquisa
    gerencia/            # decisões da casa didática
    gestao/              # relatório, pauta e registro de uso de IA
    pesquisa/            # parecer e checagem das fontes
    fontes/              # três fontes fictícias curtas
  prompts/               # pedidos completos, prontos para colar
  verificacao/           # checagem factual limitada e seu autoteste
  controle-didatico/     # relatório com dois erros preparados e rotulados
  referencia/            # exemplo já resolvido, separado da tentativa
  FONTES.md              # referências de produtos e ancoragem institucional
```

`referencia` e `controle-didatico` ficam fora de `casa` para não antecipar a resposta ao agente.
Não copie esses diretórios para dentro da casa. Se a geração ao vivo estiver correta, celebre
o resultado e use o controle preparado para mostrar se a revisão detecta erros conhecidos.

## Conferência objetiva

O arquivo `verificacao/README.md` explica como checar a tabela de fatos e testar o controle
preparado. O verificador confere quatro critérios do relatório e, com `-Pauta`, três da pauta;
**não aprova o texto inteiro**,
qualidade pedagógica, privacidade real ou conformidade institucional.

Para concluir, a equipe precisa manter **CAL-02 em andamento e sem data de conclusão**,
registrar **OFI-01 em 18/09/2026 às 14h**, manter **ORC-03 aguardando aprovação**,
ligar cada afirmação à fonte, elaborar perguntas de decisão sem inventar o agendamento
da próxima reunião, declarar uso de IA e permitir uma retomada fiel.

## Extensões depois da aula

Outros usos docentes: consolidar decisões de colegiado, organizar uma revisão bibliográfica,
preparar pautas e pendências de orientação, comparar versões de planos de ensino e organizar
relatórios de projetos. Comece com dados públicos ou sintéticos e uma tarefa verificável.
Novas fontes ou novos objetivos exigem novos critérios; não reutilize o teste desta oficina
como se validasse qualquer relatório.

Consulte o [guia de sincronização](sincronizacao/GUIA-SINCRONIZACAO.md) para a extensão opcional de backup e sincronização.
O núcleo da aula funciona sem essa extensão e sem comunicação automática entre aplicativos.

## Licença e créditos

Conteúdo autoral desta oficina: [CC BY 4.0](../LICENSE), com crédito a Matheus Dariva / DarivaBIM.
Marcas e fontes institucionais pertencem a seus titulares. Os documentos de terceiros citados
não estão incorporados ao kit nem são relicenciados por esta licença.
