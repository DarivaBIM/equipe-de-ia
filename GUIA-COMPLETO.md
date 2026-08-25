# 📖 Guia completo: do computador vazio ao sistema funcionando

Este guia acompanha a pasta [`sistema-inicial/`](sistema-inicial/) e explica, para quem nunca
programou, a jornada: o que instalar, os termos do caminho, o que configurar e em que ordem.
Leia de cima para baixo; ninguém precisa decorar nada.

Uma regra de leitura: **os termos técnicos são explicados ao longo do caminho**, e há um
vocabulário no fim. Se algum escapar, pergunte ao próprio Claude: explicar faz parte do
trabalho dele.

---

## Parte 1 · O que instalar (o kit)

### 1.1 O terminal (você já tem)

**O que é:** o terminal é uma janela onde você conversa com o computador por texto: digita um
comando, ele responde. Existe desde antes das janelas e dos ícones, e é onde o Claude Code
mora.

No Windows, procure **"Terminal"** no menu Iniciar (⊞). Ele já vem instalado. Dois comandos
para começar:

| Comando | O que faz | Exemplo |
|---|---|---|
| `cd` | Entra numa pasta ("change directory") | `cd C:\meu-negocio\clientes` |
| `claude` | Abre o Claude Code na pasta em que você está | `claude` |

Dica de conforto: segure Ctrl e aperte + para aumentar a fonte.

### 1.2 O Claude Code

**O que é:** o assistente de IA da Anthropic que roda no terminal e trabalha DENTRO das suas
pastas: lê arquivos, escreve arquivos, executa tarefas. É diferente do chat no navegador
justamente por isso: ele trabalha onde o seu trabalho mora.

**Instalar:** siga o guia oficial em `claude.com/claude-code` (o site orienta o download e o
login com a sua conta). Ao final, o teste é: abrir o terminal, digitar `claude` e ver o
assistente responder.

### 1.3 O Git

**O que é:** o Git é o caderno de mudanças do seu sistema. No fechar o dia, o ritual PROPÕE
guardar o estado dos arquivos numa fotografia (um *commit*): a IA mostra a lista do que vai
entrar, e a fotografia só acontece com o seu OK. Uma imagem que usamos muito: **as regras que
você escreve são a cerca; o Git é a câmera e o botão de desfazer.** Ele não impede um erro de
acontecer; ele torna reversível tudo o que já foi fotografado, e é essa rede que autoriza dar
liberdade à IA para trabalhar.

O limite, com todas as letras: o Git só protege o que entrou numa fotografia. Enquanto você
não aprova o passo final do fechar o dia, nada entrou no histórico ainda. Arquivo criado e
nunca registrado não tem para onde voltar; e o que acontece FORA da pasta (um e-mail enviado,
um arquivo apagado noutro canto do computador) ele não desfaz. É por isso que o ritual de
fechar o dia termina propondo guardar tudo no histórico: a proteção existe depois que você
aprova esse passo.

Sem o Git, o diário e os arquivos existem, mas sem histórico: um arquivo sobrescrito por engano
está perdido. Com o Git, voltar a qualquer versão já fotografada é um comando.

**Instalar:** baixe em `git-scm.com` (botão de download, instalação padrão, próximo em tudo).
Depois, no terminal, o pré-voo de identidade (o Git identifica o autor de cada registro com um
nome e um e-mail):

```
git --version
git config --global --get user.name
git config --global --get user.email
```

Se os dois `--get` já mostrarem os seus dados, pronto. Se vierem vazios, grave os SEUS
(troque pelos seus de verdade):

```
git config --global user.name "AQUI O SEU NOME"
git config --global user.email "aqui-o-seu@email.com"
```

---

## Parte 2 · A pasta do sistema

Copie a pasta [`sistema-inicial/`](sistema-inicial/) deste repositório para a raiz do seu disco,
com um nome curto e sem espaços. Exemplo: `C:\meu-negocio`.

