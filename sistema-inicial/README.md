# 🏠 Sistema inicial: sua equipe de IA em pastas

Este é o ponto de partida de um **sistema de trabalho com o Claude Code**: uma pasta-mãe com
regras que valem para todos, uma **gerência** que organiza o conjunto, e uma pasta por **frente**
de trabalho, cada uma com o próprio papel e o próprio **diário**.

A ideia central, em uma frase: **a memória que importa é a que VOCÊ escreve de propósito, lê,
corrige e versiona. O sistema dá isso à IA na forma de um diário por frente.**

(O Claude Code até tem uma memória automática de projeto: são arquivos locais, dá para ver com
o comando `/memory`. O diário é diferente em três coisas: é DELIBERADO, você decide o que fica
registrado; é POR FRENTE, enquanto a automática é uma só para o repositório inteiro; e é
VERSIONADO junto do trabalho, então viaja no backup e tem histórico.)

Se você lembra do filme "Como se fosse a primeira vez": a IA é a Lucy, que acorda sem lembrar
direito do dia anterior. O diário é o vídeo que ela assiste toda manhã. Este sistema é isso, em
pastas.

---

## O que tem aqui

```
sistema-inicial/
├── CLAUDE.md            As regras da casa (valem para TODAS as janelas)
├── .gitignore           O que o versionamento deve ignorar (segredos, temporários)
├── gerencia/            A frente que organiza o sistema e cuida das regras
├── clientes/            Frente de exemplo: propostas e atendimento
├── financeiro/          Frente de exemplo: contas e organização financeira
└── marketing/           Frente de exemplo: conteúdo e divulgação
```

Cada frente tem um `CLAUDE.md` (o papel dela) e uma pasta `diario/` (a memória dela).
As três frentes são exemplos: renomeie, apague ou crie outras conforme o SEU trabalho.

---

## Como instalar (sem programar)

### Passo 1: instale o Claude Code

Siga o guia oficial em `claude.com/claude-code`. Ao final, você deve conseguir abrir um
terminal, digitar `claude` e ver o assistente responder.

### Passo 2: copie esta pasta para um lugar CURTO e LOCAL

Copie a pasta `sistema-inicial` para a raiz do seu disco, com um nome curto e sem espaços.
Exemplo: `C:\meu-negocio`.

⛔ **Nunca dentro de OneDrive, Google Drive ou Dropbox.** Três motivos, todos vividos:

1. Esses serviços trocam arquivos por atalhos "sob demanda" e sincronizam no meio do trabalho.
   O versionamento (git) guarda o histórico em arquivos internos que mudam enquanto você
   trabalha, e a sincronização compete por eles: trava, e pode corromper.
2. Enquanto trabalha, a IA lê e escreve arquivos. Se cada leitura vira um download, tudo fica
   lento e imprevisível.
3. Caminho longo e com espaços quebra ferramentas de linha de comando em situações difíceis de
   diagnosticar. Um caminho curto na raiz do disco reduz essa classe de problema.

O backup, que é a função legítima desses serviços, vem no Passo 6 com o GitHub, do jeito certo.

### Passo 3: preencha o CLAUDE.md da pasta-mãe

Abra `C:\meu-negocio\CLAUDE.md` no Bloco de Notas e troque os TRÊS textos entre [COLCHETES]:
quem é você, o que é o seu negócio, e a sua lista pessoal do que o sistema nunca deve fazer
(o campo `[COMPLETE COM A SUA LISTA]`, lá embaixo, explica como pensar nela). Não mexa nas
demais regras ainda: use primeiro; depois ajuste com a gerência.

### Passo 4: adapte as frentes

Para cada pasta de frente (`clientes`, `financeiro`, `marketing`):

1. Renomeie a pasta se o seu trabalho pedir outro nome (uma frente é uma área REAL e ATIVA do
   seu trabalho; não crie pastas para projetos parados).
2. Abra o `CLAUDE.md` de dentro dela e preencha os [COLCHETES].

Regra de ouro para decidir as frentes: pergunte "no que eu estou trabalhando AGORA?", e não
"o que eu tenho aí?". Comece com 2 ou 3. Menos é mais.

### Passo 5: crie a rede de segurança (antes de qualquer trabalho)

Primeiro o pré-voo, uma vez só. No terminal, confira se o git existe e se ele já sabe quem
você é:

```
git --version
git config --global --get user.name
git config --global --get user.email
```

