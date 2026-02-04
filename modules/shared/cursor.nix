# Cursor configuration
# Manages Cursor settings, keybindings, and extensions

{ pkgs, config, ... }:

let
  # Cursor configuration directory (using $HOME in activation script)
  cursorConfigDirDarwin = "$HOME/Library/Application Support/Cursor/User";
  cursorConfigDirLinux = "$HOME/.config/Cursor/User";

  # Settings.json content
  settingsJson = pkgs.writeText "cursor-settings.json" ''
{
	"[json]": {
		"editor.formatOnSave": true,
		"editor.quickSuggestions": {
			"strings": true
		},
		"editor.suggest.insertMode": "replace"
	},
	"[markdown]": {
		"editor.defaultFormatter": "yzhang.markdown-all-in-one"
	},
	"[python]": {
		"editor.codeActionsOnSave": {
			"source.fixAll": "explicit",
			"source.organizeImports": "explicit",
			"source.organizeImports.ruff": "explicit"
		},
		"editor.defaultFormatter": "charliermarsh.ruff",
		"editor.formatOnSave": true,
		"editor.insertSpaces": true,
		"editor.tabSize": 4
	},
	"[zig]": {
		"editor.codeActionsOnSave": {
			"source.fixAll": "explicit",
			"source.organizeImports": "explicit"
		},
		"editor.formatOnSave": false,
		"editor.inlayHints.enabled": "off",
		"editor.suggest.insertMode": "replace"
	},
	"autoimport.filesToScan": "**/*.{ts,tsx,py}",
	"console-ninja.featureSet": "Community",
	"cSpell.userWords": [
		"browsersync",
		"certifi",
		"comptime",
		"deepseek",
		"Didi",
		"Docstore",
		"eviden",
		"faiis",
		"FAISS",
		"Helvetica",
		"Hexogon",
		"Hugginface",
		"huggingface",
		"ignorecase",
		"INET",
		"langchain",
		"langgraph",
		"Lelystad",
		"Linebreak",
		"MAPBOX",
		"numpy",
		"officedocument",
		"openxmlformats",
		"pega",
		"PEGAURL",
		"pixi",
		"Pressable",
		"Qwen",
		"semibold",
		"spreadsheetml",
		"Stadspost",
		"stylelint",
		"Symfoo",
		"tailwindcss",
		"tokota",
		"uglifyjs",
		"unsloth",
		"vectorstores",
		"wpackagist",
		"wpgraphql"
	],
	"cssPeek.peekFromLanguages": [
		"html",
		"django-html",
		"razor",
		"vue",
		"blade",
		"pug",
		"jade",
		"handlebars",
		"php",
		"twig",
		"md",
		"nunjucks",
		"javascript",
		"javascriptreact",
		"erb",
		"typescript",
		"typescriptreact",
		"HTML (Eex)",
		"html-eex",
		"ejs",
		"js"
	],
	"cssPeek.peekToExclude": ["**/bower_components/**"],
	"editor.bracketPairColorization.enabled": true,
	"editor.codeActionsOnSave": {
		"source.fixAll.eslint": "explicit"
	},
	"editor.cursorBlinking": "smooth",
	"editor.cursorWidth": 2,
	"editor.defaultFormatter": "esbenp.prettier-vscode",
	"editor.definitionLinkOpensInPeek": true,
	"editor.fontFamily": "Hacker Nerd Font",
	"editor.fontLigatures": true,
	"editor.fontSize": 13,
	"editor.formatOnPaste": true,
	"editor.lineHeight": 20,
	"editor.matchBrackets": "always",
	"editor.minimap.enabled": false,
	"editor.minimap.maxColumn": 90,
	"editor.semanticHighlighting.enabled": true,
	"editor.semanticTokenColorCustomizations": {
		"rules": {
			"*.deprecated": {
				"strikethrough": true
			}
		}
	},
	"editor.suggestSelection": "first",
	"editor.tabSize": 2,
	"editor.tokenColorCustomizations": {
		"textMateRules": [
			{
				"name": "envKeys",
				"scope": "string.quoted.double.env,source.env,constant.numeric.env",
				"settings": {
					"foreground": "#19354900"
				}
			}
		]
	},
	"editor.wordWrap": "wordWrapColumn",
	"editor.wordWrapColumn": 120,
	"emmet.includeLanguages": {
		"javascript": "javascriptreact",
		"jsx-sublime-babel-tags": "javascriptreact"
	},
	"explorer.confirmDelete": false,
	"explorer.confirmDragAndDrop": false,
	"explorer.confirmPasteNative": false,
	"files.associations": {
		"*.js": "javascript",
		"*.jsx": "javascriptreact",
		"*.mdx": "markdown",
		"*.mojo": "mojo",
		"*.py": "python"
	},
	"files.encoding": "utf8",
	"files.exclude": {},
	"files.trimTrailingWhitespace": true,
	"hediet.vscode-drawio.resizeImages": null,
	"html.format.wrapLineLength": 120,
	"http.proxySupport": "off",
	"javascript.updateImportsOnFileMove.enabled": "always",
	"markdown-preview-github-styles.colorTheme": "dark",
	"markdown.extension.completion.respectVscodeSearchExclude": false,
	"npm-intellisense.importDeclarationType": "const",
	"npm-intellisense.importES6": true,
	"npm-intellisense.importLinebreak": ";\r\n",
	"npm-intellisense.importQuotes": "'",
	"npm-intellisense.packageSubfoldersIntellisense": true,
	"npm-intellisense.recursivePackageJsonLookup": true,
	"npm-intellisense.scanDevDependencies": true,
	"npm-intellisense.showBuildInLibs": true,
	"path-intellisense.extensionOnImport": true,
	"path-intellisense.showHiddenFiles": true,
	"prettier.arrowParens": "always",
	"prettier.jsxSingleQuote": true,
	"prettier.semi": false,
	"prettier.singleQuote": true,
	"prettier.tabWidth": 2,
	"prettier.trailingComma": "all",
	"prettier.useTabs": true,
	"python.analysis.autoFormatStrings": true,
	"python.analysis.autoImportCompletions": true,
	"python.analysis.indexing": false,
	"python.analysis.regenerateStdLibIndices": true,
	"python.analysis.typeCheckingMode": "basic",
	"python.languageServer": "Pylance",
	"redhat.telemetry.enabled": false,
	"remote.autoForwardPortsSource": "hybrid",
	"security.workspace.trust.banner": "always",
	"security.workspace.trust.untrustedFiles": "open",
	"terminal.integrated.env.linux": {},
	"terminal.integrated.env.osx": {},
	"terminal.integrated.env.windows": {},
	"terminal.integrated.inheritEnv": false,
	"terminal.integrated.minimumContrastRatio": 1,
	"window.titleBarStyle": "custom",
	"workbench.activityBar.orientation": "vertical",
	"workbench.colorCustomizations": {
		"editor.renderLineHighlight": "line"
	},
	"workbench.colorTheme": "Material Theme Ocean High Contrast",
	"workbench.fontAliasing": "auto",
	"workbench.iconTheme": "eq-material-theme-icons-darker",
	"zig.zls.enabled": "on",
	"zig.buildOnSaveProvider": "zls",
	"easy-codesnap.saveFormat": "webp"
}
  '';

  # Keybindings.json content
  keybindingsJson = pkgs.writeText "cursor-keybindings.json" ''
