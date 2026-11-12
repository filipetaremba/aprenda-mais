# Aprova+

App offline para preparar os exames de admissão às universidades em Moçambique.

> **Para pôr o Aprova+ no ar** (pagamento, servidor, executável e Play Store), segue o
> **[Guia para pôr o Aprova+ no ar](GUIA_PUBLICACAO.md)**.

## Estrutura

- `mobile/`: aplicação Flutter (Android primeiro). Ver [mobile/README.md](mobile/README.md).
- `backend/`: API + painel admin (Express + Prisma + SQLite). Ver [backend/README.md](backend/README.md).
- `shared/content.schema.json`: formato do conteúdo (catálogo e questões), partilhado pelos seeds, pelo backend e pela app. É a fonte da verdade.
- `content/`: guia para preparar novas perguntas.
- `painel/`: reservado (o admin está dentro de `backend/`).
- `ESTRACAO_EXAM/`: extracção dos exames (PDF → seeds JSON). Fica **fora deste repositório** (está no `.gitignore`).

## Executar no computador (desenvolvimento)

Backend:

```powershell
cd backend
npm install
Copy-Item .env.example .env
npm run chaves:gerar -- --pepper   # copia as 3 linhas para o .env
npm run db:migrate
npm run db:seed
npm run dev                        # painel: http://localhost:3000/admin
```

App (com um emulador Android aberto):

```powershell
cd mobile
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' pub get
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' run
```
