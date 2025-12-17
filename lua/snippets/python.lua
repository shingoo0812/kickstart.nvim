local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

return {

  -- main 関数テンプレート
  s(
    'main',
    fmt(
      [[
def main() -> None:
    {}

if __name__ == '__main__':
    main()
]],
      { i(1, 'pass') }
    )
  ),

  -- ファイル読み込みテンプレート
  s(
    'openfile',
    fmt(
      [[
with open("{}", "{}") as {}:
    {} = {}.read()
    {}
]],
      {
        i(1, 'filename.txt'), -- ファイル名
        i(2, 'r'), -- モード
        i(3, 'f'), -- ファイルオブジェクト
        i(4, '_file'), -- 読み込む内容を格納
        rep(3), -- f.read() の f と同じ
        i(5, 'pass'), -- 任意の処理
      }
    )
  ),

  -- ファイル書き込みテンプレート
  s(
    'writefile',
    fmt(
      [[
with open("{}", "{}") as {}:
    {}.write({})
    {}
]],
      {
        i(1, 'filename.txt'),
        i(2, 'w'),
        i(3, 'f'),
        rep(3),
        i(4, 'content'),
        i(5, 'pass'),
      }
    )
  ),

  -- JSON 読み込み
  s(
    'jsonload',
    fmt(
      [[
import json

with open("{}", "{}") as {}:
    {} = json.load({})
    {}
]],
      {
        i(1, 'data.json'),
        i(2, 'r'),
        i(3, 'f'),
        i(4, 'data'),
        rep(3),
        i(5, 'pass'),
      }
    )
  ),

  -- JSON 書き込み
  s(
    'jsondump',
    fmt(
      [[
import json

with open("{}", "{}") as {}:
    json.dump({}, {}, indent={})
    {}
]],
      {
        i(1, 'data.json'),
        i(2, 'w'),
        i(3, 'f'),
        i(4, 'data'), -- 書き込むデータ
        rep(3),
        i(5, '4'), -- indent
        i(6, 'pass'),
      }
    )
  ),

  -- CSV 読み込み
  s(
    'csvread',
    fmt(
      [[
import csv

with open("{}", "{}") as {}:
    reader = csv.reader({})
    {} = list(reader)
    {}
]],
      {
        i(1, 'data.csv'),
        i(2, 'r'),
        i(3, 'f'),
        rep(3),
        i(4, 'rows'),
        i(5, 'pass'),
      }
    )
  ),

  -- CSV 書き込み
  s(
    'csvwrite',
    fmt(
      [[
import csv

with open("{}", "{}", newline="") as {}:
    writer = csv.writer({})
    writer.writerows({})
    {}
]],
      {
        i(1, 'data.csv'),
        i(2, 'w'),
        i(3, 'f'),
        rep(3),
        i(4, 'rows'),
        i(5, 'pass'),
      }
    )
  ),

  -- Python クラス作成スニペット
  s(
    'class',
    fmt(
      [[
class {}({}):
    """
    {}
    """
    def __init__(self, {}):
        {}
        {}
    
    {}
]],
      {
        i(1, 'MyClass'), -- クラス名
        i(2, 'object'), -- 継承クラス
        i(3, 'クラス説明'), -- docstring
        i(4, 'arg1'), -- __init__ の引数
        i(5, 'self.arg1 = arg1'), -- __init__ 内の処理
        i(6, 'pass'), -- __init__ の残り処理
        i(7, 'def method(self):\n        pass'), -- メソッド追加用
      }
    )
  ),
  -- PySide6 アプリ起動スニペット
  s(
    'pyside',
    fmt(
      [[
  import sys

  from PySide6 import QtWidgets
  from {} import {}

  app = QtWidgets.QApplication(sys.argv)

  window = {}()
  window.show()

  app.exec()
  ]],
      {
        i(1, 'widget'), -- モジュール名
        i(2, 'Widget'), -- クラス名
        i(3, 'Widget'), -- インスタンス生成クラス
      }
    )
  ),
}
