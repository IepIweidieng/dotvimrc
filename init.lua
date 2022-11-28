vim.env.BASH_ENV = '~/.bash_aliases';

vim.api.nvim_create_user_command(
    'DiffOrig',
    function(opts)
        vim.cmd.new {mods = {vertical = true}};
        vim.bo.buftype = 'nofile';
        if not xpcall(
            vim.cmd,
            vim.api.nvim_err_writeln,
            [[read ++edit # | 0d_ | diffthis | wincmd p | diffthis]]
        ) then
            vim.cmd.quit();
        end
    end,
    {}
);

vim.g.init = {
    on_colorscheme_loaded = function()
        vim.o.termguicolors = true;
        vim.o.background = 'dark';

        vim.g.gruvbox_contrast_dark = 'hard';
        vim.g.gruvbox_improved_strings = true;
        vim.g.gruvbox_improved_warnings = true;
        vim.cmd.colorscheme('gruvbox');
    end,
};

require 'plugins';

vim.g.airline_powerline_fonts = false;

local airline_symbols = vim.g.airline_symbols or vim.empty_dict();
airline_symbols.space = vim.fn.nr2char(0x00a0); -- U+00A0 (No-Break Space)
vim.g.airline_symbols = airline_symbols;
vim.g.bufferline_echo = false;

vim.g['airline#extensions#tabline#enabled'] = true;
vim.g['airline#extensions#tabline#show_splits'] = true;
vim.g['airline#extensions#tabline#show_buffers'] = true;
vim.g['airline#extensions#tabline#show_tabs'] = true;

vim.g.Hexokinase_refreshEvents = {'TextChanged', 'InsertLeave'};

vim.o.ttimeoutlen = 10;
vim.o.ambiwidth = 'double';

vim.o.number = true;
vim.o.cursorline = true;

vim.o.tabstop = 8;
vim.o.expandtab = true;
vim.o.shiftwidth = 4;
vim.o.softtabstop = 2;
vim.o.smartindent = true;

vim.o.list = true;

vim.opt.fileencodings = {'ucs-bom', 'utf-8', 'default', 'big5', 'latin1'};