// Place your key bindings in this file to override the defaultsauto[]
[
  {
    "key": "alt+tab",
    "command": "auto-align.alignSelection"
  },
  {
    "key": "alt+tab",
    "command": "extension.autoalign"
  },
  {
    "key": "cmd+i",
    "command": "composerMode.agent"
  }
]
  '';

  # List of extensions to install
  extensions = [
    "aaron-bond.better-comments"
    "adam-bender.commit-message-editor"
    "alduncanson.react-hooks-snippets"
    "anysphere.cursorpyright"
    "anysphere.pyright"
    "arthurlobo.easy-codesnap"
    "beardedbear.beardedtheme"
    "bradlc.vscode-tailwindcss"
    "captainstack.captain-stack"
    "catppuccin.catppuccin-vsc"
    "charliermarsh.ruff"
    "christian-kohler.npm-intellisense"
    "christian-kohler.path-intellisense"
    "clinyong.vscode-css-modules"
    "cmstead.js-codeformer"
    "cmstead.jsrefactor"
    "codezombiech.gitignore"
    "davidanson.vscode-markdownlint"
    "dbaeumer.vscode-eslint"
    "donjayamanne.githistory"
    "donjayamanne.python-extension-pack"
    "dsznajder.es7-react-js-snippets"
    "ecmel.vscode-html-css"
    "equinusocio.vsc-material-theme"
    "equinusocio.vsc-material-theme-icons"
    "esbenp.prettier-vscode"
    "formulahendry.auto-close-tag"
    "formulahendry.auto-rename-tag"
    "formulahendry.code-runner"
    "formulahendry.docker-explorer"
    "github.vscode-github-actions"
    "github.vscode-pull-request-github"
    "golang.go"
    "gruntfuggly.todo-tree"
    "henriiik.docker-linter"
    "heybourn.headwind"
    "howardzuo.vscode-git-tags"
    "jeff-hykin.better-dockerfile-syntax"
    "jnoortheen.nix-ide"
    "jock.svg"
    "johnbillion.vscode-wordpress-hooks"
    "kevinrose.vsc-python-indent"
    "leizongmin.node-module-intellisense"
    "mariusalchimavicius.json-to-ts"
    "mhutchie.git-graph"
    "mikestead.dotenv"
    "ms-azuretools.vscode-docker"
    "ms-python.black-formatter"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode.azure-repos"
    "ms-vscode.remote-repositories"
    "ms-vscode.vscode-typescript-next"
    "ms-vsliveshare.vsliveshare"
    "naumovs.color-highlight"
    "njqdev.vscode-python-typehint"
    "oven.bun-vscode"
    "p1c2u.docker-compose"
    "pkief.material-icon-theme"
    "pmneo.tsimporter"
    "pranaygp.vscode-css-peek"
    "pulkitgangwar.nextjs-snippets"
    "quicktype.quicktype"
    "redhat.vscode-yaml"
    "richie5um2.vscode-sort-json"
    "ryu1kn.partial-diff"
    "shd101wyy.markdown-preview-enhanced"
    "sonarsource.sonarlint-vscode"
    "steoates.autoimport"
    "streetsidesoftware.code-spell-checker"
    "tamasfe.even-better-toml"
    "tyriar.sort-lines"
    "ue.alphabetical-sorter"
    "vincaslt.highlight-matching-tag"
    "vinirossa.vscode-gitandgithub-pack"
    "vsls-contrib.codetour"
    "waderyan.gitblame"
    "wallabyjs.console-ninja"
    "wix.vscode-import-cost"
    "xabikos.javascriptsnippets"
    "ziglang.vscode-zig"
    "ziyasal.vscode-open-in-github"
  ];

  # Script to install extensions
  installExtensionsScript = pkgs.writeShellScript "cursor-install-extensions" ''
    set -euo pipefail

    # Try to find cursor command (could be in different locations)
    CURSOR_BIN=""
    if command -v cursor &> /dev/null; then
      CURSOR_BIN="cursor"
    elif [ -f "${pkgs.code-cursor}/bin/cursor" ]; then
      CURSOR_BIN="${pkgs.code-cursor}/bin/cursor"
    elif [ -f "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" ]; then
      CURSOR_BIN="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
    fi

    if [ -z "$CURSOR_BIN" ]; then
      echo "Warning: cursor command not found, skipping extension installation"
      exit 0
    fi

    # Install each extension
    ${pkgs.lib.concatMapStringsSep "\n" (ext: ''
      echo "Installing extension: ${ext}"
      "$CURSOR_BIN" --install-extension "${ext}" || echo "Failed to install ${ext}"
    '') extensions}
  '';
in
{
  # Activation script to set up Cursor configuration
  system.activationScripts.cursorConfig = let
    cursorConfigDir = if pkgs.stdenv.isDarwin then cursorConfigDirDarwin else cursorConfigDirLinux;
  in ''
    echo "setting up Cursor configuration..." >&2

    # Create Cursor User directory if it doesn't exist
    mkdir -p ${cursorConfigDir}

    # Copy settings.json
    if [ -f "${settingsJson}" ]; then
      cp -f "${settingsJson}" ${cursorConfigDir}/settings.json
      echo "Cursor settings.json configured" >&2
    fi

    # Copy keybindings.json
    if [ -f "${keybindingsJson}" ]; then
      cp -f "${keybindingsJson}" ${cursorConfigDir}/keybindings.json
      echo "Cursor keybindings.json configured" >&2
    fi

    # Install extensions (run in background to avoid blocking activation)
    if [ -f "${installExtensionsScript}" ]; then
      "${installExtensionsScript}" &
      echo "Cursor extensions installation started" >&2
    fi
  '';
}

