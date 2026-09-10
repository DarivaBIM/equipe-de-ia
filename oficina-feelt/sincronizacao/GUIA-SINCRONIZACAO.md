# Da sala dos professores ao notebook

Se você instalou a oficina em Documentos ou em outra pasta, **substitua o início de todos os caminhos deste guia**, inclusive nos comandos, no Agendador e no notebook. O endereço no `-RepoPath` deve ser a raiz real da sua `casa`; ele não muda automaticamente quando você muda a pasta.

Esta extensão continua o mesmo caso da oficina. As regras, as fontes permitidas, o resultado revisado e o registro do próximo passo acompanham o professor. Claude e Codex leem esses arquivos na outra máquina.

**Na aula, faremos uma SIMULAÇÃO LOCAL.** Duas pastas representam os computadores; uma terceira funciona como destino Git local. Não há duas máquinas reais, internet, credenciais ou instalação de tarefa agendada nessa prova.

**Depois da aula, o agendamento opcional transporta versões que você já revisou e registrou em um commit.** Ele não faz commit automático de tudo o que a IA escreveu. O caso Dariva tem um mecanismo próprio de auto-commit; esse mecanismo não foi copiado para o laboratório.

## 1. Entenda o que viaja

| Peça | Como funciona |
| --- | --- |
| Instruções e papéis | `CLAUDE.md`, `AGENTS.md`, regras e identidades são arquivos do projeto. Os dois clientes precisam ler os arquivos pertinentes. |
| Estado e handoff | Registram decisão, fontes, resultado verificado e próximo passo. Uma conversa nova deve abrir e interpretar esses arquivos. |
| Aplicativos e ferramentas | Claude Code, Codex, Git e outras dependências precisam estar instalados em cada computador. |
| Identidade e permissões | O login é feito em cada máquina. Senhas, tokens e credenciais não entram no repositório. |
| Janelas em execução | Não são transportadas. Uma janela nova retoma pelos registros; a sincronização não move uma sessão viva. |

O destino real deve ser privado ou institucionalmente autorizado para aquele conteúdo. **Um repositório privado não torna automaticamente permitido enviar dados institucionais a ele.** A oficina contém somente dados sintéticos. Não copie as pastas internas inteiras `.claude` ou `.codex` do seu usuário para tentar transportar a casa.

## 2. Faça a prova de cinco minutos

Abra o PowerShell pelo menu Iniciar. O kit deve ter sido copiado para `C:\IA-Professor\oficina-feelt`, conforme o guia principal. Execute:

```powershell
powershell.exe -NoProfile -File "C:\IA-Professor\oficina-feelt\sincronizacao\Demonstrar-Sync.ps1"
```

O programa cria uma pasta nova em `C:\IA-Professor\oficina-feelt\sincronizacao\provas-locais`. Ele imprime o caminho exato da prova. Dentro dela aparecem `computador-sala`, `remoto-local.git` e `notebook-local`.

| # | O que acompanhar | Como conferir |
| --- | --- | --- |
| 1 | A base usa somente instruções e um estado sintético. | A abertura informa **SIMULAÇÃO LOCAL**. |
| 2 | Um novo registro recebe o marcador `FEELT-RETOMADA-01`. | O envio mostra `sent` e `REMOTE_MAIN_CONFIRMED`. |
| 3 | A pasta que representa o notebook recebe a versão. | O recebimento mostra `received`; a referência Git é igual nas três pontas. |
| 4 | Um arquivo fictício é mantido fora da seleção. | O teste confirma que `dados-restritos.txt` não aparece no destino. |
| 5 | Você abre o estado no notebook simulado. | O marcador e o próximo passo estão presentes. Um arquivo JSON registra os resultados. |

Essa prova mede transporte de arquivos. Ela não mede login, acesso ao GitHub, tempo de rede, leitura por um segundo aplicativo ou funcionamento em outro computador. Para validar a retomada por IA, abra uma conversa nova na pasta de destino e peça que leia as instruções e o estado antes de agir.

Para executar também os cenários de falha preparados:

```powershell
powershell.exe -NoProfile -File "C:\IA-Professor\oficina-feelt\sincronizacao\Demonstrar-Sync.ps1" -TestarFalhas
```

As falhas esperadas são testes: arquivo ainda não aprovado, destino local inexistente, pausa, redirecionamento de destino e duas edições divergentes. O programa preserva os arquivos. A simulação de falhas termina com duas versões divergentes preservadas, para mostrar por que o automático deve parar.

