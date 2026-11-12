# Guia para pôr o Aprova+ no ar

Este guia explica, passo a passo, como pôr o Aprova+ a funcionar para os estudantes:

1. [Como as peças comunicam](#1-como-as-peças-comunicam)
2. [Configurar o pagamento](#2-configurar-o-pagamento)
3. [Pôr o backend num servidor](#3-pôr-o-backend-num-servidor)
4. [Criar o executável da app](#4-criar-o-executável-da-app)
5. [Publicar na Play Store](#5-publicar-na-play-store)
6. [Lista final](#6-lista-final)

---

## 1. Como as peças comunicam

O Aprova+ tem **duas partes**:

| Parte | O que é | Onde fica |
|---|---|---|
| **App** | O que o estudante instala no telemóvel | Play Store (ou APK enviado por WhatsApp) |
| **Backend** | O "cérebro" na Internet: guarda as questões, gera os códigos e entrega o conteúdo pago. Tem o **painel admin**, que só tu usas | Um servidor na Internet, com um endereço como `https://api.aprova.co.mz` |

```
   ESTUDANTE                                          TU (administrador)
┌──────────────┐                                     ┌──────────────────┐
│  App Aprova+ │                                     │ Browser no PC    │
│ (telemóvel)  │                                     │ painel /admin    │
└──────┬───────┘                                     └────────┬─────────┘
       │  só quando activa um código                          │
       │  ou descarrega conteúdo novo                         │
       ▼                                                      ▼
┌──────────────────────────────────────────────────────────────────────┐
│            SERVIDOR  https://api.aprova.co.mz  (backend)             │
│   questões · preços · códigos · licenças · pacotes de conteúdo       │
└──────────────────────────────────────────────────────────────────────┘
```

**O que é importante perceber:**

- A app traz **dentro dela** os níveis 1 e 2 de todas as provas. Para estudar, **não precisa de Internet**.
- A app só fala com o servidor em três momentos:
  1. quando o estudante **activa um código** (depois de pagar);
  2. quando **descarrega** os níveis pagos (3 a 10);
  3. quando carrega em **"Verificar actualizações"** ou **"Restaurar compra"**.
- A app sabe onde está o servidor porque o endereço vai **gravado nela** quando a compilas (passo 4).
- Toda a comunicação usa **HTTPS** (com cadeado), por isso ninguém consegue ler nem alterar o que passa.
- A compra fica protegida por uma **assinatura digital**. O servidor assina a licença com uma chave secreta e a app confirma-a com a chave pública que leva dentro. Assim ninguém consegue inventar uma compra.

---

## 2. Configurar o pagamento

Nesta fase **não há pagamento automático**. O estudante paga **por fora** (M-Pesa ou e-Mola) e tu envias-lhe um **código de activação**. É simples, e não precisa de contratos com operadoras.

### 2.1 O que tens de ter

- Um número **M-Pesa** e/ou **e-Mola** para receber os pagamentos.
- Um número de **WhatsApp** para os estudantes enviarem o comprovativo.

### 2.2 Onde se configura

**Os números** ficam no ficheiro `.env` do backend, no servidor:

```
CONTACTO_MPESA=84 123 4567
CONTACTO_EMOLA=86 123 4567
CONTACTO_WHATSAPP=84 123 4567
CONTACTO_NOME_CONTA=Aprova+ (Nome do titular)
```

A app vai buscá-los ao servidor e mostra-os no ecrã "Desbloquear". Se mudares um número, **não precisas de nova versão da app**: basta reiniciar o servidor.

**Os preços** mudam-se no **painel → Produtos**. Por exemplo:

| Produto | Preço |
|---|---|
| Matemática · UEM (níveis 3–10) | 59 MT |
| Simulados de Matemática · UEM | 49 MT |
| Matemática + Física (pacote) | 99 MT |

Os preços também são actualizados na app sem nova versão.

### 2.3 Como funciona uma venda (do lado do estudante e do teu)

```
Estudante                                         Tu (no painel)
─────────                                         ──────────────
1. Abre "Desbloquear" e vê o preço
   e os números para pagar
2. Paga por M-Pesa/e-Mola
3. Envia o comprovativo no WhatsApp  ───────────▶ 4. Confirmas o dinheiro no extracto
                                                  5. Painel → Códigos → Gerar códigos
                                                     (escolhes o produto e escreves a referência)
                                   ◀─────────────  6. "Enviar por WhatsApp" (mensagem pronta)
7. Na app: "Tenho um código de activação"
   e escreve APV-XXXX-XXXX
8. A app descarrega os níveis pagos
   → pode estudar sem Internet
```

**Regras úteis:**

- Cada código **só se usa uma vez**.
- Se o estudante **mudar de telemóvel**, pode "Restaurar compra" com o mesmo código e o mesmo telefone. Se já não tiver o código, gera-lhe um em **Estudantes → Código de recuperação**.
- **Reembolso:** em **Códigos**, carrega em **Revogar**. A compra deixa de valer.

> Mais tarde pode ligar-se o pagamento automático M-Pesa/e-Mola. As telas já existem na app, mas estão desligadas.

---

## 3. Pôr o backend num servidor

### 3.1 O que precisas

| Coisa | Exemplo | Custo aproximado |
|---|---|---|
| **Domínio** | `aprova.co.mz` | por ano |
| **Servidor (VPS)** com Ubuntu 24.04, 1–2 GB de RAM | qualquer fornecedor com IP público | por mês |

No painel do domínio, cria um registo do tipo **A** com o nome `api` a apontar para o **IP do servidor**. Assim, `api.aprova.co.mz` passa a levar ao teu servidor.

### 3.2 Passo a passo

Entra no servidor a partir do teu PC (PowerShell):

```powershell
ssh utilizador@IP-DO-SERVIDOR
```

**a) Instalar o necessário** (uma só vez):

```bash
sudo apt update && sudo apt -y install git sqlite3 caddy
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt -y install nodejs
```

**b) Copiar o projecto e instalar:**

```bash
sudo mkdir -p /srv/aprova && sudo chown $USER /srv/aprova
git clone <endereço-do-repositório-git> /srv/aprova/app
cd /srv/aprova/app/backend
npm ci
cp .env.example .env
npm run chaves:gerar -- --pepper
```

**c) Preencher o `.env`** (`nano .env`):

```
NODE_ENV=production
DATABASE_URL="file:./prod.db"
PORT=3000
SESSION_SECRET=<texto aleatório comprido>
ADMIN_EMAIL=<o teu email>
ADMIN_PASSWORD=<password forte>
STORAGE_DIR=./storage
CODIGO_PEPPER=...            ← as 3 linhas que o "chaves:gerar" mostrou
LICENCA_CHAVE_PRIVADA=...
LICENCA_CHAVE_PUBLICA=...    ← esta vai também para a app (passo 4)
CODIGOS_VALIDADE_PADRAO=2027-03-31
CONTACTO_MPESA=...           ← os teus números (secção 2)
CONTACTO_EMOLA=...
CONTACTO_WHATSAPP=...
CONTACTO_NOME_CONTA=...
```

Para gerar o `SESSION_SECRET`: `node -e "console.log(require('crypto').randomBytes(36).toString('base64url'))"`.

> 🔐 **Muito importante:** guarda uma cópia deste `.env` num sítio seguro, fora do servidor. As linhas `CODIGO_PEPPER` e `LICENCA_CHAVE_...` **nunca podem mudar nem perder-se**. Se se perderem, os códigos vendidos deixam de funcionar.

**d) Criar a base de dados e o admin:**

```bash
npx prisma migrate deploy
npm run build
npm run db:seed
```

**e) Pôr as questões no servidor.** No teu PC, envia os seeds:

```powershell
scp -r "C:\Users\Estagiario\Desktop\FILIPE TAREMBA\COEL\aprenda-mais\ESTRACAO_EXAM\seeds" utilizador@IP-DO-SERVIDOR:/tmp/seeds
```

No servidor:

```bash
npm run importar -- /tmp/seeds --gravar
npm run niveis:redistribuir -- --gravar
npm run provas:partilhar -- --gravar
npm run produtos:padrao
```

**f) Deixar o backend sempre ligado** (arranca sozinho se o servidor reiniciar):

