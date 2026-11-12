-- CreateTable
CREATE TABLE "grupos_exame" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL,
    "tem_gabarito" BOOLEAN NOT NULL DEFAULT false
);

-- CreateTable
CREATE TABLE "instituicoes" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "sigla" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "grupo_exame" TEXT NOT NULL,
    "provincias" TEXT NOT NULL DEFAULT '[]',
    "edital_ano" INTEGER,
    CONSTRAINT "instituicoes_grupo_exame_fkey" FOREIGN KEY ("grupo_exame") REFERENCES "grupos_exame" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "disciplinas" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL,
    "aliases" TEXT NOT NULL DEFAULT '[]',
    "icone" TEXT
);

-- CreateTable
CREATE TABLE "temas" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "disciplina" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    CONSTRAINT "temas_disciplina_fkey" FOREIGN KEY ("disciplina") REFERENCES "disciplinas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "provas" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "grupo_exame" TEXT NOT NULL,
    "disciplina" TEXT NOT NULL,
    "variante" TEXT,
    "tipo" TEXT NOT NULL DEFAULT 'escrita',
    "nome" TEXT NOT NULL,
    "duracao_min" INTEGER,
    "num_questoes" INTEGER,
    "num_alternativas" INTEGER,
    "nota" TEXT,
    CONSTRAINT "provas_grupo_exame_fkey" FOREIGN KEY ("grupo_exame") REFERENCES "grupos_exame" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "provas_disciplina_fkey" FOREIGN KEY ("disciplina") REFERENCES "disciplinas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "cursos" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL,
    "icone" TEXT
);

-- CreateTable
CREATE TABLE "ofertas" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "slug" TEXT NOT NULL,
    "curso" TEXT NOT NULL,
    "instituicao" TEXT NOT NULL,
    "nome_original" TEXT NOT NULL,
    "faculdade" TEXT NOT NULL DEFAULT '',
    "locais" TEXT NOT NULL DEFAULT '[]',
    "regimes" TEXT NOT NULL DEFAULT '[]',
    "modelo_exame" TEXT,
    "vagas" TEXT NOT NULL DEFAULT '[]',
    "fonte_ficheiro" TEXT,
    "fonte_pagina" INTEGER,
    CONSTRAINT "ofertas_curso_fkey" FOREIGN KEY ("curso") REFERENCES "cursos" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ofertas_instituicao_fkey" FOREIGN KEY ("instituicao") REFERENCES "instituicoes" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "oferta_prova" (
    "oferta" TEXT NOT NULL,
    "prova" TEXT NOT NULL,
    "peso" INTEGER,
    "ordem" INTEGER NOT NULL DEFAULT 0,

    PRIMARY KEY ("oferta", "prova"),
    CONSTRAINT "oferta_prova_oferta_fkey" FOREIGN KEY ("oferta") REFERENCES "ofertas" ("codigo") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "oferta_prova_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "niveis" (
    "prova" TEXT NOT NULL,
    "numero" INTEGER NOT NULL,
    "titulo" TEXT NOT NULL,
    "descricao" TEXT,
    "nota_minima" INTEGER,

    PRIMARY KEY ("prova", "numero"),
    CONSTRAINT "niveis_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "textos_base" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "titulo" TEXT,
    "texto" TEXT NOT NULL,
    "fonte" TEXT
);

-- CreateTable
CREATE TABLE "questoes" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "disciplina" TEXT NOT NULL,
    "tema" TEXT,
    "texto_base" TEXT,
    "tipo" TEXT NOT NULL,
    "enunciado" TEXT NOT NULL,
    "imagens" TEXT NOT NULL DEFAULT '[]',
    "dica" TEXT,
    "explicacao" TEXT NOT NULL,
    "explicacao_origem" TEXT,
    "explicacao_revista" BOOLEAN NOT NULL DEFAULT false,
    "resposta_origem" TEXT,
    "resposta_confianca" TEXT,
    "dificuldade" INTEGER,
    "ano" INTEGER,
    "variante" TEXT,
    "numero_original" INTEGER,
    "fonte_ficheiro" TEXT,
    "fonte_pagina" INTEGER,
    "estado" TEXT NOT NULL DEFAULT 'rascunho',
    "alertas" TEXT NOT NULL DEFAULT '[]',
    "criado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actualizado_em" DATETIME NOT NULL,
    CONSTRAINT "questoes_disciplina_fkey" FOREIGN KEY ("disciplina") REFERENCES "disciplinas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "questoes_tema_fkey" FOREIGN KEY ("tema") REFERENCES "temas" ("codigo") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "questoes_texto_base_fkey" FOREIGN KEY ("texto_base") REFERENCES "textos_base" ("codigo") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "questao_prova" (
    "questao" TEXT NOT NULL,
    "prova" TEXT NOT NULL,
    "nivel" INTEGER,

    PRIMARY KEY ("questao", "prova"),
    CONSTRAINT "questao_prova_questao_fkey" FOREIGN KEY ("questao") REFERENCES "questoes" ("codigo") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "questao_prova_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "alternativas" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "questao" TEXT NOT NULL,
    "letra" TEXT NOT NULL,
    "texto" TEXT,
    "imagem" TEXT,
    "correcta" BOOLEAN NOT NULL DEFAULT false,
    "ordem" INTEGER NOT NULL,
    CONSTRAINT "alternativas_questao_fkey" FOREIGN KEY ("questao") REFERENCES "questoes" ("codigo") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "simulados" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "prova" TEXT,
    "oferta" TEXT,
    "titulo" TEXT NOT NULL,
    "duracao_min" INTEGER NOT NULL,
    "num_perguntas" INTEGER NOT NULL,
    "gratuito" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "simulados_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "simulados_oferta_fkey" FOREIGN KEY ("oferta") REFERENCES "ofertas" ("codigo") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "produtos" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "tipo" TEXT NOT NULL,
    "preco_mt" INTEGER NOT NULL,
    "epoca" TEXT,
    "ordem" INTEGER NOT NULL DEFAULT 0,
    "activo" BOOLEAN NOT NULL DEFAULT true
);

