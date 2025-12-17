# Enable Powerlevel11k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

eval "$(fnm env --use-on-cd)"
eval "$(starship init zsh)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git 
vscode
zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
export ANDROID_HOME=$HOME/Library/Android/sdk 
export PATH=$PATH:$ANDROID_HOME/emulator 
export PATH=$PATH:$ANDROID_HOME/platform-tools

export REACT_EDITOR=nvim

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

alias ps="pnpm run start"
alias pra="pnpm run android"
alias pri="pnpm run ios"
alias yta='yt-dlp -x --audio-format mp3 -o "./%(title)s.%(ext)s"'

# Jira sprint workitems
alias jsw='acli jira workitem search --jql "assignee = currentUser() AND sprint in openSprints() AND status != Done"'

tor() {
  local link="$(pbpaste)"
  transmission-cli -w ~/Downloads "$link"
}

ji() {
  local open_web=false
  local input=""

  # Parse options
  while [[ "$1" != "" ]]; do
    case "$1" in
      -o|--open)
        open_web=true
        ;;
      *)
        input="$1"
        ;;
    esac
    shift
  done

  # Auto-detect ticket from current branch if no input
  if [[ -z "$input" ]]; then
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
      echo "❌ Cannot get current branch and no ticket provided"
      return 1
    }

    # Extract HYDRA-XXXX case-insensitive
    input=$(echo "$branch" | grep -oi 'HYDRA-[0-9]\+')

    if [[ -z "$input" ]]; then
      echo "❌ No ticket ID found in branch name and no input provided"
      return 1
    fi

    # Uppercase for ACLI
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]')
  else
    # Auto-prefix HYDRA- if only numeric
    if [[ "$input" =~ ^[0-9]+$ ]]; then
      input="HYDRA-$input"
    fi
  fi

  # Run ACLI
  if $open_web; then
    acli jira workitem view "$input" --web
  else
    acli jira workitem view "$input" --fields '*all'
  fi
}


jit() {
  local branch ticket
  branch=$(git rev-parse --abbrev-ref HEAD)
  ticket=$(echo "$branch" | grep -oi 'HYDRA-[0-9]\+')
  ticket=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')

  acli jira workitem view "$ticket" --fields key,summary \
    | sed -n 's/^Key:[[:space:]]*//p; s/^Summary:[[:space:]]*//p' \
    | paste -sd ':' -
}


jicl() {
  local branch ticket
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    echo "❌ Cannot get current branch"
    return 1
  }

  ticket=$(echo "$branch" | grep -oi 'HYDRA-[0-9]\+')
  if [[ -z "$ticket" ]]; then
    echo "❌ No ticket ID found in branch name"
    return 1
  fi

  ticket=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')

  acli jira workitem comment list --key "$ticket"
}

jicd() {
  local comment_id="$1"

  if [[ -z "$comment_id" ]]; then
    echo "Usage: jicdel <COMMENT-ID>"
    return 1
  fi

  # Auto-detect ticket from current branch
  local branch ticket
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    echo "❌ Cannot get current branch"
    return 1
  }

  ticket=$(echo "$branch" | grep -oi 'HYDRA-[0-9]\+')
  if [[ -z "$ticket" ]]; then
    echo "❌ No ticket ID found in branch name"
    return 1
  fi

  # Uppercase ticket for ACLI
  ticket=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')

  # Delete the comment
  acli jira workitem comment delete --key "$ticket" --id "$comment_id"

  echo "✅ Deleted comment $comment_id from $ticket"
}

jis() {
  local flag="$1"

  if [[ -z "$flag" ]]; then
    echo "Usage: jistatus <flag>"
    echo "Allowed flags: i (In Progress), r (Planned), t (Test), o (To Do)"
    return 1
  fi

  # Map flags to actual status
  local new_status=""
  case "$flag" in
    i) new_status="In Progress" ;;
    r) new_status="Planned" ;;
    t) new_status="Test" ;;
    o) new_status="To Do" ;;
    *)
      echo "❌ Invalid flag: '$flag'"
      echo "Allowed flags: i (In Progress), r (Planned), t (Test), o (To Do)"
      return 1
      ;;
  esac

  # Auto-detect ticket from current branch
  local branch ticket
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    echo "❌ Cannot get current branch"
    return 1
  }

  ticket=$(echo "$branch" | grep -oi 'HYDRA-[0-9]\+')
  if [[ -z "$ticket" ]]; then
    echo "❌ No ticket ID found in branch name"
    return 1
  fi

  ticket=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')

  # Transition ticket
  acli jira workitem transition --key "$ticket" --status "$new_status"
  echo "✅ Changed status of $ticket to '$new_status'"
}