Se um teste falhar de verdade, guarde a mensagem e o caminho da pasta de prova. Quando essa pasta existe e permite escrita, o programa grava `resultado.json` com `passed: false`, os casos já executados e a falha. Se nem a pasta puder ser criada ou o registro não puder ser escrito, a mensagem no terminal continua sendo a evidência disponível. As provas locais ficam fora da seleção de publicação do kit pelo `.gitignore` da oficina.

## 3. Prepare a casa real em um destino autorizado

Esta parte é opcional, depois de compreender a prova local. Ela faz alterações no seu Git e, nos comandos de envio, no destino que você escolher. O kit público da oficina não recebe o seu trabalho real.

Pré-requisitos: Git disponível, identidade de autoria configurada para os commits, acesso ao destino autorizado e cópia própria do kit fora de um clone público. O guia principal usa download ZIP ou cópia da pasta `oficina-feelt`; assim `casa` ainda não está dentro de outro repositório Git.

A raiz a versionar é **somente** `C:\IA-Professor\oficina-feelt\casa`. Os scripts ficam fora dela, em `C:\IA-Professor\oficina-feelt\sincronizacao`.

| # | O que fazer | Como confirmar |
| --- | --- | --- |
| 1 | Confira se o conteúdo é sintético ou autorizado para o destino escolhido. Defina uma pessoa responsável pela escrita de cada projeto. | Não há dado de aluno, senha ou documento institucional restrito no pacote. |
| 2 | Crie um repositório vazio privado na sua conta ou use o serviço institucional aprovado. No GitHub, escolha **Private** e não gere README inicial. | Você conhece a URL exata e conferiu a visibilidade. Essa decisão é feita por você; o script não consulta a política da instituição. |
| 3 | Inicialize apenas a pasta `casa`, com C1. Se ela já for um repositório, confira o destino e preserve o trabalho existente antes de continuar. | C2 devolve a própria pasta `casa`, sem subir para um repositório público ancestral. |
| 4 | Selecione os arquivos iniciais com C3 e examine o conteúdo com C4. | A seleção contém apenas o molde e fontes sintéticas. `.gitignore` é uma ajuda; a revisão do conteúdo continua necessária. |
| 5 | Crie o primeiro registro com C5 e adicione o destino com C6. Substitua a URL de exemplo pela sua URL autorizada, sem token. | Nenhuma senha é colada no comando. O login, quando necessário, ocorre no fluxo normal da ferramenta. |
| 6 | Envie a base com C7. | O envio conclui; você confere a versão no destino correto. |

**C1 — iniciar o repositório da casa:**

```powershell
git init -b main -- "C:\IA-Professor\oficina-feelt\casa"
```

**C2 — conferir a raiz antes de selecionar arquivos:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" rev-parse --show-toplevel
```

**C3 — selecionar somente os arquivos iniciais conhecidos:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" add -- .gitignore AGENTS.md CLAUDE.md regras-comuns.md contexto.md estado-atual.md handoff.md papeis/gerencia.md papeis/gestao.md papeis/pesquisa.md fontes/01-reuniao-sintetica.md fontes/02-calendario-sintetico.md fontes/03-nota-tecnica-sintetica.md gerencia/README.md gestao/README.md pesquisa/README.md
```

**C4 — ler o que entrará no registro:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" diff --cached
```

**C5 — registrar a base que você conferiu:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" commit -m "Base didatica revisada do meu ecossistema"
```

**C6 — apontar para o SEU destino autorizado; substitua a URL:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" remote add origin "https://github.com/SEU-USUARIO/meu-ecossistema-professor.git"
```

**C7 — enviar a base conscientemente:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" push -u origin main
```

Se faltar algum arquivo, o Git pedir identidade, a autenticação falhar ou o destino divergir, pare nesse passo. Não use comandos de descarte, envio forçado ou mudança global de política para vencer a mensagem.

## 4. Antes de trocar de computador

Primeiro, encerre a escrita no projeto. Confira o relatório contra as fontes. Quando decidir que a versão está adequada para continuar **esta oficina**, salve a cópia em `C:\IA-Professor\oficina-feelt\casa\gestao\relatorio-verificado.md`. O nome significa conferência do professor; não significa homologação institucional. Confira também a pauta.

Peça o checkpoint/handoff **apontando para a cópia verificada e para a pauta**. Confira esses caminhos: o notebook não receberá o rascunho local. O pacote precisa levar tanto o registro do próximo passo quanto os arquivos aos quais ele se refere.

Escolha uma das duas seleções. **A — produtos já registrados; somente estado e handoff mudaram:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" add -- estado-atual.md handoff.md
```

**B — primeira passagem do caso completo; os produtos também precisam entrar:**

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" add -- gestao/relatorio-verificado.md gestao/pauta-reuniao.md gestao/registro-uso-ia.md estado-atual.md handoff.md
```

