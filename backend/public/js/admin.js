// Aprova+ Admin — pequenos comportamentos (sem dependências; KaTeX só na página da questão).
(function () {
  'use strict';

  // Confirmação antes de submeter formulários perigosos (ou botões com data-confirmar)
  document.addEventListener('submit', function (e) {
    var alvo = e.submitter && e.submitter.dataset.confirmar ? e.submitter : e.target;
    var msg = alvo.dataset && alvo.dataset.confirmar;
    if (msg && !window.confirm(msg)) e.preventDefault();
  });

  // <select data-submeter> submete o formulário ao mudar
  document.querySelectorAll('select[data-submeter]').forEach(function (s) {
    s.addEventListener('change', function () { s.form.submit(); });
  });

  // Seleccionar todas as linhas
  document.querySelectorAll('[data-todas]').forEach(function (c) {
    c.addEventListener('change', function () {
      c.closest('form').querySelectorAll('input[name="codigos"]').forEach(function (x) { x.checked = c.checked; });
    });
  });

  // Copiar para a área de transferência
  document.querySelectorAll('[data-copiar]').forEach(function (b) {
    b.addEventListener('click', function () {
      var texto = b.dataset.copiar;
      var feito = function () { var t = b.textContent; b.textContent = 'Copiado ✓'; setTimeout(function () { b.textContent = t; }, 1500); };
      if (navigator.clipboard && window.isSecureContext) navigator.clipboard.writeText(texto).then(feito);
      else {
        var ta = document.createElement('textarea');
        ta.value = texto; document.body.appendChild(ta); ta.select();
        try { document.execCommand('copy'); feito(); } finally { ta.remove(); }
      }
    });
  });

  // Descarregar o conteúdo de um <textarea> como ficheiro (ex.: CSV dos códigos gerados)
  document.querySelectorAll('[data-descarregar]').forEach(function (b) {
    b.addEventListener('click', function () {
      var alvo = document.querySelector(b.dataset.alvo);
      var blob = new Blob(['﻿' + alvo.value], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = b.dataset.descarregar;
      document.body.appendChild(a); a.click(); a.remove();
    });
  });

  // ───── Formulário da questão ─────
  var form = document.getElementById('form-questao');
  if (!form) return;

  var $ = function (id) { return document.getElementById(id); };
  var tipo = $('tipo');
  var prova = $('prova');
  var tema = $('tema');

  function escapar(t) {
    return String(t || '')
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/\*\*(.+?)\*\*/g, '<b>$1</b>')
      .replace(/\n/g, '<br>');
  }

  function matematica(el) {
    if (window.renderMathInElement) {
      window.renderMathInElement(el, {
        delimiters: [
          { left: '$$', right: '$$', display: true },
          { left: '$', right: '$', display: false }
        ],
        throwOnError: false
      });
    }
  }

  function previa() {
    var vf = tipo.value === 'verdadeiro_falso';
    $('bloco-em').classList.toggle('oculto', vf);
    $('bloco-vf').classList.toggle('oculto', !vf);

    var en = $('p-enunciado');
    en.innerHTML = escapar(form.enunciado.value);
    var ficheiro = $('imagem').files[0];
    if (ficheiro) {
      var img = document.createElement('img');
      img.src = URL.createObjectURL(ficheiro);
      img.style.marginTop = '8px';
      en.appendChild(img);
    }

    var alts = $('p-alternativas');
    alts.innerHTML = '';
    var linhas;
    if (vf) {
      var c = form.querySelector('input[name="correcta_vf"]:checked');
      linhas = [['V', 'Verdadeiro'], ['F', 'Falso']].map(function (x) { return { letra: x[0], texto: x[1], certa: c && c.value === x[0] }; });
    } else {
      var cc = form.querySelector('input[name="correcta"]:checked');
      linhas = Array.prototype.map.call(form.querySelectorAll('input[data-letra]'), function (i) {
        return { letra: i.dataset.letra, texto: i.value, certa: cc && cc.value === i.dataset.letra };
      }).filter(function (a, i) { return i < 4 || a.texto.trim(); });
    }
    linhas.forEach(function (a) {
      var d = document.createElement('div');
      d.className = 'op' + (a.certa ? ' certa' : '');
      d.innerHTML = '<b>' + a.letra + ')</b> ' + escapar(a.texto);
      alts.appendChild(d);
    });

    $('p-dica').innerHTML = escapar(form.dica.value);
    $('p-dica-wrap').classList.toggle('oculto', !form.dica.value.trim());
    $('p-explicacao').innerHTML = escapar(form.explicacao.value);
    matematica($('p-enunciado').parentNode);
  }

  // Só mostrar os temas da disciplina da prova escolhida
  function filtrarTemas() {
    var opt = prova.options[prova.selectedIndex];
    var disc = opt && opt.dataset.disciplina;
    Array.prototype.forEach.call(tema.options, function (o) {
      if (!o.value) return;
      o.hidden = !!disc && o.dataset.disciplina !== disc;
    });
    var sel = tema.options[tema.selectedIndex];
    if (sel && sel.hidden) tema.value = '';
  }

  var atraso;
  form.addEventListener('input', function () { clearTimeout(atraso); atraso = setTimeout(previa, 200); });
  form.addEventListener('change', previa);
  prova.addEventListener('change', filtrarTemas);
  filtrarTemas();
  // O KaTeX carrega com defer: esperar por ele
  window.addEventListener('load', previa);
})();