⛔ **Nunca dentro de OneDrive, Google Drive ou Dropbox.** Esses serviços são ótimos para
documentos, mas um sistema vivo com versionamento não pode morar numa pasta que sincroniza
sozinha: o Git guarda o histórico em arquivos internos que mudam enquanto você trabalha, e a
sincronização compete por eles (trava, e pode corromper); arquivos "sob demanda" viram download
no meio do trabalho; e caminho longo com espaços quebra ferramenta de terminal. O backup certo
(a cópia de segurança fora do computador) aparece na Parte 4.

O passo a passo de preencher os arquivos da pasta está no
[README do sistema-inicial](sistema-inicial/README.md). Em resumo: você troca três textos entre
colchetes (quem é você, o que é o seu negócio, e a sua lista pessoal do que o sistema nunca deve
fazer) e adapta as frentes ao seu trabalho.

---

## Parte 3 · CLAUDE.md: o arquivo que dá papel à IA

**O que é:** `CLAUDE.md` é um arquivo de texto comum, escrito em português, que o Claude Code
**lê sozinho** ao abrir numa pasta. O da pasta-mãe vale para todas as janelas (as regras da
casa); o de cada frente define o papel daquela frente. É assim que a janela "sabe quem ela é"
sem você explicar nada.

**Como escrever um bom papel** (o modelo completo é o
[MODELO-ASSISTENTE.md](MODELO-ASSISTENTE.md)):

1. **Missão em uma frase.** Se precisar de "e", provavelmente são dois papéis.
2. **O que ele NÃO faz.** Sem ele, tudo está no escopo.
3. **O que ele exige para começar.** Faltou, ele para e pergunta; nunca estima.
4. **Como a entrega chega.** Tabela? Uma página? Rascunho para você revisar?

**Uma dica prática:** não escreva o primeiro `CLAUDE.md` sozinho. Abra o Claude
na pasta e diga: *"me entreviste sobre esta área do meu trabalho e escreva o CLAUDE.md desta
frente com base nas minhas respostas"*. Ele pergunta, você responde falando do seu dia a dia, e
o papel nasce com as SUAS palavras. Depois é só aparar.

E a regra de manutenção: o papel não é uma tatuagem. Errou, ajusta. A própria pessoa vai
personalizando com o uso, e é assim que o sistema fica cada vez mais a cara do dono.

---

## Parte 4 · O diário e a rede de segurança

Os dois rituais que fazem a memória existir estão nas regras da casa do starter:

- **BOM DIA** ao abrir: a janela lê o diário mais recente da frente e diz onde parou.
- **FECHAR O DIA** ao terminar: ela escreve o diário de hoje (o que fizemos, decisões, próximo
  passo) e propõe guardar tudo no histórico do Git, mostrando a lista do que vai entrar.

O backup fora da máquina: crie no GitHub (`github.com`, conta gratuita) um repositório
**PRIVADO** (nunca público: o diário carrega nome de cliente e valor) e peça ao Claude, dentro
da pasta: *"conecte esta pasta ao meu repositório privado do GitHub e envie o que temos"*.
A partir daí, o "fechar o dia" (com o seu OK no passo final) deixa tudo guardado fora do
computador.

**Vale dizer com todas as letras: o Git é obrigatório?** Para abrir o Claude e conversar, não.
Para o SISTEMA (memória com histórico, reversibilidade do que foi registrado, backup), sim:
sem ele você tem arquivos; com ele você tem um sistema que sobrevive a erro, a troca de
máquina e ao tempo.

---

## Parte 5 · Configurações que valem conhecer

### 5.1 O /config

Dentro de qualquer janela do Claude Code, digite `/config`: abre a tela de configurações, com
a descrição de cada item. Não é preciso decorar; três coisas valem a visita logo no início:

- **Tema** (claro ou escuro, questão de conforto).
- **Modo de permissão padrão** (Parte 5.2).
- **Notificações** (avisos quando uma tarefa longa termina).

Explore com calma: cada item tem o próprio texto explicando o que dita.