jic() {
  local body="$1"

  if [[ -z "$body" ]]; then
    echo "Usage: jic <comment body>"
    return 1
  fi

  # Auto-detect ticket from current branch
  local branch ticket
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    echo "❌ Cannot get current branch"
    return 1
  }

  ticket=$(echo "$branch" | grep -oi 'HYDRA-[0-9]\+')
  if [[ -z "$ticket" ]]; then
    echo "❌ No ticket ID found in branch name"
    return 1
  fi

  # Uppercase ticket for ACLI
  ticket=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')

  # Add comment via ACLI
  acli jira workitem comment create --key "$ticket" -b "$body"

  echo "✅ Comment added to $ticket"
}

mkb() {
  local ticket=""
  local do_checkout=false

  # ---- if no arg → attempt to read from clipboard ----
  if [[ $# -lt 1 ]]; then
    if command -v pbpaste &>/dev/null; then
      ticket="$(pbpaste)"
    elif command -v xclip &>/dev/null; then
      ticket="$(xclip -o -selection clipboard)"
    elif command -v xsel &>/dev/null; then
      ticket="$(xsel --clipboard --output)"
    else
      echo "❌ No input and cannot read clipboard"
      echo "Usage: mkb <TICKET-ID or number> [-c]"
      return 1
    fi
  fi

  # ---- parse args ----
  while [[ "$1" != "" ]]; do
    case "$1" in
      -c|--checkout)
        do_checkout=true
        ;;
      *)
        ticket="$1"
        ;;
    esac
    shift
  done

  if [[ -z "$ticket" ]]; then
    echo "❌ Ticket ID missing"
    return 1
  fi

  # ---- Auto-prefix HYDRA if numeric ----
  if [[ "$ticket" =~ ^[0-9]+$ ]]; then
    ticket="HYDRA-$ticket"
  else
    ticket=$(echo "$ticket" | tr '[:lower:]' '[:upper:]')
  fi

  # ---- fetch ticket via ACLI ----
  local acli_output
  acli_output=$(acli jira workitem view "$ticket" --fields '*all' 2>/dev/null)
  if [[ -z "$acli_output" ]]; then
    echo "❌ Cannot fetch ticket $ticket"
    return 1
  fi

  # ---- extract Type & Summary ----
  local issue_type summary
  issue_type=$(echo "$acli_output" | grep -i '^Type:' | sed 's/Type:[[:space:]]*//')
  summary=$(echo "$acli_output" | grep -i '^Summary:' | sed 's/Summary:[[:space:]]*//')

  # ---- determine branch prefix ----
  local prefix="feat"
  case "${issue_type:l}" in
    "bug"|"defect"|"error"|"hotfix"|"story defect")
      prefix="bugfix"
      ;;
    sub-task)
      prefix="feat"
      ;;
  esac

  # ---- normalize summary → kebab-case ----
  summary=$(echo "$summary" | sed 's/\[[^]]*\]//g')

  local kebab
  kebab=$(echo "$summary" \
      | iconv -f UTF-8 -t ASCII//TRANSLIT \
      | tr '[:upper:]' '[:lower:]' \
      | sed 's/[^a-z0-9]/-/g' \
      | sed 's/-\+/-/g' \
      | sed 's/^-//' \
      | sed 's/-$//')

  # ---- limit summary length ----
  local MAX_LEN=40
  if [[ ${#kebab} -gt $MAX_LEN ]]; then
    local truncated=${kebab:0:$MAX_LEN}
    kebab=${truncated%-*}
  fi

  # ---- final branch ----
  local branch="${prefix}/$(echo "$ticket" | tr '[:upper:]' '[:lower:]')-${kebab}"

  echo "$branch"

  # ---- smart git switch ----
  if $do_checkout; then
    if git show-ref --verify --quiet "refs/heads/$branch"; then
      git switch "$branch"
    else
      git switch -c "$branch"
    fi
  fi
}





function pt() {
  if [ -f yarn.lock ]; then
    echo "🔧 Detected yarn.lock → running: yarn test"
    yarn test

  elif [ -f package-lock.json ]; then
    echo "🔧 Detected package-lock.json → running: npm run test"
    npm run test
  elif [ -f pnpm-lock.yaml ]; then
    echo "🔧 Detected pnpm-lock.yaml → running: pnpm run test"
    pnpm run test
  else
    echo "⚠️ No lockfile found → defaulting to: pnpm run test"
    pnpm run test
  fi
}

function pd() {
  if [ -f bun.lockb ]; then
    echo "🔧 Detected bun.lockb → running: bun dev"
    bun dev
  elif [ -f yarn.lock ]; then
    echo "🔧 Detected yarn.lock → running: yarn dev"
    yarn dev
  elif [ -f package-lock.json ]; then
    echo "🔧 Detected package-lock.json → running: npm run dev"
    npm run dev
  elif [ -f pnpm-lock.yaml ]; then
    echo "🔧 Detected pnpm-lock.yaml → running: pnpm run dev"
    pnpm run dev
  else
    echo "⚠️ No lockfile found → defaulting to: pnpm run dev"
    pnpm run dev
  fi
}

function pi() {
  if [ -f yarn.lock ]; then
    echo "📦 Detected yarn.lock → running: yarn install"
    yarn install
  elif [ -f package-lock.json ]; then
    echo "📦 Detected package-lock.json → running: npm install"
    npm install
  elif [ -f pnpm-lock.yaml ]; then
    echo "📦 Detected pnpm-lock.yaml → running: pnpm install"
    pnpm install
  else
    echo "⚠️ No lockfile found → defaulting to: pnpm install"
    pnpm install
  fi
}

function pb() {
  if [ -f yarn.lock ]; then
    echo "🏗️ Detected yarn.lock → running: yarn build"
    yarn build
  elif [ -f package-lock.json ]; then
    echo "🏗️ Detected package-lock.json → running: npm run build"
    npm run build
  elif [ -f pnpm-lock.yaml ]; then
    echo "🏗️ Detected pnpm-lock.yaml → running: pnpm run build"
    pnpm run build
  else
    echo "⚠️ No lockfile found → defaulting to: pnpm run build"
    pnpm run build
  fi
}


eslint_pr() {
  local target_branch
  target_branch=$(git config heiway.targetBranch)

  if [ -z "$target_branch" ]; then
    echo "⚠️  heiway.targetBranch not set in git config."
    return 1
  fi

  echo "🔍 Running ESLint against changes from: $target_branch"

  # Ensure target branch is fetched
  git fetch origin "$target_branch" > /dev/null 2>&1

  # Get list of changed JS/TS files (excluding deleted)
  local changed_files
  changed_files=$(git diff --diff-filter=d --name-only "origin/$target_branch...HEAD" -- '*.js' '*.jsx' '*.ts' '*.tsx')

  if [ -z "$changed_files" ]; then
    echo "✅ No JS/TS files changed."
    return 0
  fi

  echo "$changed_files" | xargs npx eslint 
}

generate_changelog() {
  local target_branch
  target_branch=$(git config heiway.targetBranch)

  if [ -z "$target_branch" ]; then
    echo "⚠️  heiway.targetBranch not set in git config."
    return 1
  fi

  echo "📝 Generating changelog from diff against: $target_branch"

  # Ensure branch is up to date
  git fetch origin "$target_branch" > /dev/null 2>&1

  # Capture the diff (you can add filters if you want)
  local diff_content
  diff_content=$(git diff "origin/$target_branch...HEAD")

  if [ -z "$diff_content" ]; then
    echo "✅ No changes found."
    return 0
  fi

  # Send to Gemini CLI (replace with actual command/flags for Gemini)
  echo "$diff_content" | gemini prompt "Generate a changelog based on this diff"
}

biome_pr() {
  local target_branch
  target_branch=$(git config heiway.targetBranch)

  if [ -z "$target_branch" ]; then
    echo "⚠️  heiway.targetBranch not set in git config."
    return 1
  fi

  echo "🔍 Running Biome check against changes from: $target_branch"

  # Ensure target branch is fetched
  git fetch origin "$target_branch" > /dev/null 2>&1

  # Get list of changed JS/TS files (excluding deleted)
  local changed_files
  changed_files=$(git diff --diff-filter=d --name-only "origin/$target_branch...HEAD" -- '*.js' '*.jsx' '*.ts' '*.tsx')

  if [ -z "$changed_files" ]; then
    echo "✅ No JS/TS files changed."
    return 0
  fi

  echo "$changed_files" | xargs npx biome check
}

cpr() {
  local title="$1"
  local target_branch
  target_branch=$(git config --get heiway.targetBranch)

  if [[ -z "$target_branch" ]]; then
    echo "❌ No target branch configured. Use: git config heiway.targetBranch <branch>"
    return 1
  fi

  # Read stdin if no argument provided
  if [[ -z "$title" ]]; then
    read -r title
  fi

  if [[ -z "$title" ]]; then
    echo "❌ PR title is empty"
    return 1
  fi

  az repos pr create \
    --target-branch "$target_branch" \
    --squash true \
    --title "$title" \
    --delete-source-branch true \
    --open
}



prl() {
  user_id=$(az account show --query user.name -o tsv)

  echo "Pull Requests created by you:"
  az repos pr list --creator "$user_id" --output table

  echo ""
  echo "Pull Requests where you are a reviewer:"
  az repos pr list --reviewer "$user_id" --output table
}


pr() {
  if [ -n "$1" ]; then
    az repos pr show --id "$1" --open
  else
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)

    if [ -z "$branch" ]; then
      echo "❌ Unable to detect current Git branch."
      return 1
    fi

    local pr_id
    pr_id=$(az repos pr list --source-branch "$branch" --query "[0].pullRequestId" -o tsv)

    if [ -z "$pr_id" ]; then
      echo "❌ No PR found for branch '$branch'."
      return 1
    fi

    az repos pr show --id "$pr_id" --open
  fi
}

prc() {
  local pr_id="$1"

  # ---- If no argument → try reading from clipboard ----
  if [[ -z "$pr_id" ]]; then
    if command -v pbpaste &>/dev/null; then
      pr_id="$(pbpaste)"
    elif command -v xclip &>/dev/null; then
      pr_id="$(xclip -o -selection clipboard)"
    elif command -v xsel &>/dev/null; then
      pr_id="$(xsel --clipboard --output)"
    else
      echo "❌ No PR ID and cannot read clipboard"
      return 1
    fi
  fi

  # ---- Extract PR ID if clipboard contains full URL ----
  # Example supported forms:
  #   https://dev.azure.com/.../pullrequest/1234
  #   PR 1234
  #   #1234
  #   1234
  pr_id="$(echo "$pr_id" | grep -Eo '[0-9]+' | head -n 1)"

  if [[ -z "$pr_id" ]]; then
    echo "❌ Could not determine PR ID"
    return 1
  fi

  echo "🔄 Checking out PR #$pr_id ..."
  az repos pr checkout --id "$pr_id"
}


bul(){
az pipelines build list --top 10
}

bu() {
  if [[ -n "$1" ]]; then
    pr_id="$1"
    echo "🔗 Using provided PR ID: $pr_id"
  else
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "🔍 No PR ID provided. Detecting from current branch: $current_branch"

    pr_id=$(az repos pr list \
      --source-branch "$current_branch" \
      --query "[0].pullRequestId" -o tsv)

    if [[ -z "$pr_id" ]]; then
      echo "❌ No PR found for branch: $current_branch"
      return 1
    fi

    echo "🔗 Found PR ID: $pr_id"
  fi

    build_id=$(az pipelines build list \
      --query "[?triggerInfo.\"pr.number\"=='$pr_id'] | [0].id" \
     -o tsv)

  if [[ -z "$build_id" ]]; then
    echo "❌ No build found for PR ID: $pr_id"
    return 1
  fi

  echo "🚀 Opening build: $build_id"
  az pipelines build show --id "$build_id" --open
}



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/Users/nguytb15/.bun/_bun" ] && source "/Users/nguytb15/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
source /Users/nguytb15/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pnpm
export PNPM_HOME="/Users/nguytb15/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
eval "$(zoxide init zsh)"



