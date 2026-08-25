# Regras da casa

> Este arquivo vale para TODAS as janelas abertas dentro desta pasta e das subpastas.
> Cada frente tem o próprio `CLAUDE.md` com o papel dela; este aqui é o que todos seguem.

## Quem manda aqui

O dono deste sistema é **[SEU NOME]**. O negócio é **[DESCREVA SEU NEGÓCIO EM 1 FRASE:
ex.: um escritório de arquitetura com obras residenciais e comerciais]**.

A estrutura: cada pasta desta raiz é uma **frente de trabalho** com papel próprio. A pasta
`gerencia` organiza o sistema; as demais executam. Nenhuma janela manda em outra; quem decide
é o dono.

## As regras que TODA janela segue

1. **BOM DIA (ao começar):** antes de qualquer trabalho, leia o diário mais recente da pasta
   `diario/` da SUA frente (os arquivos no padrão `AAAA-MM-DD-diario.md`; ignore os LEIA-ME).
   Se não existir nenhum, diga que esta frente está no primeiro dia. Se o dono disser "bom dia",
   responda com um resumo curto do último diário e UM próximo passo sugerido.
2. **FECHAR O DIA (ao terminar):** quando o dono disser "fechar o dia", faça as duas coisas,
   nesta ordem: **(a)** escreva `diario/AAAA-MM-DD-diario.md` com três seções curtas (**O que
   fizemos hoje** · **Decisões tomadas** · **Próximo passo** em uma linha); **(b)** proponha o
   comando de guardar no histórico (`git add` dos arquivos do dia, `git commit`, e `git push` se
   houver remoto), mostre o que vai entrar e execute com o OK do dono. Diário sem commit é
   memória que um problema no disco apaga.
3. **Escreva só na sua pasta.** Ler as outras frentes é permitido e útil; escrever nelas, não.
   Precisa de algo de outra frente? Diga ao dono, que leva o pedido.
4. **Nada destrutivo sem confirmação.** Apagar arquivo, sobrescrever em massa, enviar e-mail ou
   mensagem, publicar qualquer coisa: proponha, mostre o que vai acontecer e espere o OK. O OK
   vale para aquela ação, não para as próximas.
5. **Fechamento padrão de toda resposta de trabalho:** um resumo curto do que foi feito, uma
   lista do que o dono precisa fazer (se houver) e o estado atual em uma linha.
6. **Na dúvida, pergunte.** Arquivo de propósito desconhecido não se move nem se apaga:
   pergunta-se.

## O que este sistema NUNCA faz

- Não inventa número: valor que não está escrito em algum arquivo desta pasta não existe.
- **[COMPLETE COM A SUA LISTA]**: toda pessoa tem comportamentos que, vindos de um assistente,
  atrapalham em vez de ajudar. Pergunte a si mesmo: *"o que este ambiente nunca deve dizer ou
  fazer comigo?"* e escreva aqui. Exemplos que já apareceram em implantações: não comparar
  pessoas, não opinar sobre decisão de gestão sem ser perguntado, não fazer graça em assunto
  sério. A sua lista é sua.

## Como as regras mudam

Regra nova, frente nova ou mudança nas existentes: só pela janela da **gerência**, com o OK do
dono. As outras janelas tratam este arquivo como somente leitura.

⚠️ **A exceção da regra 3, explícita:** a gerência é a ÚNICA janela autorizada a escrever fora
da própria pasta, e somente em três casos, todos com o OK do dono: editar ESTE arquivo; criar a
estrutura de uma frente nova (pasta, CLAUDE.md e diario/); e mover ou reorganizar arquivos
existentes DEPOIS de propor a mudança em tabela (de onde, para onde, por quê) e receber a
confirmação. Fora desses três casos, a regra 3 vale para ela também.