```bash
sudo tee /etc/systemd/system/aprova.service > /dev/null <<'EOF'
[Unit]
Description=Aprova+ backend
After=network.target
[Service]
User=$USER
WorkingDirectory=/srv/aprova/app/backend
ExecStart=/usr/bin/node dist/src/server.js
Restart=always
[Install]
WantedBy=multi-user.target
EOF
sudo sed -i "s/\$USER/$USER/" /etc/systemd/system/aprova.service
sudo systemctl daemon-reload && sudo systemctl enable --now aprova
```

**g) Ligar o HTTPS (cadeado).** O Caddy trata do certificado sozinho e de graça:

```bash
echo 'api.aprova.co.mz {
    reverse_proxy localhost:3000
}' | sudo tee /etc/caddy/Caddyfile
sudo systemctl reload caddy
```

**h) Testar no browser:**

- `https://api.aprova.co.mz/health` deve mostrar `{"ok":true,...}`.
- `https://api.aprova.co.mz/admin` deve abrir o painel. Entra com o email e a password do `.env`.

> O login do painel **só funciona com `https://`**. Se não entrar, confirma o endereço.

### 3.3 No painel, antes de vender

1. **Questões:** rever e **publicar**. Só as publicadas chegam aos estudantes.
2. **Produtos:** confirmar os nomes e os preços.
3. **Pacotes:** carregar em **"Publicar prova"** em cada prova. É isto que cria o conteúdo pago que a app descarrega.

