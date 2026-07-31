-- ~/.config/nvim/lua/plugins/orgmode-wiki.lua  (lazy.nvim spec)
--
-- Wiki layout (inside your Nextcloud-synced folder). Both research and
-- teaching are two-level: a project/course is itself an index page that
-- links out to individual notes on different aspects of it.
--
-- ~/Nextcloud/wiki/
-- ├── index.org
-- ├── inbox.org                         <- quick/unfiled capture lands here
-- ├── research/
-- │   ├── index.org                     <- auto-generated, lists projects
-- │   └── projects/
-- │       └── <project>/
-- │           ├── index.org             <- project dashboard: Tasks (hand-
-- │           │                            edited) + Pages (auto-generated
-- │           │                            list of this project's notes)
-- │           ├── <note-a>.org
-- │           └── <note-b>.org
-- ├── teaching/
-- │   ├── index.org                     <- auto-generated, lists courses
-- │   └── courses/
-- │       └── <course>/
-- │           ├── index.org             <- same shape as a project index
-- │           ├── <note-a>.org
-- │           └── <note-b>.org
-- └── personal/
--     ├── index.org                     <- auto-generated (Tasks + Pages),
--     │                                    refreshed on every capture
--     ├── <note-a>.org
--     └── <note-b>.org
--
-- Create the folders once:
--   mkdir -p ~/Nextcloud/wiki/research/projects ~/Nextcloud/wiki/teaching/courses ~/Nextcloud/wiki/personal
--   touch ~/Nextcloud/wiki/index.org ~/Nextcloud/wiki/inbox.org
-- Individual project/course folders are created for you by <leader>np / <leader>nc.
-- personal/index.org is created and kept up to date automatically by <leader>ns.

local WIKI = vim.fn.expand '~/TheAbyss/wiki'
local BEGIN_MARK = '# BEGIN-AUTO-INDEX'
local END_MARK = '# END-AUTO-INDEX'

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

-- Replace only the lines between BEGIN_MARK/END_MARK, preserving everything
-- else in the file (so hand-written Tasks/notes are never touched).
local function update_auto_section(file, new_lines)
  local lines = {}
  if vim.fn.filereadable(file) == 1 then
    lines = vim.fn.readfile(file)
  end
  local begin_idx, end_idx
  for i, l in ipairs(lines) do
    if l == BEGIN_MARK then
      begin_idx = i
    end
    if l == END_MARK then
      end_idx = i
    end
  end
  local result = {}
  if begin_idx and end_idx and end_idx > begin_idx then
    for i = 1, begin_idx do
      table.insert(result, lines[i])
    end
    for _, l in ipairs(new_lines) do
      table.insert(result, l)
    end
    for i = end_idx, #lines do
      table.insert(result, lines[i])
    end
  else
    for _, l in ipairs(lines) do
      table.insert(result, l)
    end
    if #result > 0 then
      table.insert(result, '')
    end
    table.insert(result, '* Pages')
    table.insert(result, BEGIN_MARK)
    for _, l in ipairs(new_lines) do
      table.insert(result, l)
    end
    table.insert(result, END_MARK)
  end
  vim.fn.writefile(result, file)
end

local function ensure_file(file, initial_lines)
  if vim.fn.filereadable(file) ~= 1 then
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
    vim.fn.writefile(initial_lines, file)
  end
end

-- Flat area: personal/<note>.org, auto-indexed into personal/index.org
-- every time a note is captured (no manual rebuild needed for this one).
local function rebuild_personal_index()
  local dir = WIKI .. '/personal'
  ensure_file(dir .. '/index.org', {
    '#+TITLE: Personal',
    '',
    '* Tasks',
    '',
    '* Pages',
    BEGIN_MARK,
    END_MARK,
  })
  local files = vim.fn.globpath(dir, '*.org', false, true)
  table.sort(files)
  local page_lines = {}
  for _, f in ipairs(files) do
    if vim.fn.fnamemodify(f, ':t') ~= 'index.org' then
      table.insert(page_lines, string.format('- [[file:./%s][%s]]', vim.fn.fnamemodify(f, ':t'), title_of(f)))
    end
  end
  update_auto_section(dir .. '/index.org', page_lines)
end

local function new_personal_note()
  local dir = WIKI .. '/personal'
  vim.fn.mkdir(dir, 'p')
  local title = vim.fn.input 'Personal note title: '
  if title == '' then
    return
  end
  local file = dir .. '/' .. slugify(title) .. '.org'
  vim.fn.writefile({ '#+TITLE: ' .. title, '' }, file)
  rebuild_personal_index()
  vim.cmd('edit ' .. file)
end

local function new_container(root, label)
  local title = vim.fn.input(label .. ' title: ')
  if title == '' then
    return
  end
  local slug = slugify(title)
  local dir = root .. '/' .. slug
  vim.fn.mkdir(dir, 'p')
  local index = dir .. '/index.org'
  vim.fn.writefile({
    '#+TITLE: ' .. title,
    '',
    '* Tasks',
    '',
    '* Pages',
    BEGIN_MARK,
    END_MARK,
  }, index)
  vim.cmd('edit ' .. index)
end

local function in_container_dir(dir)
  return dir:match('^' .. vim.pesc(WIKI) .. '/research/projects/[^/]+$') or dir:match('^' .. vim.pesc(WIKI) .. '/teaching/courses/[^/]+$')
end

local function create_note_in(dir)
  local title = vim.fn.input 'Note title: '
  if title == '' then
    return
  end
  local file = dir .. '/' .. slugify(title) .. '.org'
  vim.fn.writefile({ '#+TITLE: ' .. title, '' }, file)
  vim.cmd('edit ' .. file)
end

local function new_note_here()
  local cur_dir = vim.fn.expand '%:p:h'
  if in_container_dir(cur_dir) then
    create_note_in(cur_dir)
    return
  end
  local roots = {}
  for _, base in ipairs { WIKI .. '/research/projects', WIKI .. '/teaching/courses' } do
    for _, d in ipairs(vim.fn.globpath(base, '*', false, true)) do
      if vim.fn.isdirectory(d) == 1 then
        table.insert(roots, d)
      end
    end
  end
  vim.ui.select(roots, {
    prompt = 'Add note to:',
    format_item = function(d)
      return title_of(d .. '/index.org')
    end,
  }, function(choice)
    if choice then
      create_note_in(choice)
    end
  end)
end

-- Realign the org table under the cursor by directly rewriting its lines.
-- Self-contained (no dependency on nvim-orgmode's own Tab/insert-mode
-- table handling), so it works regardless of treesitter/mode quirks.
local function realign_table()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)
  local row = cur[1]
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