### 5.2 Permissões, na régua certa

O Claude Code trabalha com **modos de permissão**: do mais cauteloso (confirma as ações com
você) ao extremo (chamado de *bypass*, que remove as confirmações normais).

⚠️ **Antes da régua, um aviso: o modo inicial pode não ser o cauteloso.** Em versões recentes,
contas pagas podem passar a abrir sessões novas já no modo automático (que edita arquivos e
executa comandos sem as confirmações rotineiras) depois da primeira sessão. Faça do modo um ato
consciente: no `/config`, procure o **modo de permissão padrão** e deixe no **Padrão** (o que
confirma). E confira no início de cada sessão qual modo está ativo; a própria janela mostra.

A régua que usamos, nascida de implantação real:

| Estágio | Modo | Condição |
|---|---|---|
| Primeiros dias | Padrão (confirma as ações) | Nenhuma: é o modo de aprender o que ele faz |
| Rotina estabelecida | Aceitar edições (*accept edits*) | SÓ depois do Git funcionando e do backup no ar, sabendo o alcance: este modo também executa sem perguntar comandos que mexem em arquivos (copiar, mover e até apagar) dentro da pasta liberada |
| Avançado | *Bypass* (sem as confirmações normais) | Praticamente nunca no computador do dia a dia: a própria documentação o reserva a ambientes isolados e SEM acesso à internet, onde ele não possa danificar o seu sistema principal: uma *máquina virtual* (um computador completo simulado dentro do seu) ou um *container* (um processo que roda isolado do resto do sistema). Se você não sabe montar um assim, este modo ainda não é para você. Git e backup NÃO bastam aqui |

**Permissão ampla sem isolamento não é produtividade, é imprudência.** E confirmar tudo para
sempre também não é garantia: a confirmação pode virar gesto automático; por isso, leia cada
pedido antes de aprovar. A régua existe para você subir de degrau com o chão pronto.

### 5.3 Acompanhar do celular (Remote Control)

O Claude Code tem um recurso de **controle remoto**: uma sessão aberta no seu computador pode
ser acompanhada e comandada pelo aplicativo do Claude no celular. Na prática: você abre a
janela em casa, sai, e do celular vê o andamento e responde o que a janela perguntar.

- **Como ligar:** no `/config`, ative a opção de controle remoto das sessões; no celular, use o
  aplicativo do Claude com a mesma conta.
- **O requisito:** o computador precisa estar LIGADO, com a sessão aberta. Por isso, configure a
  energia do Windows para não suspender sozinho: Iniciar → Configurações → Sistema → **Energia
  (e bateria)** → em "Tela e suspensão", coloque a suspensão **Nunca** quando ligado na tomada.
- O notebook pode ficar de tampa fechada? Só se você mudar também "ao fechar a tampa: não fazer
  nada" (Painel de Controle → Opções de Energia). Senão, tampa fechada = sessão dormindo.

### 5.4 MCP: as tomadas de ferramentas

**O que é:** MCP é o padrão que conecta o Claude a outras ferramentas, como uma régua de
tomadas: agenda, e-mail, navegador, planilhas. Com as conexões certas, a frente de secretaria
lê a sua agenda de verdade; a de suporte rascunha resposta com o histórico de verdade.

Três exemplos de conexão, pensando num escritório:

| Conexão | O que a frente passa a fazer |
|---|---|
| Agenda (Google Calendar) | Ler e propor compromissos, preparar o seu dia |
| E-mail (Gmail) | Ler, organizar e RASCUNHAR respostas (quem envia é você) |
| Navegador (Playwright) | Abrir páginas, preencher formulários, conferir informações num site |

⚠️ **A régua de segurança, antes de conectar qualquer coisa: conexão é ACESSO.** Um conector
autenticado fica preso à CONTA, não à conversa; qualquer janela com aquele conector alcança
aquele dado. Por isso: conecte só contas SUAS e do trabalho daquela frente; nunca use o sistema
sobre uma conta emprestada com conectores de terceiros ativos; e comece SEM conector nenhum:
o sistema já vale muito só com arquivos.

