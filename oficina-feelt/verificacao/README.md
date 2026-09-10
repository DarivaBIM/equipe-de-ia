# Conferência de formato e critérios do caso

O professor pode fazer a conferência manual comparando F1/F2/F3 com a tabela.
Este script opcional torna explícito o que foi medido: quatro critérios do relatório
e, quando `-Pauta` é informado, três critérios da pauta do caso sintético.
Ele só lê arquivos locais. Não instala software, não acessa rede e não altera relatórios.

## Rodar no Windows

Abra o **PowerShell** pelo menu Iniciar. Cole o comando referente à etapa desejada.
Se você instalou a oficina em Documentos ou outro local, substitua o início de **todos**
os caminhos dos comandos abaixo pelo local utilizado, inclusive os caminhos de relatórios e pauta.
Os comandos usam o PowerShell 7 (`pwsh`) se ele já estiver instalado. Se não estiver,
o professor pode usar `powershell` no mesmo lugar; ambos são testados no kit.
Se a política da sua instituição impedir scripts, use a conferência manual; não contorne a política.

**Primeiro: verificar se os controles preparados funcionam.**

```powershell
pwsh -NoProfile -File 'C:\IA-Professor\oficina-feelt\verificacao\verificar-relatorio.ps1' -Autoteste
```

Esperado: dezesseis linhas `PASS` e `AUTOTESTE OK`. O controle com erros deve ser reconhecido como
errado para o autoteste passar. Se aparecer `FAIL` ou erro de execução, pare e compare as fontes.

**Depois: verificar o relatório realmente gerado durante a aula.**

```powershell
pwsh -NoProfile -File 'C:\IA-Professor\oficina-feelt\verificacao\verificar-relatorio.ps1' -Caminho 'C:\IA-Professor\oficina-feelt\casa\gestao\relatorio-rascunho.md'
```

Esperado: quatro linhas `PASS` quando formato e critérios da tabela estão atendidos. A ausência do
arquivo significa que a geração ainda não ocorreu ou que foi salva em outro local.

**Conferir também a pauta da próxima reunião.**

```powershell
pwsh -NoProfile -File 'C:\IA-Professor\oficina-feelt\verificacao\verificar-relatorio.ps1' -Pauta 'C:\IA-Professor\oficina-feelt\casa\gestao\pauta-reuniao.md'
```

Esperado: três linhas `PASS`. A data da próxima reunião continua não informada;
as perguntas CAL-02 e ORC-03 preservam as situações pendentes e apontam fontes.

**Depois da conferência humana e do P03-D: verificar a cópia final e a pauta juntas.**

```powershell
pwsh -NoProfile -File 'C:\IA-Professor\oficina-feelt\verificacao\verificar-relatorio.ps1' -Caminho 'C:\IA-Professor\oficina-feelt\casa\gestao\relatorio-verificado.md' -Pauta 'C:\IA-Professor\oficina-feelt\casa\gestao\pauta-reuniao.md'
```

Esperado: sete linhas `PASS`. Se a cópia ainda não foi criada após a conferência humana,
o arquivo estará ausente; não renomeie um rascunho para aparentar que essa etapa ocorreu.

**Mostrar que o controle didático falha: este resultado é intencional.**

```powershell
pwsh -NoProfile -File 'C:\IA-Professor\oficina-feelt\verificacao\verificar-relatorio.ps1' -Caminho 'C:\IA-Professor\oficina-feelt\controle-didatico\relatorio-com-erros.md'
```

Esperado: `FAIL` em `CAL-02-SITUACAO` e `CAL-02-DATA`; os outros dois critérios passam.
Não apresente esse arquivo como resultado que a IA acabou de gerar.

## O que cada saída significa

- `PASS`: aquele critério da tabela foi satisfeito.
- `FAIL`: o formato ou um critério não foi atendido. Isso, sozinho, não prova erro factual.
- `ERRO DE EXECUCAO`: não foi possível medir, por exemplo porque o arquivo não existe.
- Códigos de saída para quem automatiza: 0 passou; 1 reprovou critério/estrutura; 2 não executou.

O script seleciona somente a tabela com cabeçalho `Item | Situação | Data/prazo | Evidência`
e exige três linhas únicas com códigos CAL-02, OFI-01, ORC-03 e quatro colunas.
Tabelas secundárias com outro cabeçalho não são tratadas como fatos principais.
O autoteste inclui a tabela secundária realmente produzida no ensaio, além de
cabeçalho ausente/incorreto, duplicidade e um rótulo com contradição após prefixo correto.
Aceita diferenças de caixa, acentos, negrito e espaços; não interpreta texto livre semanticamente.
Uma formulação correta fora desse formato deve ser conferida por uma pessoa e ajustada
para a tabela combinada, sem alegar que o texto foi provado falso apenas pelo formato.
Por exemplo, uma situação seguida de explicação pode ser fiel às fontes e ainda reprovar
o formato. O prompt pede rótulos curtos; o script não aceita qualquer prefixo porque
uma continuação também poderia contradizer o próprio rótulo.

Ele não verifica frases fora da tabela, qualidade de toda a revisão, autorização de publicação,
dados reais ou política institucional. Um relatório que passa ainda pode conter problema fora
do recorte. O parecer independente e a decisão do professor continuam necessários.

Na pauta, a checagem exige uma linha `Data da próxima reunião: Não informada.` e duas linhas
com CAL-02/ORC-03 somente na tabela de cabeçalho
`Item | Base confirmada | Pergunta para decisão | Evidência`. Tabelas auxiliares são ignoradas;
ausência ou repetição da tabela principal reprova a estrutura. Verifica situação,
presença de uma pergunta e referência; não julga a qualidade semântica da pergunta.
