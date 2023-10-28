{ config
, pkgs
, ...
}: {
  # home.sessionVariables = rec {
  #   EDITOR = "${pkgs.neovim}/bin/nvim";
  #   SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";
  #   VISUAL = "${pkgs.neovim}/bin/nvim";
  # };

  programs.neovim = {
    enable = true;
    withNodeJs = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [ ];

    plugins = with pkgs.vimPlugins; [
      vim-multiple-cursors
      vim-surround
      editorconfig-nvim
      vim-gitgutter
      vim-airline
      nvim-web-devicons

      # Better syntax highlighting and indentation
      nvim-treesitter.withAllGrammars


      # Tree-like file manager
      nvim-tree-lua

    ];

    extraConfig = ''
      syntax enable
      set number
      set tabstop=2
      set mouse=a
      set updatetime=300
      set signcolumn=number
      set noshowmode

      " various fixes for the tab key
      set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
      autocmd FileType nix set tabstop=2 softtabstop=0 shiftwidth=2 expandtab

      " Dont insert a comment when creating a newline from a comment
      autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

      " Insert a newline without going into insert mode
      nmap <S-Enter> O<Esc>
      nmap <CR> o<Esc>

      " Without this space mappings do not work
      nnoremap <SPACE> <Nop>
    '';
  };
}
