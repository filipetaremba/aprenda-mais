# Aprova+ — Backend (API + Admin)

Express 5 + TypeScript + Prisma. Base de dados **SQLite** (um ficheiro, sem instalar nada); pronto para mudar para **MySQL**.
O admin é renderizado no servidor (EJS), com o estilo da app (azul `#3B7BEA`, Poppins).

## Arrancar em Windows (PowerShell)

Precisa de Node 20 ou superior.

```powershell
cd backend
npm install
Copy-Item .env.example .env      # depois edita SESSION_SECRET, ADMIN_EMAIL e ADMIN_PASSWORD
npm run db:migrate               # cria prisma/dev.db com as tabelas
npm run db:seed                  # cria o primeiro admin (ADMIN_EMAIL / ADMIN_PASSWORD)
npm run dev                      # http://localhost:3000/admin
```

Para gerar um `SESSION_SECRET`:

```powershell
node -e "console.log(require('crypto').randomBytes(36).toString('base64url'))"
```

### Importar o conteúdo dos seeds

```powershell
npm run importar -- ..\ESTRACAO_EXAM\seeds              # só o relatório (não grava)
npm run importar -- ..\ESTRACAO_EXAM\seeds --gravar     # grava catálogo + questões + imagens
```

As questões entram como **revista** (as que não têm resposta entram como **rascunho**). Publicam-se no admin, em *Questões*: filtrar, seleccionar e escolher *Publicar*.
As que já existem não são alteradas, porque podem ter sido editadas no admin. Para as voltar a gravar, acrescenta `--substituir`.
Também se pode importar pela página **Importar JSON** do admin, que mostra o relatório antes de gravar.

## Scripts

| Comando | O que faz |
|---|---|
| `npm run dev` | servidor com recarga automática |
| `npm run build` / `npm start` | compila para `dist/` / corre a versão compilada |
| `npm test` | testes (jest + supertest) numa base própria, `prisma/test.db` |
| `npm run db:migrate` | aplica e cria migrações (desenvolvimento) |
| `npm run db:deploy` | aplica migrações (produção) |
| `npm run db:seed` | cria o admin. Com `SEED_CATALOGO=<pasta>` importa também o catálogo |
| `npm run importar -- <ficheiro\|pasta> [--gravar] [--substituir]` | importa conteúdo |

## Estrutura

```
backend/
  prisma/schema.prisma     modelo de dados (tabelas em snake_case, chaves de texto = códigos dos seeds)
  src/
    app.ts                 Express (helmet, sessões, CSRF, /health, /admin)
    config.ts              variáveis do .env
    dominio.ts             regras de conteúdo (tipos, estados, 1 alternativa correcta, LaTeX…)
    seguranca.ts           sessões na BD, CSRF, autenticação do admin
    conteudo/importador.ts validação (shared/content.schema.json) + importação
    admin/                 páginas do admin (catálogo, questões, produtos, importar)
  views/                   EJS
  public/                  CSS, JS e fontes Poppins
  scripts/                 seed.ts, importar.ts
  tests/
```

O formato do conteúdo está em [`../shared/content.schema.json`](../shared/content.schema.json), que é a fonte da verdade partilhada com os seeds e a app.

## Modelo (resumo)

- **Prova = grupo de exame + disciplina (+ variante)**, por exemplo `UEM-MAT2`. Serve todas as instituições do grupo (UEM + UniZambeze).
- **Curso** é genérico (`ENGENHARIA-INFORMATICA`). Uma **oferta** é um curso numa instituição (`cursos.json` dos seeds) e tem as suas provas em `oferta_prova`, com peso.
- **Questão**: `escolha_multipla` (4 alternativas; 5 aceites, porque os exames da UEM têm 5) ou `verdadeiro_falso` (2). Ligação a uma prova e a um nível em `questao_prova`.
- **Estados**: `rascunho` → `revista` → `publicada`. Só as publicadas vão para a app (Etapa 3). Uma questão publicada não se apaga, passa-se a rascunho.
- As tabelas `codigos_activacao`, `licencas` e `pacotes` já existem, mas a funcionalidade é da Etapa 3.

## Segurança

- Passwords com bcrypt e cookie de sessão `httpOnly` + `sameSite=lax` (+ `secure` em produção). As sessões ficam na BD.
- Token CSRF em todos os formulários. Limite de 10 tentativas de login falhadas por 15 minutos.
- O `.env` nunca vai para o Git, só o `.env.example`.

## Mudar para MySQL

1. Em `prisma/schema.prisma`, muda `provider = "sqlite"` para `provider = "mysql"`.
2. Acrescenta `@db.Text` aos textos longos: `Questao.enunciado`, `Questao.explicacao`, `Questao.dica`, `TextoBase.texto`, `Licenca.conteudo`, `Sessao.dados`, `Prova.nota`.
3. Põe `DATABASE_URL="mysql://utilizador:password@localhost:3306/aprova"` no `.env`.
4. Apaga `prisma/migrations/` e corre `npm run db:migrate` para criar as migrações de MySQL.
