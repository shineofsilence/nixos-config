{ pkgs, ... }: {
  # Устанавливаем neovim и LSP-серверы как пользовательские пакеты
  home.packages = with pkgs; [
    neovim
    nixd          # LSP-сервер для Nix (обязателен!)
    # Дополнительно (для других языков в будущем):
    # lua-language-server
    # python3.pkgs.pyright
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # Базовые настройки редактора
    extraConfig = ''
      " Относительная нумерация строк
      set number
      set relativenumber

      " Удобные настройки
      set mouse=a
      set clipboard=unnamedplus
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set scrolloff=5
    '';

    # Плагины через vimPlugins (Home Manager)
    plugins = with pkgs.vimPlugins; [
      # Современный менеджер LSP-серверов, DAP, линтеров
      mason-nvim

      # Интеграция Mason с nvim-lspconfig
      mason-lspconfig-nvim

      # Основной LSP-клиент
      nvim-lspconfig

      # Фреймворк для автодополнения
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline

      # Сниппеты
      luasnip

      # ????? Подсветка синтаксиса для Nix ????
      #nix-vim

      # (Опционально) Тема, например:
      # tokyonight-nvim
    ];

    # Конфигурация на Lua
    extraLuaConfig = ''
      -- Загружаем компоненты
      local lspconfig = require('lspconfig')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- Инициализируем Mason (менеджер LSP-серверов)
      mason.setup()

      -- Автоматически регистрируем LSP-серверы из Mason в lspconfig
      mason_lspconfig.setup({
        ensure_installed = { 'nixd' }  -- ← гарантируем установку nixd
      })

      -- Настройка LSP для всех поддерживаемых языков
      mason_lspconfig.setup_handlers({
        -- Общий обработчик для всех серверов
        function(server_name)
          lspconfig[server_name].setup({})
        end,
      })

      -- Явная настройка nixd (на случай, если нужно кастомизировать)
      lspconfig.nixd.setup{}

      -- Настройка автодополнения
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },     -- из LSP
          { name = 'luasnip' },      -- сниппеты
        }, {
          { name = 'buffer' },       -- из текущего буфера
          { name = 'path' },         -- пути файлов
        })
      })

      -- Настройка автодополнения в командной строке (:)
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    '';
  };
}