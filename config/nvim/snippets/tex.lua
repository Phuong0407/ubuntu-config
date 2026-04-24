local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function label(args)
  return args[1][1]:lower():gsub("%s+", "_")
end

local function title(args)
  return args[1][1]
end

local in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

ls.add_snippets("tex", {
  -- ── Structure ──────────────────────────────────────────────
  s("part", {
    t("\\part{"),
    i(1),
    t("}"),
    t("\\label{part:"),
    f(label, { 1 }),
    t("} % (fold)"),
    t({ "", "% part " }),
    f(title, { 1 }),
    t(" (end)"),
  }),
  s("cha", {
    t("\\chapter{"),
    i(1),
    t("}"),
    t("\\label{chap:"),
    f(label, { 1 }),
    t("} % (fold)"),
    t({ "", "% chapter " }),
    f(title, { 1 }),
    t(" (end)"),
  }),
  s("sec", {
    t("\\section{"),
    i(1),
    t("}"),
    t("\\label{sec:"),
    f(label, { 1 }),
    t("} % (fold)"),
    t({ "", "% section " }),
    f(title, { 1 }),
    t(" (end)"),
  }),
  s("sub", {
    t("\\subsection{"),
    i(1),
    t("}"),
    t("\\label{sub:"),
    f(label, { 1 }),
    t("} % (fold)"),
    t({ "", "% subsection " }),
    f(title, { 1 }),
    t(" (end)"),
  }),
  s("ssub", {
    t("\\subsubsection{"),
    i(1),
    t("}"),
    t("\\label{ssub:"),
    f(label, { 1 }),
    t("} % (fold)"),
    t({ "", "% subsubsection " }),
    f(title, { 1 }),
    t(" (end)"),
  }),

  -- ── Environments ───────────────────────────────────────────
  s("beg", {
    t("\\begin{"),
    i(1, "env"),
    t("}"),
    t({ "", "\t" }),
    i(2),
    t({ "", "\\end{" }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t("}"),
  }),
  s("eq", { t({ "\\begin{equation}", "\t" }), i(1), t({ "", "\\end{equation}" }) }),
  s("eq*", { t({ "\\begin{equation*}", "\t" }), i(1), t({ "", "\\end{equation*}" }) }),
  s("aln", { t({ "\\begin{align}", "\t" }), i(1), t({ "", "\\end{align}" }) }),
  s("als", { t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }) }),
  s("itm", { t({ "\\begin{itemize}", "\t\\item " }), i(1), t({ "", "\\end{itemize}" }) }),
  s("enum", { t({ "\\begin{enumerate}", "\t\\item " }), i(1), t({ "", "\\end{enumerate}" }) }),
  s("mat", { t({ "\\begin{pmatrix}", "\t" }), i(1), t({ "", "\\end{pmatrix}" }) }),

  -- ── Math ───────────────────────────────────────────────────
  s("mk", { t("$"), i(1), t("$") }),
  s("dm", { t({ "\\[", "\t" }), i(1), t({ "", "\\]" }) }),
  s("frac", { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
  s("sq", { t("\\sqrt{"), i(1), t("}") }),
  s("sum", { t("\\sum_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("}") }),
  s("int", { t("\\int_{"), i(1, "0"), t("}^{"), i(2, "\\infty"), t("} "), i(3), t(" \\, d"), i(4, "x") }),
  s("lim", { t("\\lim_{"), i(1, "n \\to \\infty"), t("} "), i(2) }),

  -- ── Derivatives ────────────────────────────────────────────
  s("pd", { t("\\frac{\\partial "), i(1), t("}{\\partial "), i(2), t("}") }),
  s("dd", { t("\\frac{d"), i(1), t("}{d"), i(2), t("}") }),

  -- ── Operators ──────────────────────────────────────────────
  s("bigo", { t("\\mathcal{O}("), i(1), t(")"), i(2) }),
  s("norm", { t("\\|"), i(1), t("\\|"), i(2) }),
  s("inp", { t("\\langle "), i(1), t(", "), i(2), t(" \\rangle"), i(3) }),
  s("vec", { t("\\vec{"), i(1), t("}"), i(2) }),
  s("bv", { t("\\mathbf{"), i(1), t("}"), i(2) }),
  s("mrm", { t("\\mathrm{"), i(1), t("}"), i(2) }),
  s("avg", { t("\\left\\langle "), i(1), t(" \\right\\rangle"), i(2) }),

  -- ── HPC / Numerics ─────────────────────────────────────────
  s("ns-cont", { t("\\nabla \\cdot \\mathbf{u} = 0") }),
  s("ns-mom", {
    t(
      "\\rho \\left( \\frac{\\partial \\mathbf{u}}{\\partial t} + (\\mathbf{u} \\cdot \\nabla) \\mathbf{u} \\right) = -\\nabla p + \\mu \\nabla^2 \\mathbf{u}"
    ),
  }),

  -- ── Text formatting ────────────────────────────────────────
  s("tbf", { t("\\textbf{"), i(1), t("}") }),
  s("tit", { t("\\textit{"), i(1), t("}") }),
  s("ttt", { t("\\texttt{"), i(1), t("}") }),
  s("lbl", { t("\\label{"), i(1), t("}") }),
  s("rf", { t("\\ref{"), i(1), t("}") }),
  s("erf", { t("\\eqref{"), i(1), t("}") }),
  s("ci", { t("\\cite{"), i(1), t("}") }),

  -- ── Inkscape ───────────────────────────────────────────────
  s("incfig-setup", {
    t({
      "\\usepackage{import}",
      "\\usepackage{xifthen}",
      "\\usepackage{pdfpages}",
      "\\usepackage{transparent}",
      "\\newcommand{\\incfig}[1]{%",
      "    \\def\\svgwidth{\\columnwidth}",
      "    \\import{./figures/}{#1.pdf_tex}",
      "}",
    }),
  }),
  s("incfig", {
    t("\\incfig{"),
    i(1),
    t("}"),
  }),

  -- ── Greek letters ──────────────────────────────────────────
  s(";a", { t("\\alpha") }),
  s(";b", { t("\\beta") }),
  s(";g", { t("\\gamma") }),
  s(";G", { t("\\Gamma") }),
  s(";d", { t("\\delta") }),
  s(";D", { t("\\Delta") }),
  s(";e", { t("\\epsilon") }),
  s(";ve", { t("\\varepsilon") }),
  s(";t", { t("\\theta") }),
  s(";T", { t("\\Theta") }),
  s(";l", { t("\\lambda") }),
  s(";L", { t("\\Lambda") }),
  s(";m", { t("\\mu") }),
  s(";n", { t("\\nu") }),
  s(";p", { t("\\pi") }),
  s(";P", { t("\\Pi") }),
  s(";s", { t("\\sigma") }),
  s(";S", { t("\\Sigma") }),
  s(";o", { t("\\omega") }),
  s(";O", { t("\\Omega") }),

  -- ── Math fonts ──────────────────────────────────────────
  s({ trig = "mscr", snippetType = "autosnippet" }, {
    t("\\mathscr{"),
    i(1),
    t("}"),
  }, { condition = in_mathzone }),
  s({ trig = "mcal", snippetType = "autosnippet" }, {
    t("\\mathcal{"),
    i(1),
    t("}"),
  }, { condition = in_mathzone }),
}, { priority = 2000, key = "custom_tex" })
