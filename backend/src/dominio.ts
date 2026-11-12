/** Valores permitidos e regras de conteúdo, partilhados pelo admin e pelo importador. */

export const TIPOS_QUESTAO = ['escolha_multipla', 'verdadeiro_falso'] as const;
export type TipoQuestao = (typeof TIPOS_QUESTAO)[number];

export const ESTADOS_QUESTAO = ['rascunho', 'revista', 'publicada'] as const;
export type EstadoQuestao = (typeof ESTADOS_QUESTAO)[number];

export const TIPOS_PRODUTO = ['niveis', 'simulados'] as const;
export const ORIGENS_RESPOSTA = ['gabarito_oficial', 'proposta_ia'] as const;
export const CONFIANCAS = ['alta', 'media', 'baixa'] as const;

export const LETRAS_EM = ['A', 'B', 'C', 'D', 'E'] as const;
export const LETRAS_VF = ['V', 'F'] as const;

/** Escolha múltipla: 4 por omissão; 5 aceite porque os exames da UEM têm 5. */
export const MIN_ALTERNATIVAS_EM = 4;
export const MAX_ALTERNATIVAS_EM = 5;
export const NUM_NIVEIS = 10;

export const LABEL_ESTADO: Record<string, string> = {
  rascunho: 'Rascunho',
  revista: 'Revista',
  publicada: 'Publicada',
};

export function listaJson(v: string | null | undefined): string[] {
  if (!v) return [];
  try {
    const x = JSON.parse(v);
    return Array.isArray(x) ? x.map(String) : [];
  } catch {
    return [];
  }
}

export interface AlternativaEntrada {
  letra: string;
  texto: string | null;
  imagem: string | null;
  correcta: boolean;
}

export interface QuestaoEntrada {
  tipo: string;
  enunciado: string;
  explicacao: string | null;
  dica?: string | null;
  estado: string;
  alternativas: AlternativaEntrada[];
  dificuldade?: number | null;
  nivel?: number | null;
}

/** Conta `$` não escapados; fórmulas `$...$` e `$$...$$` têm de fechar. */
export function latexEquilibrado(texto: string | null | undefined): boolean {
  if (!texto) return true;
  const semEscapes = texto.replace(/\\\$/g, '');
  return (semEscapes.match(/\$/g) ?? []).length % 2 === 0;
}

/** Regras de uma questão. Devolve a lista de erros (vazia = válida). */
export function validarRegrasQuestao(q: QuestaoEntrada): string[] {
  const erros: string[] = [];
  if (!TIPOS_QUESTAO.includes(q.tipo as TipoQuestao)) erros.push(`Tipo inválido: ${q.tipo}`);
  if (!ESTADOS_QUESTAO.includes(q.estado as EstadoQuestao)) erros.push(`Estado inválido: ${q.estado}`);
  if (!q.enunciado?.trim()) erros.push('O enunciado é obrigatório.');
  if (!q.explicacao?.trim()) erros.push('A explicação é obrigatória.');

  const alts = q.alternativas;
  if (q.tipo === 'verdadeiro_falso') {
    if (alts.length !== 2) erros.push('Verdadeiro/Falso tem de ter exactamente 2 alternativas.');
  } else if (q.tipo === 'escolha_multipla') {
    if (alts.length < MIN_ALTERNATIVAS_EM || alts.length > MAX_ALTERNATIVAS_EM)
      erros.push(`Escolha múltipla tem de ter ${MIN_ALTERNATIVAS_EM} ou ${MAX_ALTERNATIVAS_EM} alternativas (tem ${alts.length}).`);
  }
  const letras = alts.map((a) => a.letra);
  if (new Set(letras).size !== letras.length) erros.push('Há letras de alternativas repetidas.');
  alts.forEach((a) => {
    if (!a.texto?.trim() && !a.imagem) erros.push(`A alternativa ${a.letra} está vazia (sem texto nem imagem).`);
  });

  const correctas = alts.filter((a) => a.correcta).length;
  // Só o rascunho pode ficar sem resposta (ex.: questão importada sem gabarito).
  if (correctas > 1) erros.push(`Só pode haver 1 alternativa correcta (há ${correctas}).`);
  if (correctas === 0 && q.estado !== 'rascunho') erros.push('Indica a alternativa correcta.');

  if (q.dificuldade != null && (q.dificuldade < 1 || q.dificuldade > 5)) erros.push('A dificuldade vai de 1 a 5.');
  if (q.nivel != null && (q.nivel < 1 || q.nivel > NUM_NIVEIS)) erros.push(`O nível vai de 1 a ${NUM_NIVEIS}.`);

  const textos: [string, string | null | undefined][] = [
    ['enunciado', q.enunciado],
    ['explicação', q.explicacao],
    ['dica', q.dica],
    ...alts.map((a): [string, string | null] => [`alternativa ${a.letra}`, a.texto]),
  ];
  for (const [onde, t] of textos) if (!latexEquilibrado(t)) erros.push(`LaTeX com $ desequilibrados na ${onde}.`);
  return erros;
}

/** Normaliza texto para código: "Engenharia Informática" → "ENGENHARIA-INFORMATICA". */
export function paraCodigo(texto: string): string {
  return texto
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toUpperCase()
    .replace(/[^A-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}
