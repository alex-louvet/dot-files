-- ~/.config/nvim/lua/plugins/orgmode-wiki.lua  (lazy.nvim spec)
--
-- Flat wiki layout (Orgzly-friendly: WebDAV/local repos in Orgzly only
-- sync files directly inside a folder, never subfolders).
--
-- ~/Nextcloud/wiki/
-- ├── inbox.org               quick/unfiled capture lands here
-- ├── project-<slug>.org     one file per project; aspects = headlines
-- ├── course-<slug>.org      one file per course; aspects = headlines
-- └── <slug>.org             personal notes, and anything "promoted"
--                              out of a project/course file
--
-- No index pages: <leader>nf is a live fuzzy search over every note's
-- title + tags (type "project"/"course"/"personal" to filter), so
-- there's nothing to keep in sync or rebuild.
--
-- Create once:
--   mkdir -p ~/Nextcloud/wiki
--   touch ~/Nextcloud/wiki/inbox.org

local WIKI = vim.fn.expand '~/TheAbyss/wiki'

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------

local function slugify(title)
  return (title:lower():gsub('[^%w]+', '-'):gsub('^-+', ''):gsub('-+$', ''))
end

local function title_of(file)
  if vim.fn.filereadable(file) == 1 then
    for line in io.lines(file) do
      local t = line:match '^#%+TITLE:%s*(.+)'
      if t then
        return t
      end
    end
  end
  return vim.fn.fnamemodify(file, ':t:r')
end

local function tags_of(file)
  if vim.fn.filereadable(file) == 1 then
    for line in io.lines(file) do
      local t = line:match '^#%+FILETAGS:%s*(.+)'
      if t then
        return t
      end
    end
  end
  return ''
end

local function new_tagged_file(tag, label)
  local title = vim.fn.input(label .. ' title: ')
  if title == '' then
    return
  end
  local file = WIKI .. '/' .. slugify(title) .. '.org'
  vim.fn.writefile({
    '#+TITLE: ' .. title,
    '#+FILETAGS: :' .. tag .. ':',
    '',
    '* Tasks',
    '',
  }, file)
  vim.cmd('edit ' .. file)
end

local function new_personal_note()
  local title = vim.fn.input 'Personal note title: '
  if title == '' then
    return
  end
  local file = WIKI .. '/' .. slugify(title) .. '.org'
  vim.fn.writefile({ '#+TITLE: ' .. title, '#+FILETAGS: :personal:', '' }, file)
  vim.cmd('edit ' .. file)
end

-- Append a new headline ("aspect") at the end of the current file and
-- drop into Insert mode ready to write its body.
local function new_aspect()
  local title = vim.fn.input 'Aspect title: '
  if title == '' then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local last = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, last, last, false, { '', '** ' .. title, '' })
  vim.api.nvim_win_set_cursor(0, { last + 3, 0 })
  vim.cmd 'startinsert!'
end

