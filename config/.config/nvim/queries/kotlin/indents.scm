; Indentation for Kotlin because nvim-treesitter does not have indentation support for kotlin (yet)
; this can be submitted as a PR for nvim-treesitter

; format-ignore
[
  (class_body)                  ; { ... } of class / interface / object / companion
  (enum_class_body)             ; { ... } of `enum class X`
  (anonymous_initializer)       ; init { ... }
  (secondary_constructor)       ; constructor(...) : this(...) { ... }
  (primary_constructor)         ; class X(...)
  (function_body)               ; fun foo() { ... }  and  fun foo() =\n expr
  (function_value_parameters)   ; fun foo(...) / constructor(...)
  (function_type_parameters)    ; (Int, String) -> Unit
  (type_parameters)             ; <T : Any>
  (type_arguments)              ; List<...>
  (type_constraints)            ; where T : Any
  (value_arguments)             ; foo(...) / @Annotation(...)
  (lambda_literal)              ; { x -> ... }
  (when_expression)             ; when (x) { ... }
  (try_expression)              ; try { ... } -- also covers its catch/finally bodies
  (indexing_suffix)             ; a[...]
  (collection_literal)          ; [1, 2] inside annotations
  (navigation_expression)       ; foo\n .bar()\n .baz()
] @indent.begin

; A trailing lambda is a sibling of the receiver chain, not a descendant of it,
; so the chain's own indent never reaches inside the lambda. Anchor it on the
; call instead. Restricted to calls with a navigation receiver so that a plain
; `foo(\n a\n) {\n b\n}` isn't indented twice.
(call_expression
  (navigation_expression)) @indent.begin

; Bodies of if / else / for / while / do-while / when-entry, but only the braced
; form: the `else` of an `else if` is itself a control_structure_body wrapping
; another if_expression, and indenting it too would double-indent the chain.
(control_structure_body
  .
  "{") @indent.begin

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @indent.branch

; On a fresh blank line, re-anchor to the enclosing scope when the previous line
; closed a block or an argument list, instead of staying inside it.
[
  ")"
  "]"
  "}"
] @indent.end

(line_comment) @indent.ignore

; Keep whatever indentation is already there: reindenting the inside of a raw
; string would change the string's value.
[
  (ERROR)
  (multiline_comment)
  (string_literal)
] @indent.auto

; Known gap: `get()`/`set()` land at the same level as the property they belong
; to rather than one level deeper. The grammar parses them as siblings of
; `property_declaration`, not children, so the accessor and its `function_body`
; start on the same row -- and the indent engine applies at most one level per
; row. Everything inside the accessor is still indented consistently.