Se houver outro produto revisado, acrescente **o caminho exato desse produto** à seleção antes do commit. O arquivo deve constar em `arquivos-permitidos.json`. O relatório ainda em rascunho não está incluído por padrão. Se não houver mudanças, não é necessário criar um commit vazio.

Depois da seleção escolhida, examine o conteúdo completo que será registrado:

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" diff --cached
```

Registre somente depois de conferir esse conteúdo:

```powershell
git -C "C:\IA-Professor\oficina-feelt\casa" commit -m "Produto, estado e passagem revisados pelo professor"
```

Execute o transporte e confira o resultado. Use a mesma URL autorizada da preparação:

```powershell
powershell.exe -NoProfile -File "C:\IA-Professor\oficina-feelt\sincronizacao\Sync-Casa.ps1" -RepoPath "C:\IA-Professor\oficina-feelt\casa" -AuthorizedRemote "https://github.com/SEU-USUARIO/meu-ecossistema-professor.git"
```

O script exige a branch `main`, raiz exata, caminhos permitidos no estado examinado e nos commits deste transporte, pasta sem alterações pendentes e destino efetivo igual ao informado. Ele não descarta arquivos, não faz rebase e não combina duas linhas de trabalho divergentes. O mutex coordena instâncias locais desse script; **não impede dois professores ou duas IAs de editar o mesmo arquivo**. Por isso a regra de um escritor por projeto continua necessária.

| Resultado | Significado e ação |
| --- | --- |
| `sent` | O destino confirmou o identificador da versão enviada. Confira o campo `commit`. |
| `received` | A pasta local chegou à versão que foi recebida do destino. |
| `skip / ALREADY_EQUAL` | As referências comparadas já eram iguais naquele momento. |
| `skip / PAUSED` | A pausa local está ativa. |
| `skip / LOCK_BUSY` | Outra instância local está trabalhando. |
| `error / E_DIRTY...` | Há mudanças ou arquivos novos não ignorados. Revise e registre, ou mantenha o projeto pausado. |
| `error / E_DIVERGED...` | Os dois lados têm alterações próprias. Preserve os dois e resolva com uma pessoa responsável. |
| `error / E_PATH...` | Existe arquivo fora da lista aprovada no estado atual ou nos commits deste envio. Confira antes de mudar a lista. |
| `error / E_EFFECTIVE_REMOTE...` | A URL efetiva do Git difere da autorizada, por exemplo por uma regra de redirecionamento. O transporte foi interrompido antes do envio. |
| Outro `error` | Não há confirmação suficiente. Verifique a mensagem, o destino e o estado; não declare a sincronização concluída. |

O código de saída é `0` para operação normal ou pausa/ausência de mudança e `1` para erro. Os registros ficam em `C:\IA-Professor\oficina-feelt\casa\.git\sync-casa.log`; a pausa fica em `.git`, e nenhum dos dois é transportado. Um envio confirmado ainda não prova que o notebook recebeu a versão.

## 5. No notebook

Instale e autentique os aplicativos necessários. Do kit, copie **APENAS a pasta `sincronizacao`** para `C:\IA-Professor\oficina-feelt\sincronizacao`. A pasta `casa` será trazida do seu destino autorizado, pelo clone abaixo.

Se você já copiou a oficina inteira e `casa` existe, feche os agentes abertos nela e preserve essa pasta com outro nome antes de clonar. O comando seguinte muda apenas o nome da pasta no mesmo local, sem apagar seu conteúdo:

```powershell
Rename-Item -LiteralPath "C:\IA-Professor\oficina-feelt\casa" -NewName ("casa-preservada-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
```

Confira no Explorador que a pasta preservada contém seus arquivos. Se a renomeação falhar, pare; não substitua nem apague a pasta. Se houver trabalho local importante, compare-o depois com a versão recebida, antes de descartar qualquer cópia. Execute o clone somente quando **o destino `casa` não existir**:

```powershell
git clone "https://github.com/SEU-USUARIO/meu-ecossistema-professor.git" "C:\IA-Professor\oficina-feelt\casa"
```

Nos usos seguintes, rode `Sync-Casa.ps1` com o mesmo comando da seção anterior **antes de abrir os agentes para escrever**. Confira a versão e abra Claude ou Codex na pasta `casa`. Peça a leitura das instruções, do estado e do handoff; confirme o próximo passo antes de executá-lo.

Ao sair do notebook, repita o registro revisado e o envio. Evite deixar duas máquinas editando o mesmo projeto ao mesmo tempo. Quando houver dúvida, pause o automático e compare os registros.

## 6. Agendamento opcional a cada 15 minutos

**Só configure depois de uma ida e volta manual funcionar nas duas máquinas.** Estes passos não são executados pela oficina. O agendamento será criado localmente por você, uma vez em cada computador.

Quinze minutos é o intervalo entre tentativas. A máquina pode estar desligada, sem rede ou com trabalho pendente. O intervalo não é prazo garantido de chegada. Para sair imediatamente para a aula, rode manualmente e confira as duas pontas.

| # | O que fazer no Windows | Como confirmar |
| --- | --- | --- |
| 1 | Abra Iniciar, procure **Agendador de Tarefas** e escolha **Criar Tarefa**. Nome: `Professor-SyncCasa`. | É uma nova tarefa sua; nenhuma tarefa Dariva é alterada. |
| 2 | Em Geral, escolha executar somente quando seu usuário estiver conectado, sem privilégios elevados. | O processo usa o seu acesso normal ao Git. |
| 3 | Em Disparadores, crie um início diário. Em opções avançadas, repita a cada **15 minutos**, por tempo **indefinido**. | O disparador está habilitado com repetição de 15 minutos. |
| 4 | Em Ações, escolha Iniciar um programa. Use o programa e os argumentos abaixo, substituindo a URL pela sua. | Caminhos e URL correspondem exatamente ao teste manual. |
| 5 | Em Configurações, permita execução sob demanda; se a tarefa já estiver em execução, escolha **não iniciar uma nova instância**. Defina interrupção após cinco minutos. | Um processo pendurado não acumula uma fila de sincronizadores. Interrupção por tempo exige verificar o estado antes de repetir. |
| 6 | Salve, selecione a tarefa e clique em Executar. Confira o registro do script. | Um resultado `sent`, `received` ou `ALREADY_EQUAL` descreve o que ocorreu. Resultado 0 do Agendador, sozinho, não prova chegada no notebook. |
| 7 | Na outra máquina, execute manualmente e confira o mesmo identificador de versão. | Só agora há prova de ida e volta entre as máquinas reais. |

**Programa:**

```text
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

**Argumentos, substituindo a URL de exemplo:**

```text
-NoProfile -NonInteractive -WindowStyle Hidden -File "C:\IA-Professor\oficina-feelt\sincronizacao\Sync-Casa.ps1" -RepoPath "C:\IA-Professor\oficina-feelt\casa" -AuthorizedRemote "https://github.com/SEU-USUARIO/meu-ecossistema-professor.git"
```

Se o Windows ou a política institucional impedir a execução, pare e confira a mensagem com o suporte responsável. Este guia não pede mudança global de segurança nem elevação administrativa.

## 7. Pausar, conferir e retomar

Pausar o transporte nesta máquina, sem alterar o agendamento:

```powershell
powershell.exe -NoProfile -File "C:\IA-Professor\oficina-feelt\sincronizacao\Sync-Casa.ps1" -RepoPath "C:\IA-Professor\oficina-feelt\casa" -Mode Pause
```

Conferir a pausa e o último registro:

```powershell
powershell.exe -NoProfile -File "C:\IA-Professor\oficina-feelt\sincronizacao\Sync-Casa.ps1" -RepoPath "C:\IA-Professor\oficina-feelt\casa" -Mode Status
```

Depois de resolver a causa e conferir a pasta, retirar a pausa:

```powershell
powershell.exe -NoProfile -File "C:\IA-Professor\oficina-feelt\sincronizacao\Sync-Casa.ps1" -RepoPath "C:\IA-Professor\oficina-feelt\casa" -Mode Resume
```

Você também pode abrir o Agendador, selecionar `Professor-SyncCasa` e escolher **Desabilitar**. Nenhum comando deste guia apaga a tarefa ou descarta trabalho.

**Se falhar:** preserve os dois lados, anote a mensagem e o último `commit` confirmado. Não sobrescreva uma máquina com a outra para esconder a divergência.

## Limites da demonstração

O script não classifica conteúdo sensível, não verifica a política institucional ou a visibilidade do serviço, não instala clientes, não autentica contas e não resolve conflitos. A lista de caminhos limita envio e aplicação ao diretório de trabalho; a revisão humana limita o conteúdo. Para examinar mudanças recebidas, o Git primeiro baixa o histórico remoto: mesmo uma mudança recusada pode ter objetos guardados em `.git`. Use um destino confiável, próprio ou autorizado, e não trate a lista como filtro de download. A prova local usa um único Windows e Git local. A instalação agendada e a transferência real entre computadores precisam ser confirmadas no ambiente de quem vai usá-las.
