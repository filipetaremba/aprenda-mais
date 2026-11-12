import { createApp } from './app';
import { config } from './config';
import { PrismaSessionStore } from './seguranca';

const app = createApp();
app.listen(config.porta, () => {
  console.log(`Aprova+ backend em http://localhost:${config.porta}  (admin: /admin)`);
});

// Limpa sessões expiradas de hora a hora
setInterval(() => PrismaSessionStore.limpar().catch(() => undefined), 3600_000).unref();