-- Turn the headline under the cursor into a standalone file. The
-- headline itself (and any TODO/DEADLINE on it) stays in place; its
-- body becomes the new file, linked from where the body used to be.
local function promote_to_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local headline = lines[row]
  local stars, rest = headline:match '^(%*+)%s+(.*)$'
  if not stars then
    vim.notify('Cursor is not on a headline', vim.log.levels.WARN)
    return
  end
  local level = #stars
  local title = rest:gsub('^%u%u+%s+', ''):gsub('%s+:[%w:]+:%s*$', ''):gsub('%s+$', '')

  local end_row = row
  for i = row + 1, #lines do
    local s = lines[i]:match '^(%*+)%s'
    if s and #s <= level then
      break
    end
    end_row = i
  end

  local body = {}
  for i = row + 1, end_row do
    local l = lines[i]
    local s, r = l:match '^(%*+)(%s.*)$'
    if s then
      table.insert(body, string.rep('*', math.max(1, #s - level)) .. r)
    else
      table.insert(body, l)
    end
  end

  local slug = slugify(title)
  local file = WIKI .. '/' .. slug .. '.org'
  local content = { '#+TITLE: ' .. title, '' }
  vim.list_extend(content, body)
  vim.fn.writefile(content, file)

  local indent = string.rep(' ', level + 1)
  vim.api.nvim_buf_set_lines(bufnr, row, end_row, false, {
    indent .. '- [[file:./' .. slug .. '.org][' .. title .. ']]',
  })
  vim.notify('Promoted to ' .. slug .. '.org')
end

-- Realign the org table under the cursor by directly rewriting its
-- lines (self-contained; doesn't depend on nvim-orgmode's own
-- Tab/insert-mode table handling).
local function realign_table()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local total = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, total, false)

  local function is_table_line(line)
    return line ~= nil and line:match '^%s*|' ~= nil
  end

  if not is_table_line(lines[row]) then
    vim.notify('Cursor is not on a table line', vim.log.levels.WARN)
    return
  end

  local start_row = row
  while start_row > 1 and is_table_line(lines[start_row - 1]) do
    start_row = start_row - 1
  end
  local end_row = row
  while end_row < total and is_table_line(lines[end_row + 1]) do
    end_row = end_row + 1
  end

  local function is_separator(line)
    return line:match '^%s*|[%-%+:|]+%s*$' ~= nil
  end

  local function split_cells(line)
    local trimmed = line:match('^%s*(.-)%s*$'):gsub('^|', ''):gsub('|$', '')
    local cells = {}
    for cell in (trimmed .. '|'):gmatch '(.-)|' do
      table.insert(cells, cell:match '^%s*(.-)%s*$')
    end
    return cells
  end

  local rows, ncols = {}, 0
  for i = start_row, end_row do
    local line = lines[i]
    if is_separator(line) then
      table.insert(rows, { sep = true })
    else
      local cells = split_cells(line)
      ncols = math.max(ncols, #cells)
      table.insert(rows, { sep = false, cells = cells })
    end
  end

  local widths = {}
  for i = 1, ncols do
    widths[i] = 1
  end
  for _, r in ipairs(rows) do
    if not r.sep then
      for i, cell in ipairs(r.cells) do
        widths[i] = math.max(widths[i], vim.fn.strdisplaywidth(cell))
      end
    end
  end

  local function pad(s, width)
    return s .. string.rep(' ', math.max(0, width - vim.fn.strdisplaywidth(s)))
  end

  local new_lines = {}
  for _, r in ipairs(rows) do
    if r.sep then
      local parts = {}
      for i = 1, ncols do
        table.insert(parts, string.rep('-', widths[i] + 2))
      end
      table.insert(new_lines, '|' .. table.concat(parts, '+') .. '|')
    else
      local parts = {}
      for i = 1, ncols do
        table.insert(parts, ' ' .. pad(r.cells[i] or '', widths[i]) .. ' ')
      end
      table.insert(new_lines, '|' .. table.concat(parts, '|') .. '|')
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, start_row - 1, end_row, false, new_lines)
  vim.api.nvim_win_set_cursor(0, { row, 0 })
end

----------------------------------------------------------------------
-- Telescope: find-or-create a note by title. Replaces both the old
-- static index pages and org-roam.nvim. Type "project"/"course"/
-- "personal" to filter via fuzzy match against title+tags; select an
-- existing entry to use it, or press Enter with no match to create a
-- new plain note titled exactly what you typed.
----------------------------------------------------------------------

local function get_notes()
  local files = vim.fn.globpath(WIKI, '*.org', false, true)
  table.sort(files)
  local notes = {}
  for _, f in ipairs(files) do
    local t = title_of(f)
    local tags = tags_of(f)
    table.insert(notes, {
      file = f,
      title = t,
      tags = tags,
      display = string.format('%-45s %s', t, tags),
    })
  end
  return notes
end

local function find_or_create_note(on_select)
  local ok_pickers, pickers = pcall(require, 'telescope.pickers')
  if not ok_pickers then
    vim.notify('telescope.nvim not found', vim.log.levels.ERROR)
    return
  end
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'Find or create note',
      finder = finders.new_table {
        results = get_notes(),
        entry_maker = function(entry)
          return { value = entry, display = entry.display, ordinal = entry.title .. ' ' .. entry.tags }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          local prompt = action_state.get_current_line()
          actions.close(prompt_bufnr)
          if selection then
            on_select(selection.value.file, selection.value.title)
          elseif prompt ~= '' then
            local file = WIKI .. '/' .. slugify(prompt) .. '.org'
            if vim.fn.filereadable(file) ~= 1 then
              vim.fn.writefile({ '#+TITLE: ' .. prompt, '' }, file)
            end
            on_select(file, prompt)
          end
        end)
        return true
      end,
    })
    :find()
end

