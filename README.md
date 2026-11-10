# App Estudo

Aplicação leve para ajudar estudantes a prepararem-se para exames de admissão.

## Estrutura

- `mobile/`: aplicação Flutter. O código da tela inicial fica em `mobile/lib/main.dart`.
- `backend/`: estrutura destinada ao Supabase, às migrações SQL, às funções e aos dados iniciais.
- `conteudo/`: perguntas e ferramentas de importação.
- `painel/`: espaço reservado para o futuro painel web de administração.

## Executar a aplicação

Com Flutter e Android SDK configurados, abra um emulador e execute na pasta `mobile/`:

```powershell
cd mobile
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' pub get
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' run
```
