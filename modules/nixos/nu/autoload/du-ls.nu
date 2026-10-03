def du-ls [path: path = "."] {
  let total = du $path | first
  let pct = {|part, whole| if $whole == 0b { 0.0 } else { $part / $whole * 100 | math round --precision 1 } }
  $total
  | insert type dir
  | insert pct_apparent 100.0
  | insert children {
      ls -a --full-paths $path
      | each {|e|
          if $e.type == dir {
            du-ls $e.name
          } else {
            {
              path: $e.name
              apparent: $e.size
              type: $e.type
            }
          }
          | upsert pct_apparent {|c| do $pct $c.apparent $total.apparent }
        }
      | sort-by --reverse apparent
    }
}
