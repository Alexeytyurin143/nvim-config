-- Автоустановка packer, если он не установлен
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true, если packer только что был установлен

-- автокоманда, которая перезагружает neovim и устанавливает/обновляет/удаляет плагины при сохранении файла
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- импорт 'packer' в безопасном режиме
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- добавление списка плагинов для установки
return packer.startup(function(use)
	-- packer может управлять собой
	use("wbthomason/packer.nvim")

	use("nvim-lua/plenary.nvim") -- функции lua, которые используются многими плагинами

	use("bluz71/vim-nightfly-guicolors") -- цветовая схема

	use("christoomey/vim-tmux-navigator") -- tmux и навигация окнам

	use("szw/vim-maximizer") -- разворачивание активного окна

	-- важные плагины
	use("tpope/vim-surround") -- добавление, изменение, удаление кавычек
	use("inkarkat/vim-ReplaceWithRegister") -- замена с учетом регистра

	-- комментирование
	use("numToStr/Comment.nvim")

	-- дерево файлов и папок
	use("nvim-tree/nvim-tree.lua")

	-- иконки как в VSCode
	use("nvim-tree/nvim-web-devicons")

	-- статус-бар
	use("nvim-lualine/lualine.nvim")

	-- поиск с telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- зависимость для лучшей производительности сортировки
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- нечеткий поиск

	-- автодополнение
	use("hrsh7th/nvim-cmp") -- плагин для работы автодополнения
	use("hrsh7th/cmp-buffer") -- автодополнение для текста в буфере
	use("hrsh7th/cmp-path") -- автодополнение путей

	-- сниппеты
	use("L3MON4D3/LuaSnip") -- движок для сниппетов
	use("saadparwaiz1/cmp_luasnip") -- для автодополнения
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- управление и установка lsp серверов, линтеров и форматтеров
	use("williamboman/mason.nvim") -- отвечает за управление lsp серверами, линтерами и форматорами
	use("williamboman/mason-lspconfig.nvim") -- мост между mason и lspconfig

	-- настройка lsp серверов
	use("neovim/nvim-lspconfig") -- легкая настройка lsp серверов
	use("hrsh7th/cmp-nvim-lsp") -- для автодополнения
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- улучшение интерфейса lsp
	use("jose-elias-alvarez/typescript.nvim") -- доп. функционал для typescript сервера (например переименование файла, обновление импорта)
	use("onsails/lspkind.nvim") -- иконки как в VSCode для автодополнения

	-- форматтеры и линтеры
	use("jose-elias-alvarez/null-ls.nvim") -- настройка форматтеров и линтеров
	use("jayp0521/mason-null-ls.nvim") -- мост между mason и null-ls

	-- настройка treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- автозакрытие
	use("windwp/nvim-autopairs") -- автозакрытие скобок, кавычек и т.д.
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- автозакрытие тегов

	-- интеграция с git
	use("lewis6991/gitsigns.nvim") -- отображение линий изменения слева

	if packer_bootstrap then
		require("packer").sync()
	end
end)
