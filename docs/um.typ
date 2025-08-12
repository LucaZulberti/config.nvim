= Neovim Configuration User Manual

This document describes options, keymaps and plugins that are active in this Neovim configuration and can be used for reference.

== Neovim Options

Here the list of most important Neovim options set in `set.lua`:

#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: left,
)

#table(
  columns: 2,
  table.header([Option], [Description]),
  [`mouse =`], [Disabled to force learning vim-motions],
  [`relativenumber = true`], [Show line numbers as relative distance from current line],
  [`...`], [...],
)

== General Keymaps

This is the list of custom keymaps

== Plugin List



