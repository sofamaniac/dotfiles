local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local pi = ls.parent_indexer
local isn = require("luasnip.nodes.snippet").ISN
local psn = require("luasnip.nodes.snippet").PSN
local l = require'luasnip.extras'.l
local r = require'luasnip.extras'.rep
local p = require("luasnip.extras").partial
local types = require("luasnip.util.types")
local events = require("luasnip.util.events")
local su = require("luasnip.util.util")

local is_math = function ()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local math_same_char = function(_, _, captures)
  return is_math() and captures[1] == captures[2]
end

local convert_to_label = function(str)
  return str:gsub(" ", "_")
end

local create_sec_fmt = function(trig, cmd, name, label)
  return s(trig,
    fmt(([[
      \%s{<secName>}
      \label{%s:<secLabel>}

        <content>

      %% %s <secName> end
      ]]):format(cmd, label, name),
      { secName = i(1, "section name"),
        secLabel= d(2,
          function (args)
            local lab = convert_to_label(args[1][1])
            return sn(nil, t(lab))
          end, 
          {1}
        ),
        content=i(3, "")
      },
      { repeat_duplicates = true, delimiters = "<>"}
    )
  )
end

local snips = {

  s("beg", fmt([[
  \begin{<env>}

    <content>

  \end{<env>}
  ]], { env=i(1, "env"), content=i(2, "content") }, { repeat_duplicates = true, delimiters= "<>" }
  )),

  s({trig="\\c(%w)(%w)", regTrig=true},
    f(function (_, snip) return "\\mathcal{"..snip.captures[1].."}" end),
    {condition=math_same_char, show_condition=is_math}
  ),

  s({trig="\\(%w)(%w)", regTrig=true},
    f(function (_, snip) return "\\mathbb{"..snip.captures[1].."}" end),
    {condition=math_same_char, show_condition=is_math}
  ),

  create_sec_fmt("sec", "section", "section", "sec"),
  create_sec_fmt("sub", "subsection", "subsection", "sub"),



  -- --- lemon moll_snippets
  -- ls.parser.parse_snippet({trig = ";"}, "\\$$1\\$$0"),
  -- s({trig = "(s*)sec", wordTrig = true, regTrig = true}, {
  --     f(function(args) return {"\\"..string.rep("sub", string.len(args[1].captures[1]))} end, {}),
  --     t({"section{"}), i(1), t({"}", ""}), i(0)
  -- }),
  -- ls.parser.parse_snippet({trig = "beg", wordTrig = true}, "\\begin{$1}\n\t$2\n\\end{$1}"),
  -- ls.parser.parse_snippet({trig = "beq", wordTrig = true}, "\\begin{equation*}\n\t$1\n\\end{equation*}"),
  -- ls.parser.parse_snippet({trig = "bal", wordTrig = true}, "\\begin{aligned}\n\t$1\n\\end{aligned}"),
  -- ls.parser.parse_snippet({trig = "ab", wordTrig = true}, "\\langle $1 \\rangle"),
  -- ls.parser.parse_snippet({trig = "lra", wordTrig = true}, "\\leftrightarrow"),
  -- ls.parser.parse_snippet({trig = "Lra", wordTrig = true}, "\\Leftrightarrow"),
  -- ls.parser.parse_snippet({trig = "fr", wordTrig = true}, "\\frac{$1}{$2}"),
  -- ls.parser.parse_snippet({trig = "tr", wordTrig = true}, "\\item $1"),
  -- ls.parser.parse_snippet({trig = "abs", wordTrig = true}, "\\|$1\\|"),
  -- s("ls", {
  --     t({"\\begin{itemize}",
  --         "\t\\item "}), i(1), d(2, rec_ls, {}),
  --     t({"", "\\end{itemize}"}), i(0)
  -- })
}

local auto = {
  s({trig="//", dscr="fraction"},
    fmt("\\frac{<>}{<>}",
      {i(1,""), i(2,"")}, {delimiters= "<>"}),
    {condition= is_math, }
    ),
  s({trig = "td", wordTrig= false},
    fmt("^{<pow>}",
      { pow=i(1, "") }, {delimiters= "<>"}),
    {condition=is_math,}
  ),
  s("mk", fmt("${}$", { i(1, "")})),
  s({trig="_", wordTrig= false},
    fmt("_{<>}", {i(1, "")}, {delimiters= "<>"}),
    {condition=is_math}
  ),
}

return snips, auto
