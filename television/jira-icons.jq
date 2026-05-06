def status_icon:
  { "In Progress":            "🔄"
  , "To do":                  "⬜"
  , "Done":                   "✅"
  , "In Review":              "👀"
  , "Blocked":                "🚫"
  , "Reopened":               "🔁"
  , "Pending Input":          "⏳"
  , "Cancelled":              "❌"
  , "Ready for Code Review":  "🔍"
  } [.] // "❓";

def _status_color:
  { "In Progress":            "[36m"
  , "To do":                  "[33m"
  , "Done":                   "[32m"
  , "In Review":              "[35m"
  , "Blocked":                "[31m"
  , "Reopened":               "[31m"
  , "Pending Input":          "[33m"
  , "Cancelled":              "[90m"
  , "Ready for Code Review":  "[34m"
  } [.] // "[37m";

def status_colored:
  . as $s |
  15 as $n |
  (if ($s | length) > $n then $s[0:$n-3] + "..." else $s end) as $display |
  ($n - ($display | length)) as $pad |
  (_status_color) + $display + "[0m" + (" " * $pad);

def fixed_width(n):
  if (. | length) > n then .[0:n-3] + "..."
  else . + (" " * (n - (. | length)))
  end;

def type_icon:
  { "Bug":           "🐛"
  , "Defect":        "🐛"
  , "Story Defect":  "🐛"
  , "Story":         "📖"
  , "Subtask":       "🗒️"
  , "Epic":          "⚡"
  , "Task":          "✔️"
  } [.] // "📋";

def type_label:
  (. | type_icon) + " " + (. | fixed_width(8));
