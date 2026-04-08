-- lua/snippets/markdown.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Code block
  s("cb", fmt("```{}\n{}\n```", { i(1, "lang"), i(2) })),

  -- Link
  s("lk", fmt("[{}]({})", { i(1, "text"), i(2, "url") })),

  -- Image
  s("img", fmt("![{}]({})", { i(1, "alt"), i(2, "path") })),

  -- Frontmatter
  s("fm", fmt("---\ntitle: {}\ndate: {}\ntags: [{}]\n---", {
    i(1, "Title"),
    i(2, os.date("%Y-%m-%d")),
    i(3),
  })),

  -- Table 3 col
  s("tbl", fmt(
    "| {} | {} | {} |\n|---|---|---|\n| {} | {} | {} |",
    { i(1,"H1"), i(2,"H2"), i(3,"H3"), i(4), i(5), i(6) }
  )),
},
