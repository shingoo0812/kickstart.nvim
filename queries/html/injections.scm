; 既存のデフォルトを継承
(script_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value
        (attribute_value) @_type))
    (#eq? @_attr "type")
    (#any-of? @_type "text/javascript" "text/babel" "module"))
  (raw_text) @injection.content
  (#set! injection.language "javascript"))

; type属性なしのscriptタグ
(script_element
  (start_tag
    (tag_name))
  (raw_text) @injection.content
  (#set! injection.language "javascript"))