-- CreateTable
CREATE TABLE "produto_prova" (
    "produto" TEXT NOT NULL,
    "prova" TEXT NOT NULL,

    PRIMARY KEY ("produto", "prova"),
    CONSTRAINT "produto_prova_produto_fkey" FOREIGN KEY ("produto") REFERENCES "produtos" ("codigo") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "produto_prova_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "admins" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "nome" TEXT,
    "password_hash" TEXT NOT NULL,
    "papel" TEXT NOT NULL DEFAULT 'admin',
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "criado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ultimo_login" DATETIME
);

-- CreateTable
CREATE TABLE "estudantes" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT,
    "telefone" TEXT,
    "criado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "codigos_activacao" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "codigo_hash" TEXT NOT NULL,
    "codigo_final" TEXT NOT NULL,
    "produto" TEXT NOT NULL,
    "estado" TEXT NOT NULL DEFAULT 'disponivel',
    "validade_ate" DATETIME,
    "criado_por" INTEGER,
    "criado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usado_por_estudante_id" TEXT,
    "usado_em" DATETIME,
    "dispositivo_id" TEXT,
    "nota" TEXT,
    CONSTRAINT "codigos_activacao_produto_fkey" FOREIGN KEY ("produto") REFERENCES "produtos" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "codigos_activacao_criado_por_fkey" FOREIGN KEY ("criado_por") REFERENCES "admins" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "codigos_activacao_usado_por_estudante_id_fkey" FOREIGN KEY ("usado_por_estudante_id") REFERENCES "estudantes" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "licencas" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "estudante" TEXT NOT NULL,
    "produto" TEXT NOT NULL,
    "codigo_id" INTEGER,
    "valido_ate" DATETIME,
    "conteudo" TEXT NOT NULL,
    "assinatura" TEXT NOT NULL,
    "revogada" BOOLEAN NOT NULL DEFAULT false,
    "criada_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "licencas_estudante_fkey" FOREIGN KEY ("estudante") REFERENCES "estudantes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "licencas_produto_fkey" FOREIGN KEY ("produto") REFERENCES "produtos" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "licencas_codigo_id_fkey" FOREIGN KEY ("codigo_id") REFERENCES "codigos_activacao" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "pacotes" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "prova" TEXT NOT NULL,
    "versao" INTEGER NOT NULL,
    "ficheiro" TEXT NOT NULL,
    "sha256" TEXT NOT NULL,
    "tamanho_bytes" INTEGER NOT NULL,
    "num_questoes" INTEGER NOT NULL,
    "publicado_em" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "publicado_por" INTEGER,
    CONSTRAINT "pacotes_prova_fkey" FOREIGN KEY ("prova") REFERENCES "provas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "sessoes" (
    "sid" TEXT NOT NULL PRIMARY KEY,
    "dados" TEXT NOT NULL,
    "expira" DATETIME NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "ofertas_slug_key" ON "ofertas"("slug");

-- CreateIndex
CREATE INDEX "questoes_estado_idx" ON "questoes"("estado");

-- CreateIndex
CREATE INDEX "questao_prova_prova_nivel_idx" ON "questao_prova"("prova", "nivel");

-- CreateIndex
CREATE UNIQUE INDEX "alternativas_questao_letra_key" ON "alternativas"("questao", "letra");

-- CreateIndex
CREATE UNIQUE INDEX "admins_email_key" ON "admins"("email");

-- CreateIndex
CREATE INDEX "estudantes_telefone_idx" ON "estudantes"("telefone");

-- CreateIndex
CREATE UNIQUE INDEX "codigos_activacao_codigo_hash_key" ON "codigos_activacao"("codigo_hash");

-- CreateIndex
CREATE INDEX "codigos_activacao_estado_idx" ON "codigos_activacao"("estado");

-- CreateIndex
CREATE UNIQUE INDEX "pacotes_prova_versao_key" ON "pacotes"("prova", "versao");

-- CreateIndex
CREATE INDEX "sessoes_expira_idx" ON "sessoes"("expira");
