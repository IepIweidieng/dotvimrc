-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.g.init = vim.g.init or {};
local on_colorscheme_loaded = vim.g.init.on_colorscheme_loaded or function() end;

local lazypath = vim.fn.stdpath("data") .. '/lazy/lazy.nvim';
if not vim.loop.fs_stat(lazypath) then
    vim.api.nvim_echo({{'Installing lazy.nvim...', 'Type'}}, true, {});

    local lazyrepo = 'https://github.com/folke/lazy.nvim.git';
    local lazybranch = '--branch=stable'; -- latest stable release
    vim.fn.jobstart(
        {'git', 'clone', '--filter=blob:none', lazyrepo, lazybranch, lazypath},
        {
            detach = true,
            on_exit = function()
                vim.api.nvim_echo({{'Completed installing lazy.nvim.', 'Type'}}, true, {});
                -- forced reload
                package.loaded.plugins = nil;
                require 'plugins';
            end,
        });
    return;
end
vim.opt.rtp:prepend(lazypath);

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
    -- Retro groove color scheme for Vim
    {'morhetz/gruvbox', config = on_colorscheme_loaded},

    -- lean & mean status/tabline for vim that's light as air
    'vim-airline/vim-airline',

    -- fugitive.vim: A Git wrapper so awesome, it should be illegal
    'tpope/vim-fugitive',

    -- dispatch.vim: Asynchronous build and test dispatcher
    {'tpope/vim-dispatch', cmd = {'Dispatch', 'Make', 'Focus', 'Start'}},

    --[[hexokinase.vim - The fastest (Neo)Vim plugin for asynchronously displaying
        the colours in the file (#rrggbb, #rgb, rgb(a)? functions, hsl(a)?
        functions, web colours, custom patterns)
        (Golang must be installed)
    ]]
    {'rrethy/vim-hexokinase', build = 'make hexokinase'},

    -- Improved AnsiEsc.vim: ansi escape sequences concealed, but highlighted as specified (conceal)
    {'powerman/vim-plugin-AnsiEsc', cmd = {'AnsiEsc'}},
});