### 3.4 Cópias de segurança

O ficheiro `prod.db` guarda **as vendas, os códigos e os estudantes**. Faz uma cópia todos os dias:

```bash
mkdir -p /srv/aprova/backups
( crontab -l 2>/dev/null; echo '30 2 * * * sqlite3 /srv/aprova/app/backend/prisma/prod.db ".backup /srv/aprova/backups/prod-$(date +\%F).db"' ) | crontab -
```

De vez em quando, copia a pasta `/srv/aprova/backups` para o teu PC.

---

## 4. Criar o executável da app

Faz-se **no teu PC**. O resultado é:
- um **`.aab`**, o ficheiro que se envia para a Play Store;
- e/ou um **`.apk`**, que se pode instalar directamente ou enviar por WhatsApp.

### 4.1 Pôr na app as questões grátis publicadas

No servidor:

```bash
cd /srv/aprova/app/backend && npm run exportar:app -- --saida /tmp/conteudo-app
```

No teu PC:

```powershell
cd "C:\Users\Estagiario\Desktop\FILIPE TAREMBA\COEL\aprenda-mais\mobile"
Remove-Item -Recurse -Force assets\content
scp -r utilizador@IP-DO-SERVIDOR:/tmp/conteudo-app assets\content
```

### 4.2 Criar a chave de assinatura (só na primeira vez)

A Play Store exige que a app seja **assinada**, e que as actualizações usem **sempre a mesma assinatura**.

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v `
  -keystore "C:\Users\Estagiario\aprova-upload.jks" -keyalg RSA -keysize 2048 -validity 10000 -alias aprova
```

Responde às perguntas e escolhe uma password. Depois cria o ficheiro `mobile\android\key.properties` com:

```
storePassword=A_TUA_PASSWORD
keyPassword=A_TUA_PASSWORD
keyAlias=aprova
storeFile=C:/Users/Estagiario/aprova-upload.jks
```

> 🔐 Guarda uma cópia do ficheiro `aprova-upload.jks` e da password (num disco externo ou na nuvem). **Sem eles não consegues actualizar a app na Play Store.**

### 4.3 Subir a versão

No ficheiro `mobile\pubspec.yaml`, a linha `version: 1.0.0+1`:
- `1.0.0` é o número que o estudante vê;
- `+1` **tem de aumentar em cada publicação** (`+2`, `+3`…).

### 4.4 Compilar

Aqui ligas a app ao teu servidor. Usa o **endereço** do servidor e a **`LICENCA_CHAVE_PUBLICA`** do `.env` do servidor:

```powershell
cd "C:\Users\Estagiario\Desktop\FILIPE TAREMBA\COEL\aprenda-mais\mobile"
$api   = "https://api.aprova.co.mz"
$chave = "COLA_AQUI_A_LICENCA_CHAVE_PUBLICA"
$flutter = 'C:\Users\Estagiario\SDK\flutter\bin\flutter.bat'

# Para a Play Store
& $flutter build appbundle --release --dart-define=API_URL=$api --dart-define=LICENCA_CHAVE_PUBLICA=$chave

# Para enviar por WhatsApp / instalar à mão
& $flutter build apk --release --split-per-abi --dart-define=API_URL=$api --dart-define=LICENCA_CHAVE_PUBLICA=$chave
```

Os ficheiros ficam em:
- `mobile\build\app\outputs\bundle\release\app-release.aab` → **Play Store**;
- `mobile\build\app\outputs\flutter-apk\app-arm64-v8a-release.apk` → **instalar directamente** (serve à maioria dos telemóveis).

