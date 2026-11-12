-- CreateTable
CREATE TABLE "tokens_estudante" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "token_hash" TEXT NOT NULL,
    "estudante" TEXT NOT NULL,
    "dispositivo_id" TEXT,
    "criado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ultimo_uso" DATETIME,
    "revogado" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "tokens_estudante_estudante_fkey" FOREIGN KEY ("estudante") REFERENCES "estudantes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_codigos_activacao" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "codigo_hash" TEXT NOT NULL,
    "codigo_final" TEXT NOT NULL,
    "tipo" TEXT NOT NULL DEFAULT 'activacao',
    "produto" TEXT,
    "para_estudante_id" TEXT,
    "estado" TEXT NOT NULL DEFAULT 'disponivel',
    "validade_ate" DATETIME,
    "criado_por" INTEGER,
    "criado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usado_por_estudante_id" TEXT,
    "usado_em" DATETIME,
    "dispositivo_id" TEXT,
    "nota" TEXT,
    CONSTRAINT "codigos_activacao_produto_fkey" FOREIGN KEY ("produto") REFERENCES "produtos" ("codigo") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "codigos_activacao_criado_por_fkey" FOREIGN KEY ("criado_por") REFERENCES "admins" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "codigos_activacao_usado_por_estudante_id_fkey" FOREIGN KEY ("usado_por_estudante_id") REFERENCES "estudantes" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_codigos_activacao" ("codigo_final", "codigo_hash", "criado_em", "criado_por", "dispositivo_id", "estado", "id", "nota", "produto", "usado_em", "usado_por_estudante_id", "validade_ate") SELECT "codigo_final", "codigo_hash", "criado_em", "criado_por", "dispositivo_id", "estado", "id", "nota", "produto", "usado_em", "usado_por_estudante_id", "validade_ate" FROM "codigos_activacao";
DROP TABLE "codigos_activacao";
ALTER TABLE "new_codigos_activacao" RENAME TO "codigos_activacao";
CREATE UNIQUE INDEX "codigos_activacao_codigo_hash_key" ON "codigos_activacao"("codigo_hash");
CREATE INDEX "codigos_activacao_estado_idx" ON "codigos_activacao"("estado");
CREATE TABLE "new_pacotes" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "prova" TEXT NOT NULL,
    "versao" INTEGER NOT NULL,
    "ficheiro" TEXT NOT NULL,
    "sha256" TEXT NOT NULL,
    "conteudo_sha256" TEXT NOT NULL DEFAULT '',
    "tamanho_bytes" INTEGER NOT NULL,
    "num_questoes" INTEGER NOT NULL,
    "publicado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "publicado_por" INTEGER,
    CONSTRAINT "pacotes_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_pacotes" ("ficheiro", "id", "num_questoes", "prova", "publicado_em", "publicado_por", "sha256", "tamanho_bytes", "versao") SELECT "ficheiro", "id", "num_questoes", "prova", "publicado_em", "publicado_por", "sha256", "tamanho_bytes", "versao" FROM "pacotes";
DROP TABLE "pacotes";
ALTER TABLE "new_pacotes" RENAME TO "pacotes";
CREATE UNIQUE INDEX "pacotes_prova_versao_key" ON "pacotes"("prova", "versao");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "tokens_estudante_token_hash_key" ON "tokens_estudante"("token_hash");