---

## Parte 6 · Frentes além do escritório (exemplos reais de uso)

O desenho (papel + diário + regras) foi pensado para áreas com continuidade; estes exemplos
saíram de uso real:

| Frente | O que ela faz |
|---|---|
| **Secretaria pessoal** | Agenda, contas do mês, rotina da casa, o brief do seu dia |
| **Suporte** | Rascunhos de resposta a clientes, base de respostas prontas, triagem do que é urgente |
| **Jurídico** | Organiza contratos e prazos, prepara dúvidas PARA o advogado (não o substitui) |
| **Estudos** | Material de um curso ou concurso, com diário do que você já venceu |

Comece com 2 ou 3 frentes ativas. A pergunta certa é "no que eu trabalho AGORA?", não "o que eu
tenho aí?". Frente demais no primeiro dia vira a lista do que você não terminou, e isso pode
desanimar em vez de organizar.

---

## Parte 7 · A pitada avançada (para quando o básico estiver rodando)

Existe um mundo além deste guia, e ele pode esperar você dominar o básico:

- **Um revisor de outro fornecedor.** No que é importante, uma segunda IA, de outra empresa,
  revisa o trabalho da primeira, com poder de veto LIMITADO por critérios escritos. É o que
  transforma "a IA disse" em "foi verificado".
- **Automação do navegador (Playwright)** para tarefas repetitivas em sites.
- **Atalhos de abertura (os "crachás"):** com o tempo, digitar `cd ...` cansa. Um atalho abre a
  janela certa com uma palavra. No Windows, peça ao próprio Claude: *"crie no meu perfil do
  PowerShell (o arquivo de configuração que o terminal lê ao abrir) uma função (um comando com
  o nome que eu escolher) chamada clientes, que entra em C:\meu-negocio\clientes e abre o
  claude"*. Ele cria, e no terminal novo basta digitar `clientes`.
- **Vários papéis ao mesmo tempo**, cada um na sua janela, trabalhando em paralelo.

---

## Vocabulário (uma linha cada)

| Termo | O que é |
|---|---|
| **Terminal** | A janela de conversar com o computador por texto; onde o Claude Code roda |
| **Comando** | Uma instrução digitada no terminal (`cd`, `claude`, `git ...`) |
| **Repositório** | Uma pasta cujo histórico o Git registra (a pasta + o caderno de mudanças) |
| **Commit** | Um registro no caderno: uma fotografia do estado dos arquivos, com autor e data |
| **Push** | Enviar os registros feitos para o repositório remoto (o backup no GitHub) |
| **GitHub** | O serviço na internet que guarda repositórios; o seu é PRIVADO |
| **CLAUDE.md** | O arquivo de regras/papel que o Claude Code lê sozinho ao abrir numa pasta |
| **Frente** | Uma área do seu trabalho: uma pasta com papel próprio e diário próprio |
| **Diário (handoff)** | O registro do dia escrito pela IA ao "fechar o dia"; a memória que é sua |
| **MCP** | O padrão que conecta o Claude a outras ferramentas (agenda, e-mail, navegador) |
| **Prompt** | O texto que você escreve para a IA; o pedido |
| **SSH** | Um jeito seguro de acessar outro computador pelo terminal. Você NÃO precisa disso para nada deste guia; o termo aparece por aí e é só isso |

---

## Quando algo der errado

O primeiro suporte técnico deste sistema é ele mesmo: abra o Claude na pasta e descreva o
problema ("o comando X deu este erro, o que aconteceu?"). Ele lê o ambiente de verdade e
resolve ou explica. Para erro de instalação, a pergunta certa é a mesma.

---

*Parte do repositório `github.com/DarivaBIM/equipe-de-ia` (licença CC BY: use, adapte e
compartilhe, citando a fonte). Escrito para a palestra "Sua equipe de IA cabe num arquivo de
texto", UNITRI, 25/08/2026.*