----------------------------------------------------------------------
return {
  ----------------------------------------------------------------------
  -- Core: TODOs, deadlines, agenda/calendar
  ----------------------------------------------------------------------
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('orgmode').setup {
        org_agenda_files = WIKI .. '/*.org',
        org_default_notes_file = WIKI .. '/inbox.org',

        org_todo_keywords = { 'TODO(t)', 'NEXT(n)', '|', 'DONE(d)', 'CANCELLED(c)' },

        org_agenda_span = 'month',
        org_deadline_warning_days = 14,

        org_capture_templates = {
          t = { description = 'Inbox: quick todo', template = '* TODO %?\n  %u' },
        },

        mappings = {
          global = {
            org_agenda = '<leader>oa',
            org_capture = '<leader>oc',
          },
          org = {
            org_todo = '<leader>ot',
            org_todo_prev = '<leader>oT',
            org_deadline = '<leader>od',
            org_schedule = '<leader>os',
            org_toggle_checkbox = '<leader>ox',
            org_open_at_point = '<CR>',
          },
        },
      }

      vim.keymap.set('n', '<leader>np', function()
        new_tagged_file('project', 'Project')
      end, { desc = 'New research project' })
      vim.keymap.set('n', '<leader>nc', function()
        new_tagged_file('course', 'Course')
      end, { desc = 'New course' })
      vim.keymap.set('n', '<leader>ns', new_personal_note, { desc = 'New personal note' })
      vim.keymap.set('n', '<leader>na', new_aspect, { desc = 'New aspect (headline) in current file' })
      vim.keymap.set('n', '<leader>nP', promote_to_file, { desc = 'Promote headline under cursor to its own file' })
      vim.keymap.set('n', '<leader>oR', realign_table, { desc = 'Realign table' })

      vim.keymap.set('n', '<leader>nf', function()
        find_or_create_note(function(file)
          vim.cmd('edit ' .. file)
        end)
      end, { desc = 'Find or create note' })

      vim.keymap.set('i', '<C-l>', function()
        vim.cmd 'stopinsert'
        find_or_create_note(function(file, title)
          local link = string.format('[[file:./%s][%s]]', vim.fn.fnamemodify(file, ':t'), title)
          vim.api.nvim_put({ link }, 'c', true, true)
          vim.cmd 'startinsert'
        end)
      end, { desc = 'Insert link to note' })

      -- Cycle through links with ]] / [[, org buffers only.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'org',
        callback = function(args)
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = 'nc'
          vim.keymap.set('n', ']]', function()
            vim.fn.search('\\[\\[.\\{-}\\]\\]', '')
          end, { buffer = args.buf, desc = 'Next link' })
          vim.keymap.set('n', '[[', function()
            vim.fn.search('\\[\\[.\\{-}\\]\\]', 'b')
          end, { buffer = args.buf, desc = 'Previous link' })
        end,
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Nice rendering in Neovim (bullets instead of raw asterisks)
  ----------------------------------------------------------------------
  {
    'nvim-orgmode/org-bullets.nvim',
    ft = { 'org' },
    config = function()
      require('org-bullets').setup()
    end,
  },

  ----------------------------------------------------------------------
  -- Calendar view of deadlines/scheduled items
  ----------------------------------------------------------------------
  {
    'wsdjeg/calendar.nvim',
    keys = {
      {
        '<leader>ov',
        function()
          require('calendar').open()
          local calendar_buf = vim.api.nvim_get_current_buf()
          local float_win = vim.api.nvim_get_current_win()
          vim.cmd 'botright new'
          vim.api.nvim_win_set_buf(0, calendar_buf)
          pcall(vim.api.nvim_win_close, float_win, true)
        end,
        desc = 'Calendar view of deadlines',
      },
    },
    config = function()
      require('calendar').setup { mark_icon = '•' }

      local function scan_deadlines()
        local by_date = {}
        local files = vim.fn.globpath(WIKI, '*.org', false, true)
        for _, f in ipairs(files) do
          local heading = nil
          for line in io.lines(f) do
            local h = line:match '^%*+%s+(.*)'
            if h then
              heading = h
            end
            local date = line:match 'DEADLINE:%s*<(%d%d%d%d%-%d%d%-%d%d)' or line:match 'SCHEDULED:%s*<(%d%d%d%d%-%d%d%-%d%d)'
            if date then
              by_date[date] = by_date[date] or {}
              table.insert(by_date[date], { file = f, text = heading or vim.fn.fnamemodify(f, ':t') })
            end
          end
        end
        return by_date
      end

      local wiki_ext = {}

      function wiki_ext.get(year, month)
        local by_date = scan_deadlines()
        local prefix = string.format('%04d-%02d-', year, month)
        local marks = {}
        for date, _ in pairs(by_date) do
          if date:sub(1, 8) == prefix then
            table.insert(marks, { year = year, month = month, day = tonumber(date:sub(9, 10)) })
          end
        end
        return marks
      end

      wiki_ext.actions = {
        show_items = function(year, month, day)
          local by_date = scan_deadlines()
          local date = string.format('%04d-%02d-%02d', year, month, day)
          local items = by_date[date]
          if not items or #items == 0 then
            vim.notify('Nothing due on ' .. date)
            return
          end
          local labels = {}
          for _, it in ipairs(items) do
            table.insert(labels, it.text)
          end
          vim.ui.select(labels, { prompt = 'Due on ' .. date .. ':' }, function(_, idx)
            if idx then
              vim.cmd('edit ' .. items[idx].file)
            end
          end)
        end,
      }

      require('calendar.extensions').register('wiki-deadlines', wiki_ext)
    end,
  },
}
