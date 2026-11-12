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
npm run chaves:gerar -- --pepper # copia as 3 linhas para o .env
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

## Activação por código (sem pagamento automático)

1. O estudante paga por fora (M-Pesa/e-Mola para o número do Aprova+).
2. No admin, em **Códigos → Gerar códigos**, escolhes o produto (ex.: "Matemática + Física – 99 MT"), a quantidade e a referência do pagamento.
3. O código `APV-XXXX-XXXX` aparece **uma única vez**, com botão para copiar e uma mensagem pronta para WhatsApp. Na base de dados fica só o hash (HMAC-SHA256 com `CODIGO_PEPPER`).
4. Na app, o estudante escreve o código. O servidor cria a **licença assinada (Ed25519)** e a app descarrega os **pacotes** das provas compradas.

Cada código só se usa uma vez. Se o estudante mudar de telemóvel, tem duas formas de recuperar a compra:
- usa o mesmo código com o mesmo telefone da activação;
- usa um **código de recuperação** gerado em *Estudantes*, válido 7 dias e de uso único.

Revogar um código já usado cancela também a licença que ele criou.

### Chaves

```powershell
npm run chaves:gerar -- --pepper   # imprime LICENCA_CHAVE_PRIVADA, LICENCA_CHAVE_PUBLICA e CODIGO_PEPPER
```

- A **chave privada** fica só no `.env` do servidor.
- A **chave pública** (32 bytes em base64) vai para a app.
- Não mudes o `CODIGO_PEPPER` depois de gerares códigos, senão deixam de ser reconhecidos.
- Trocar as chaves invalida as licenças já emitidas.

### Pacotes

- **Publicar prova** (*Pacotes* no admin) gera `storage/pacotes/<PROVA>/<PROVA>-v<N>.zip`. Contém `pacote.json` (questões **publicadas** dos níveis 3–10, níveis e simulados, no formato `$defs/pacote` do schema) e `imagens/`. A versão é incremental e o SHA-256 fica guardado. Se nada mudou, não se cria nova versão.
- O conteúdo **grátis** (níveis 1–2, catálogo e preços) vai dentro do APK:

  ```powershell
  npm run exportar:app       # escreve ../mobile/assets/content/conteudo.json + imagens/
  ```

## API da app: `/api/v1`

Responde em JSON. Os erros vêm sempre como `{ "erro": { "codigo": "...", "mensagem": "..." } }`.

| Método e rota | Autenticação | O que faz |
|---|---|---|
| `POST /api/v1/activacao` `{ codigo, dispositivoId, telefone?, nome? }` | — (5 tentativas/hora por IP e por dispositivo) | Activa o código ou restaura a compra. Devolve `{ token, estudante, licenca, assinatura, licencas[], pacotes[], restaurado }` |
| `GET /api/v1/licencas` | Bearer | Licenças válidas e pacotes a descarregar |
| `GET /api/v1/pacotes/:prova/versao` | Bearer + licença | `{ versao, sha256, tamanho_bytes, … }` |
| `GET /api/v1/pacotes/:prova/download[?versao=N]` | Bearer + licença | O `.zip`, com `X-Checksum-SHA256`. Aceita `Range` para retomar |
| `GET /api/v1/catalogo` | — | Provas, ofertas, produtos e preços, e os contactos M-Pesa/e-Mola/WhatsApp |

Códigos de erro:

| Código | Estado HTTP |
|---|---|
| `CODIGO_INVALIDO` | 404 |
| `CODIGO_USADO` | 409 |
| `CODIGO_REVOGADO` | 410 |
| `CODIGO_EXPIRADO` | 410 |
| `TELEFONE_INVALIDO` | 400 |
| `PEDIDO_INVALIDO` | 400 |
| `DEMASIADAS_TENTATIVAS` | 429 |
| `NAO_AUTENTICADO` | 401 |
| `SEM_LICENCA` | 403 |
| `PACOTE_INEXISTENTE` | 404 |

**A licença** é um texto JSON canónico:

```json
{"v":1,"id":"…","estudante":"…","produto":"…","tipo":"niveis","provas":["UEM-MAT2"],"valido_ate":"2027-03-31T23:59:59.000Z","emitida_em":"…"}
```

A `assinatura` é Ed25519 (em base64) sobre os bytes UTF-8 desse texto. A app verifica a assinatura **antes** de fazer o parse.

### Exemplos (PowerShell)

```powershell
$api = "http://localhost:3000/api/v1"
$r = Invoke-RestMethod -Method Post "$api/activacao" -ContentType "application/json" `
     -Body (@{ codigo = "APV-XXXX-XXXX"; dispositivoId = "meu-pc"; telefone = "841234567" } | ConvertTo-Json)
$h = @{ Authorization = "Bearer $($r.token)" }
Invoke-RestMethod "$api/licencas" -Headers $h
Invoke-WebRequest "$api/pacotes/UEM-MAT2/download" -Headers $h -OutFile UEM-MAT2.zip
(Get-FileHash UEM-MAT2.zip -Algorithm SHA256).Hash   # igual a $r.pacotes[0].sha256
Invoke-RestMethod "$api/catalogo"
```

### Exemplos (curl)

```bash
curl -X POST http://localhost:3000/api/v1/activacao -H "Content-Type: application/json" \
     -d '{"codigo":"APV-XXXX-XXXX","dispositivoId":"meu-pc","telefone":"841234567"}'
curl -H "Authorization: Bearer apv_..." -o UEM-MAT2.zip http://localhost:3000/api/v1/pacotes/UEM-MAT2/download
```

> O limite de tentativas é guardado em memória. Isto chega para um servidor com um só processo; com vários processos é preciso um store partilhado (Redis).

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
| `npm run exportar:app [-- --saida <pasta>]` | conteúdo grátis para o APK |
| `npm run chaves:gerar [-- --pepper]` | par de chaves Ed25519 (+ pepper) |

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
- `codigos_activacao` (só o hash), `licencas` (texto assinado), `tokens_estudante` (só o SHA-256 do token) e `pacotes` (versões publicadas).

## Segurança

- Passwords com bcrypt e cookie de sessão `httpOnly` + `sameSite=lax` (+ `secure` em produção). As sessões ficam na BD.
- Token CSRF em todos os formulários. Limite de 10 tentativas de login falhadas por 15 minutos.
- O `.env` nunca vai para o Git, só o `.env.example`.

## Mudar para MySQL

1. Em `prisma/schema.prisma`, muda `provider = "sqlite"` para `provider = "mysql"`.
2. Acrescenta `@db.Text` aos textos longos: `Questao.enunciado`, `Questao.explicacao`, `Questao.dica`, `TextoBase.texto`, `Licenca.conteudo`, `Sessao.dados`, `Prova.nota`.
3. Põe `DATABASE_URL="mysql://utilizador:password@localhost:3306/aprova"` no `.env`.
4. Apaga `prisma/migrations/` e corre `npm run db:migrate` para criar as migrações de MySQL.
