# Aprova+

App offline para preparar os exames de admissão às universidades em Moçambique.

## Estrutura

- `mobile/`: aplicação Flutter (Android primeiro).
- `backend/`: API + admin (Express + Prisma + SQLite). Ver [backend/README.md](backend/README.md).
- `shared/content.schema.json`: formato do conteúdo (catálogo e questões), partilhado pelos seeds, pelo backend e pela app. É a fonte da verdade.
- `content/`: guia para preparar novas perguntas.
- `painel/`: reservado (o admin está dentro de `backend/`).
- `ESTRACAO_EXAM/`: extracção dos exames (PDF → seeds JSON). Fica **fora deste repositório** (está no `.gitignore`).

## Executar o backend

```powershell
cd backend
npm install
Copy-Item .env.example .env
npm run db:migrate
npm run db:seed
npm run dev        # http://localhost:3000/admin
```

## Executar a aplicação

Com Flutter e Android SDK configurados, abre um emulador e corre na pasta `mobile/`:

```powershell
cd mobile
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' pub get
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' run
```
