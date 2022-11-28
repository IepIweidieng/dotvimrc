-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.g.init = vim.g.init or {};
local on_colorscheme_loaded = vim.g.init.on_colorscheme_loaded or function() end;

local packer_dir = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim';
if vim.fn.isdirectory(packer_dir) == 0 then
    vim.api.nvim_echo({{'Installing packer.nvim...', 'Type'}}, true, {});

    -- update flags
    local init = vim.g.init;
    init.packer_bootstrap = true;
    vim.g.init = init;

    local packer_repo = 'https://github.com/wbthomason/packer.nvim';
    vim.fn.jobstart(
        {'git', 'clone', '--depth=1', packer_repo, packer_dir},
        {
            detach = true,
            on_exit = function()
                vim.api.nvim_echo({{'Completed installing packer.nvim.', 'Type'}}, true, {});
                -- forced reload
                package.loaded.plugins = nil;
                require 'plugins';
            end,
        }
    );
    return nil;
end

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim');

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim';

    -- Retro groove color scheme for Vim
    use {'morhetz/gruvbox', config = on_colorscheme_loaded};

    -- lean & mean status/tabline for vim that's light as air
    use 'vim-airline/vim-airline';

    -- fugitive.vim: A Git wrapper so awesome, it should be illegal
    use 'tpope/vim-fugitive';

    -- dispatch.vim: Asynchronous build and test dispatcher
    use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}};

    --[[hexokinase.vim - The fastest (Neo)Vim plugin for asynchronously displaying
        the colours in the file (#rrggbb, #rgb, rgb(a)? functions, hsl(a)?
        functions, web colours, custom patterns)
        (Golang must be installed)
    ]]
    use {'rrethy/vim-hexokinase', run = 'make hexokinase'};

    -- Improved AnsiEsc.vim: ansi escape sequences concealed, but highlighted as specified (conceal)
    use {'powerman/vim-plugin-AnsiEsc', opt = true, cmd = {'AnsiEsc'}};

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if vim.g.init.packer_bootstrap then
        require('packer').sync();
    end
end);
