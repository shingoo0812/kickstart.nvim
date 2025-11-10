local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  s(
    'main',
    fmt(
      [[
def main() -> None:
    {}


if __name__ == '__main__':
    main()
]],
      {
        i(1, 'pass'),
      }
    )
  ),
}