Se `git --version` der erro, o git não está instalado: peça ao próprio Claude, dentro da pasta,
"instale o git para mim e me diga o que você fez" (ou baixe em git-scm.com). Se os dois `--get`
já mostrarem o seu nome e o seu e-mail, não mexa neles. Só se vierem VAZIOS, grave os SEUS
dados (troque pelos seus de verdade; sem isso o commit falha com "Author identity unknown"):

```
git config --global user.name "AQUI O SEU NOME"
git config --global user.email "aqui-o-seu@email.com"
```

Agora, dentro de `C:\meu-negocio`, primeiro OLHE o que existe, depois adicione:

```
git init
git status
```

O `git status` mostra tudo o que o git enxerga na pasta. Passe o olho ANTES de adicionar: se
aparecer algo que não deveria entrar no histórico (uma senha salva num arquivo, um documento de
terceiro), tire da pasta agora. Então adicione e CONFIRA de novo:

```
git add .
git status
```

Se neste segundo `git status` você notar um arquivo indevido JÁ na lista verde ("changes to be
committed"), tirar da pasta não basta: remova-o também da lista com
`git rm --cached NOME-DO-ARQUIVO` e confira o `git status` mais uma vez. **Só quando a lista
estiver certa**, fotografe:

```
git commit -m "primeiro dia do sistema"
```

A partir daqui as mudanças COMMITADAS têm histórico e são reversíveis. E é por isso que o ritual
de "fechar o dia" (nas regras da casa) termina guardando o dia no histórico: diário escrito e
nunca commitado é memória que um problema no disco apaga.

### Passo 6: backup fora da máquina (GitHub, repositório PRIVADO)

Crie uma conta no GitHub, crie um repositório **privado** (nunca público: seu diário vai conter
nomes e valores do seu trabalho) e peça ao Claude, dentro da pasta: "conecte esta pasta ao meu
repositório privado do GitHub e envie o que temos". Importante: o `git push` envia o que foi
COMMITADO, não o que está solto na pasta. O ritual de "fechar o dia" cuida disso na ordem certa
(diário → commit → push); se você fizer à mão, commit primeiro, push depois.

### Passo 7: o primeiro dia de uso

1. Abra o terminal na pasta da gerência: `cd C:\meu-negocio\gerencia` e rode `claude`.
2. Diga: **"reconheça o sistema"**. A gerência vai ler as pastas e as regras, e se apresentar.
3. Abra outra janela na frente que você mais usa (`cd C:\meu-negocio\clientes`, `claude`) e
   trabalhe normalmente.
4. Ao terminar, diga: **"fechar o dia"**. A janela escreve o diário de hoje.
5. Amanhã, ao abrir, diga: **"bom dia"**. Ela lê o diário e continua de onde parou.

**O que decide se o sistema vai funcionar não é o primeiro dia. É o segundo**: o dia em que a
IA acorda, lê o diário e você percebe que não precisou explicar nada de novo.

---

## As três regras que mais protegem você

1. **Diário sempre.** Trabalho sem "fechar o dia" é trabalho que amanhã não existe.
2. **Cada janela escreve só na própria pasta.** Ler as outras pode; escrever, não. É a regra
   que reduz o risco de duas janelas desfazerem o trabalho uma da outra (é uma regra escrita,
   não uma trava técnica: o histórico do git é quem desfaz quando algo passa).
3. **Nada destrutivo sem confirmação.** Apagar, sobrescrever em massa e enviar coisas para fora
   são ações que a IA propõe e VOCÊ aprova.

---

## Perguntas que vão aparecer

**Por que uma "gerência"?** Porque regras precisam de um dono. Quando você quiser mudar como o
sistema funciona (uma regra nova, uma frente nova), fale com a janela da gerência. As outras
janelas trabalham; ela organiza. Sem um dono das regras, cada janela as muda do seu jeito e
logo ninguém sabe mais o que vale.

**A memória fica onde?** Em arquivos de texto, visíveis, dentro de cada frente. Você pode abrir,
ler e corrigir. Memória que você não pode ler é memória que você não pode consertar.

**E quando a IA errar?** Vai errar. O sistema existe para o erro custar pouco: o git desfaz, o
diário registra, e a regra da pasta própria limita o estrago. Comece pequeno, ajuste as regras
com o uso.

---

*Parte do material da palestra "Sua equipe de IA cabe num arquivo de texto" (UNITRI, 25/08/2026)
e do repositório `github.com/DarivaBIM/equipe-de-ia`. Licença CC BY: use, adapte e compartilhe,
citando a fonte.*
