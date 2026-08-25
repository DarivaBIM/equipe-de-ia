# Sua equipe de IA cabe num arquivo de texto

Modelo e checklist para criar assistentes de inteligência artificial com **papel definido**, sem
programar. E o **sistema inicial**: uma pasta pronta para copiar, com regras da casa, gerência,
frentes e diário.

Material da palestra apresentada no **Centro Universitário do Triângulo (UNITRI)**, em Uberlândia,
no dia **25 de agosto de 2026**, por **Matheus Dariva**.

---

## O que tem aqui

| Arquivo | Para que serve |
|---|---|
| **[sistema-inicial/](sistema-inicial/)** | 🆕 A pasta pronta para copiar: regras da casa, uma gerência, três frentes de exemplo e o diário que dá memória à IA. Comece pelo README dela |
| **[GUIA-COMPLETO.md](GUIA-COMPLETO.md)** | 🆕 Do computador vazio ao sistema rodando: o que instalar (terminal, Claude Code, Git), configurações, permissões na régua certa, celular, MCPs e vocabulário, escrito para quem nunca programou |
| **[MODELO-ASSISTENTE.md](MODELO-ASSISTENTE.md)** | A ficha em branco. Copie, preencha de cima para baixo, e você tem um assistente |
| **[CHECKLIST-VERIFICACAO.md](CHECKLIST-VERIFICACAO.md)** | Os testes dos três erros mais comuns, e as perguntas que se faz a um número |
| **[exemplos/](exemplos/)** | Três assistentes reais, preenchidos, que trabalham em sequência |

## A ideia em uma frase

Um assistente com papel definido **não é** uma IA que faz sempre a mesma tarefa. É uma IA que
encara tarefas diferentes **sempre a partir do mesmo papel**, dos mesmos limites e dos mesmos
critérios de qualidade.

A diferença é a que existe entre **pedir** uma coisa e **contratar** alguém para uma função.

## Como começar

1. Pegue **uma tarefa que você repete toda semana** — não a mais difícil, a mais repetida.
2. Copie o `MODELO-ASSISTENTE.md` e preencha.
3. Rode com um caso real e confira o resultado usando o `CHECKLIST-VERIFICACAO.md`.
4. **Só então** faça o segundo.

> ⚠️ O campo mais fácil de esquecer é o **"o que ele NÃO faz"**. Sem ele, nada fica fora do
> escopo — então tudo está dentro.

## Os três erros

| | Erro | O que é |
|---|---|---|
| **1** | **Personagem sem cargo** | Descrever personalidade (*"brilhante, detalhista, criativo"*) em vez de processo. Personalidade não substitui processo |
| **2** | **Cargo misturado com tarefa** | Colar o pedido do momento na descrição permanente. A função é permanente; a tarefa é temporária |
| **3** | **Autor sem revisor** | O mesmo assistente produz e julga o próprio trabalho. A resposta errada que parece boa é a que atravessa a revisão |

## Os exemplos

Os três de `exemplos/` foram escritos para funcionar **em sequência**, e é isso que os torna uma
equipe em vez de três assistentes soltos:

```
pesquisador.md  →  levanta o material, com a fonte de cada item
roteirista.md   →  estrutura em blocos, com tempo
revisor.md      →  aprova ou reprova, com o motivo
```

Vale abrir o `revisor.md` primeiro: nele estão preenchidos **os critérios de qualidade** e o
**quando parar e perguntar** — os dois campos que decidem se o assistente julga ou apenas concorda.

## Licença

[CC BY 4.0](LICENSE) — use, adapte e compartilhe, inclusive comercialmente, citando a fonte.

---

**Matheus Dariva** · engenheiro civil, fundador da DarivaBIM