> ⚠️ Se te esqueceres do `LICENCA_CHAVE_PUBLICA`, as activações dão erro "licença inválida". Se te esqueceres do `API_URL`, a app não encontra o servidor.

### 4.5 Testar num telemóvel real antes de publicar

1. Instala o `.apk` e abre a app **sem Internet**: os níveis 1 e 2 têm de funcionar.
2. Liga a Internet, gera um código no painel, activa-o e confirma que o nível 3 abre.
3. Experimenta "Restaurar compra" noutro telemóvel.

---

## 5. Publicar na Play Store

### 5.1 Antes de começar

- **Conta de programador Google Play** em [play.google.com/console](https://play.google.com/console) (pagamento único de 25 USD).
- **Contas pessoais novas:** antes de publicar para todos, é obrigatório um **teste fechado com pelo menos 12 pessoas durante 14 dias**. Junta 12 estudantes ou amigos para testar.
- Uma página com a **política de privacidade**. Pode ser simples, a dizer que a app guarda tudo no telemóvel e que, ao activar um código, envia o código, o nome e o telefone (opcionais) só para gerir a compra.
- **Imagens:** ícone 512×512, imagem de destaque 1024×500 e 2 a 8 capturas de ecrã do telemóvel.

> O ícone da app ainda é o do Flutter. Troca-o pelo logótipo do Aprova+ antes de publicar (o pacote `flutter_launcher_icons` faz isto).

### 5.2 Passos na Play Console

1. **Criar app** → nome "Aprova+", idioma Português, tipo **App**, **Gratuita**. As compras são feitas fora da loja, com código.
2. **Ficha da loja principal:** descrição curta, descrição completa, ícone, imagem de destaque e capturas.
3. **Conteúdo da app** (responder a cada ponto):
   - **Política de privacidade:** o link da tua página.
   - **Anúncios:** "Não".
   - **Classificação de conteúdo:** preencher o questionário (app educativa).
   - **Público-alvo:** 16+ (estudantes do ensino secundário e pré-universitários).
   - **Segurança dos dados:** a app recolhe, de forma **opcional**, o **nome** e o **número de telefone**, e um identificador do dispositivo, para **gerir a conta e as compras**. Não são partilhados com terceiros. São enviados com encriptação (HTTPS).
4. **Testes → Teste interno:** carrega o `.aab`, junta o teu email e instala pela Play Store para confirmar.
5. **Teste fechado:** os 12 testadores durante 14 dias (contas pessoais novas).
6. **Produção:** carrega o mesmo `.aab` (ou uma versão nova) e envia para revisão. A Google costuma demorar de algumas horas a alguns dias.
7. Em **Configuração → Integridade da app**, deixa activa a **Assinatura de apps pelo Google Play**. Protege-te se perderes a chave.

### 5.3 Actualizações

| O que mudou | O que fazer |
|---|---|
| **Questões pagas** (níveis 3–10) | No painel: publicar → **Pacotes → Publicar prova**. Os estudantes recebem em "Verificar actualizações". **Não precisa de nova versão.** |
| **Preços ou números de pagamento** | No painel (preços) ou no `.env` (números). **Não precisa de nova versão.** |
| **Questões grátis** (níveis 1–2) ou o funcionamento da app | Repetir o passo 4 (exportar, subir a versão, compilar) e carregar o `.aab` novo na Play Console. |

---

## 6. Lista final

**Pagamento**
- [ ] Números M-Pesa/e-Mola/WhatsApp reais no `.env`.
- [ ] Preços confirmados no painel.

**Servidor**
- [ ] `https://api.aprova.co.mz/health` responde.
- [ ] Painel abre com uma password forte.
- [ ] Questões publicadas e pacotes publicados.
- [ ] Cópia do `.env` guardada fora do servidor.
- [ ] Cópias de segurança diárias activas.

**App**
- [ ] Conteúdo grátis exportado do servidor (só questões publicadas).
- [ ] Chave `.jks` criada e guardada em lugar seguro.
- [ ] Versão subida no `pubspec.yaml`.
- [ ] Compilada com `API_URL` e `LICENCA_CHAVE_PUBLICA` de produção.
- [ ] Testada num telemóvel real (sem Internet, activação, restaurar).

**Play Store**
- [ ] Ícone do Aprova+, política de privacidade e ficha da loja.
- [ ] Teste interno → teste fechado (12 pessoas, 14 dias) → produção.

**Antes de vender**
- [ ] Confirmar que tens autorização para usar o conteúdo dos exames.