local function rebuild_indexes()
  for _, spec in ipairs {
    { root = WIKI .. '/research/projects', top = WIKI .. '/research/index.org', heading = 'Research Projects', subdir = 'projects' },
    { root = WIKI .. '/teaching/courses', top = WIKI .. '/teaching/index.org', heading = 'Courses', subdir = 'courses' },
  } do
    local containers = vim.fn.globpath(spec.root, '*', false, true)
    table.sort(containers)
    ensure_file(spec.top, {
      '#+TITLE: ' .. spec.heading,
      '',
      '* Pages',
      BEGIN_MARK,
      END_MARK,
    })
    local top_page_lines = {}
    for _, dir in ipairs(containers) do
      if vim.fn.isdirectory(dir) == 1 then
        local index_file = dir .. '/index.org'
        local files = vim.fn.globpath(dir, '*.org', false, true)
        table.sort(files)
        local page_lines = {}
        for _, f in ipairs(files) do
          if vim.fn.fnamemodify(f, ':t') ~= 'index.org' then
            table.insert(page_lines, string.format('- [[file:./%s][%s]]', vim.fn.fnamemodify(f, ':t'), title_of(f)))
          end
        end
        update_auto_section(index_file, page_lines)

        local name = vim.fn.fnamemodify(dir, ':t')
        table.insert(top_page_lines, string.format('- [[file:./%s/%s/index.org][%s]]', spec.subdir, name, title_of(index_file)))
      end
    end
    update_auto_section(spec.top, top_page_lines)
  end
  rebuild_personal_index()
  vim.notify 'Wiki indexes rebuilt'
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
    config = function()
      require('orgmode').setup {
        org_agenda_files = WIKI .. '/**/*.org',
        org_default_notes_file = WIKI .. '/inbox.org',

        org_todo_keywords = { 'TODO(t)', 'NEXT(n)', '|', 'DONE(d)', 'CANCELLED(c)' },

        org_agenda_span = 'month',
        org_deadline_warning_days = 14,

        org_capture_templates = {
          t = { description = 'Inbox: quick todo', template = '* TODO %?\n  %u' },
        },

        mappings = {
          global = {
            org_agenda = '<leader>oa', -- open calendar/agenda
            org_capture = '<leader>oc', -- quick unfiled capture
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
        new_container(WIKI .. '/research/projects', 'Project')
      end, { desc = 'New research project' })
      vim.keymap.set('n', '<leader>nc', function()
        new_container(WIKI .. '/teaching/courses', 'Course')
      end, { desc = 'New course' })
      vim.keymap.set('n', '<leader>na', new_note_here, { desc = 'New note in current project/course' })
      vim.keymap.set('n', '<leader>ns', new_personal_note, { desc = 'New personal note (auto-indexed)' })
      vim.keymap.set('n', '<leader>oi', rebuild_indexes, { desc = 'Rebuild wiki index pages' })

      -- Realign the table under the cursor. Rewrites the table's lines
      -- directly rather than relying on nvim-orgmode's own Tab-in-table
      -- handling (which turned out to require conditions that weren't
      -- panning out reliably here).
      vim.keymap.set('n', '<leader>oR', realign_table, { desc = 'Realign table' })

      -- Cycle through links with ]] / [[, org buffers only (Tab is already
      -- claimed by headline folding and table-cell movement, so it's not
      -- reused here; ]]/[[ are scoped to .org so their usual Vim meaning
      -- elsewhere is untouched).
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'org',
        callback = function(args)
          -- Conceal [[file:...][Description]] down to just "Description".
          -- concealcursor = "nc" reveals the raw syntax only when the
          -- cursor line is being edited in Insert mode; Normal/Command
          -- mode stay concealed everywhere, including the cursor line.
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
  -- Wiki-style linking: find-or-create a note by title, anywhere in the wiki
  ----------------------------------------------------------------------
  {
    'chipsenkbeil/org-roam.nvim',
    dependencies = { 'nvim-orgmode/orgmode' },
    config = function()
      require('org-roam').setup {
        directory = WIKI,
        org_files = { WIKI .. '/**/*.org' },
        bindings = false, -- only the two mappings below, nothing else
      }

      vim.keymap.set('n', '<leader>nf', function()
        require('org-roam.api').find_node()
      end, { desc = 'Find or create linked note' })

      vim.keymap.set('i', '<C-l>', function()
        require('org-roam.api').complete_at_point()
      end, { desc = 'Insert link to note' })
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
  -- Calendar view of deadlines/scheduled items: a real month grid, not
  -- just a linear agenda list. Days that have something due are marked;
  -- picking a marked day lists what's due and lets you jump to it.
  ----------------------------------------------------------------------
  {
    'wsdjeg/calendar.nvim',
    keys = {
      {
        '<leader>ov',
        function()
          -- calendar.nvim always opens in a floating window (no config
          -- option to change that), so grab its buffer right after
          -- opening and move it into a normal bottom split instead.
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
      require('calendar').setup {
        mark_icon = '•',
      }

      -- Scan every org file for DEADLINE/SCHEDULED dates, grouped by date.
      local function scan_deadlines()
        local by_date = {}
        local files = vim.fn.globpath(WIKI, '**/*.org', false, true)
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
