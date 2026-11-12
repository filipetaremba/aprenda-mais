# Aprova+ — App Flutter

App offline para preparar os exames de admissão. Só precisa de Internet para **activar um código**, **restaurar compras** e **verificar actualizações**.

## Correr (Windows / PowerShell)

```powershell
cd mobile
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' pub get
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' run                      # emulador: o backend é http://10.0.2.2:3000
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' test
& 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat' analyze
```

Opções de compilação (`--dart-define`):

| Nome | Para quê | Por omissão |
|---|---|---|
| `API_URL` | endereço do backend | `http://10.0.2.2:3000` (o PC visto do emulador) |
| `LICENCA_CHAVE_PUBLICA` | chave pública Ed25519 (base64) que verifica as licenças offline | a chave de desenvolvimento do `backend/.env` |
| `PAGAMENTO_AUTOMATICO` | mostra as telas 17–18 (M-Pesa/e-Mola automático) | `false` |

Para a versão final, usa a chave pública de produção e um `API_URL` com `https://`.

## Conteúdo

- **Embutido no APK** (`assets/content/conteudo.json` + `imagens/`): catálogo, preços, níveis e as questões dos **níveis 1–2**. É gerado pelo backend:

  ```powershell
  cd ..\backend
  npm run exportar:app                       # só questões publicadas
  npm run exportar:app -- --incluir-revistas # desenvolvimento: inclui as ainda não publicadas
  ```

  Na primeira abertura (e sempre que a app traz uma versão nova) o splash importa-o para a `content.db`.
- **Pago** (níveis 3–10 + simulados): só é descarregado depois de activar um código. São pacotes `.zip` por prova. A app verifica o SHA-256 e importa numa transacção; se a descarga falhar, retoma depois.

O formato está em [`../shared/content.schema.json`](../shared/content.schema.json).

## Estrutura

```
lib/
  app/        config, router (go_router), providers (Riverpod), tema claro/escuro
  core/       widgets do design, LaTeX (flutter_math_fork), formatos
  data/       content_db.dart / user_db.dart (drift), importador, licenças (Ed25519),
              API, sincronização, repositórios, activação
  domain/     regras (desbloqueio, nota) e motor do quiz/simulado — sem Flutter, fáceis de testar
  features/   telas
test/         regras, licenças, importação, integração (activar → pacote → nível 3), telas 360×640
```

- `content.db`: conteúdo. Pode ser reconstruída.
- `user.db`: perfil, objectivos, tentativas, respostas, licenças e preferências. **Nunca é apagada.**

Depois de mudar tabelas drift, gera o código de novo:

```powershell
& 'C:\Users\Estagiario\SDK\flutter\bin\dart.bat' run build_runner build
```

## Regras implementadas

- Nível N+1 abre com nota ≥ mínima do nível N (por omissão 70%, configurável por nível no admin).
- Níveis 1–2 são grátis. Do 3 em diante é preciso uma licença válida para a prova **e** o pacote descarregado.
- Nota = certas sem ver a resposta / total. A dica não penaliza. "Ver resposta" mostra a correcta, mas essa questão não conta.
- Alternativas baralhadas (a ordem fica guardada para a revisão); V/F com 2 botões; imagens e LaTeX.
- Simulados: só com licença de simulados; cronómetro decrescente que termina sozinho; marcar; navegação livre; sem ajudas. A correcção aparece só no fim.
- As licenças são verificadas offline. Uma licença alterada ou com a assinatura errada é ignorada.
