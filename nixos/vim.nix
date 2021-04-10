{ pkgs, ... }:
let
  vim = pkgs.vim_configurable.customize {
    name = "vim";

    vimrcConfig = {
      packages.custom = {
        start = with pkgs.vimPlugins; [
          fugitive pathogen rainbow syntastic vim-dadbod vim-speeddating
        ];
        opt = with pkgs.vimPlugins; [ elm-vim idris-vim jq-vim vim-nix vim-orgmode ];
      };

      customRC = ''
        " Set localleader before importing anything which defines mappings.
        let maplocalleader="-"

        " Pathogen.
        " execute pathogen#infect()

        " Python-style tabbing. Four spaces to the tabstop, expand tabs.
        set tabstop=4
        set shiftwidth=4
        set expandtab

        " Seriously, save your eyes.
        set background=dark

        " You want these. You just do.
        set autoindent smartindent

        " Enable ~ as a general verb that acts on any motion.
        set tildeop

        " Word wrapping mode and width. Good for most things.
        set wm=2
        set textwidth=78

        " Characters for list mode.
        set listchars=tab:>-,eol:$

        " Force 256 colors.
        set t_Co=256

        " Enable syntax highlighting.
        syntax on

        " I dunno, I like this color. I think.
        " colo candycode

        " Enable general filetype-specific stuff.
        filetype on
        filetype plugin on
        filetype indent on

        " This is necessary in order to get Python builtins highlighted.
        let python_highlight_all=1

        " JQuery
        au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

        " Lye
        au BufRead,BufNewfile *.lye set ft=lilypond syntax=lilypond

        " Monte
        au BufRead,BufNewfile *.mt set ft=monte syntax=monte

        " TLA+
        au BufRead,BufNewfile *.tla set ft=tla syntax=tla

        " Lojban
        au BufRead,BufNewfile *.jbo set ft=lojban syntax=lojban

        " Status line.
        set laststatus=2
        set statusline+=%F\ %l\:%c

        " Fugitive
        set statusline+=%{FugitiveStatusline()}

        " Syntastic
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*

        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        " let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
        let g:syntastic_python_checkers = ['pyflakes']
        " let g:syntastic_rst_checkers = ['sphinx']

        set so=5
        set backspace=eol,indent,start

        set nojoinspaces
      '';
    };
  };
in
{
  environment.systemPackages = [ vim ];
}
