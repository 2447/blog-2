((root, factory) ->
    'use strict'
    isElectron = typeof module == 'object' and process and process.versions and process.versions.electron
    if !isElectron and typeof module == 'object'
        module.exports = factory
    else if typeof define == 'function' and define.amd
        define ->
            factory
    else
        root.MediumEditorTable = factory
    return
) this, do ->

    extend = (dest, source) ->
        prop = undefined
        dest = dest or {}
        for prop of source
            `prop = prop`
            if source.hasOwnProperty(prop) and !dest.hasOwnProperty(prop)
                dest[prop] = source[prop]
        dest

    getSelectionText = (doc) ->
        if doc.getSelection
            return doc.getSelection().toString()
        if doc.selection and doc.selection.type != 'Control'
            return doc.selection.createRange().text
        ''

    getSelectionStart = (doc) ->
        node = doc.getSelection().anchorNode
        startNode = if node and node.nodeType == 3 then node.parentNode else node
        startNode

    placeCaretAtNode = (doc, node, before) ->
        if doc.getSelection != undefined and node
            range = doc.createRange()
            selection = doc.getSelection()
            if before
                range.setStartBefore node
            else
                range.setStartAfter node
            range.collapse true
            selection.removeAllRanges()
            selection.addRange range
        return

    isInsideElementOfTag = (node, tag) ->
        if !node
            return false
        parentNode = node.parentNode
        tagName = parentNode.tagName.toLowerCase()
        while tagName != 'body'
            if tagName == tag
                return true
            parentNode = parentNode.parentNode
            if parentNode and parentNode.tagName
                tagName = parentNode.tagName.toLowerCase()
            else
                return false
        false

    getParentOf = (el, tagTarget) ->
        tagName = if el and el.tagName then el.tagName.toLowerCase() else false
        if !tagName
            return false
        while tagName and tagName != 'body'
            if tagName == tagTarget
                return el
            el = el.parentNode
            tagName = if el and el.tagName then el.tagName.toLowerCase() else false
        return

    Grid = (el, callback, rows, columns) ->
        @init el, callback, rows, columns

    Builder = (options) ->
        @init options

    Table = (editor) ->
        @init editor

    'use strict'
    Grid.prototype =
        init: (el, callback, rows, columns) ->
            @_root = el
            @_callback = callback
            @rows = rows
            @columns = columns
            @_render()
        setCurrentCell: (cell) ->
            @_currentCell = cell
            return
        markCells: ->
            [].forEach.call @_cellsElements, ((el) ->
                cell =
                    column: parseInt(el.dataset.column, 10)
                    row: parseInt(el.dataset.row, 10)
                active = @_currentCell and cell.row <= @_currentCell.row and cell.column <= @_currentCell.column
                if active == true
                    el.classList.add 'active'
                else
                    el.classList.remove 'active'
                return
            ).bind(this)
            return
        _generateCells: ->
            row = -1
            @_cells = []
            i = 0
            while i < @rows * @columns
                column = i % @columns
                if column == 0
                    row++
                @_cells.push
                    column: column
                    row: row
                    active: false
                i++
            return
        _html: ->
            width = @columns * COLUMN_WIDTH + BORDER_WIDTH * 2
            height = @rows * COLUMN_WIDTH + BORDER_WIDTH * 2
            html = '<div class="medium-editor-table-builder-grid clearfix" style="width:' + width + 'px;height:' + height + 'px;">'
            html += @_cellsHTML()
            html += '</div>'
            html
        _cellsHTML: ->
            html = ''
            @_generateCells()
            @_cells.map (cell) ->
                html += '<a href="#" class="medium-editor-table-builder-cell' + (if cell.active == true then ' active' else '') + '" ' + 'data-row="' + cell.row + '" data-column="' + cell.column + '">'
                html += '</a>'
                return
            html
        _render: ->
            @_root.innerHTML = @_html()
            @_cellsElements = @_root.querySelectorAll('a')
            @_bindEvents()
            return
        _bindEvents: ->
            [].forEach.call @_cellsElements, ((el) ->
                @_onMouseEnter el
                @_onClick el
                return
            ).bind(this)
            return
        _onMouseEnter: (el) ->
            self = this
            timer = undefined
            el.addEventListener 'mouseenter', ->
                clearTimeout timer
                dataset = @dataset
                timer = setTimeout((->
                    self._currentCell =
                        column: parseInt(dataset.column, 10)
                        row: parseInt(dataset.row, 10)
                    self.markCells()
                    return
                ), 50)
                return
            return
        _onClick: (el) ->
            self = this
            el.addEventListener 'click', (e) ->
                e.preventDefault()
                self._callback @dataset.row, @dataset.column
                return
            return
    Builder.prototype =
        init: (options) ->
            @options = options
            @_doc = options.ownerDocument or document
            @_root = @_doc.createElement('div')
            @_root.className = 'medium-editor-table-builder'
            @grid = new Grid(@_root, @options.onClick, @options.rows, @options.columns)
            @_range = null
            @_toolbar = @_doc.createElement('div')
            @_toolbar.className = 'medium-editor-table-builder-toolbar'
            spanRow = @_doc.createElement('span')
            spanRow.innerHTML = 'Row:'
            @_toolbar.appendChild spanRow
            addRowBefore = @_doc.createElement('button')
            addRowBefore.title = 'Add row before'
            addRowBefore.innerHTML = '<i class="fa fa-long-arrow-up"></i>'
            addRowBefore.onclick = @addRow.bind(this, true)
            @_toolbar.appendChild addRowBefore
            addRowAfter = @_doc.createElement('button')
            addRowAfter.title = 'Add row after'
            addRowAfter.innerHTML = '<i class="fa fa-long-arrow-down"></i>'
            addRowAfter.onclick = @addRow.bind(this, false)
            @_toolbar.appendChild addRowAfter
            remRow = @_doc.createElement('button')
            remRow.title = 'Remove row'
            remRow.innerHTML = '<i class="fa fa-close"></i>'
            remRow.onclick = @removeRow.bind(this)
            @_toolbar.appendChild remRow
            spanCol = @_doc.createElement('span')
            spanCol.innerHTML = 'Column:'
            @_toolbar.appendChild spanCol
            addColumnBefore = @_doc.createElement('button')
            addColumnBefore.title = 'Add column before'
            addColumnBefore.innerHTML = '<i class="fa fa-long-arrow-left"></i>'
            addColumnBefore.onclick = @addColumn.bind(this, true)
            @_toolbar.appendChild addColumnBefore
            addColumnAfter = @_doc.createElement('button')
            addColumnAfter.title = 'Add column after'
            addColumnAfter.innerHTML = '<i class="fa fa-long-arrow-right"></i>'
            addColumnAfter.onclick = @addColumn.bind(this, false)
            @_toolbar.appendChild addColumnAfter
            remColumn = @_doc.createElement('button')
            remColumn.title = 'Remove column'
            remColumn.innerHTML = '<i class="fa fa-close"></i>'
            remColumn.onclick = @removeColumn.bind(this)
            @_toolbar.appendChild remColumn
            remTable = @_doc.createElement('button')
            remTable.title = 'Remove table'
            remTable.innerHTML = '<i class="fa fa-trash-o"></i>'
            remTable.onclick = @removeTable.bind(this)
            @_toolbar.appendChild remTable
            grid = @_root.childNodes[0]
            @_root.insertBefore @_toolbar, grid
            return
        getElement: ->
            @_root
        hide: ->
            @_root.style.display = ''
            @grid.setCurrentCell
                column: -1
                row: -1
            @grid.markCells()
            return
        show: (left) ->
            @_root.style.display = 'block'
            @_root.style.left = left + 'px'
            return
        setEditor: (range, restrictNestedTable) ->
            @_range = range
            @_toolbar.style.display = 'block'
            if restrictNestedTable
                elements = @_doc.getElementsByClassName('medium-editor-table-builder-grid')
                elements[0].style.display = 'none'
            return
        setBuilder: ->
            @_range = null
            @_toolbar.style.display = 'none'
            elements = @_doc.getElementsByClassName('medium-editor-table-builder-grid')
            elements[0].style.display = 'block'
            i = 0
            while i < elements.length
                elements[i].style.height = COLUMN_WIDTH * @rows + BORDER_WIDTH * 2 + 'px'
                elements[i].style.width = COLUMN_WIDTH * @columns + BORDER_WIDTH * 2 + 'px'
                i++
            return
        getParentType: (el, targetNode) ->
            nodeName = if el and el.nodeName then el.nodeName.toLowerCase() else false
            if !nodeName
                return false
            while nodeName and nodeName != 'body'
                if nodeName == targetNode
                    return el
                el = el.parentNode
                nodeName = if el and el.nodeName then el.nodeName.toLowerCase() else false
            return
        addRow: (before, e) ->
            e.preventDefault()
            e.stopPropagation()
            tbody = @getParentType(@_range, 'tbody')
            selectedTR = @getParentType(@_range, 'tr')
            tr = @_doc.createElement('tr')
            td = undefined
            i = 0
            while i < selectedTR.childNodes.length
                td = @_doc.createElement('td')
                td.appendChild @_doc.createElement('br')
                tr.appendChild td
                i++
            if before != true and selectedTR.nextSibling
                tbody.insertBefore tr, selectedTR.nextSibling
            else if before == true
                tbody.insertBefore tr, selectedTR
            else
                tbody.appendChild tr
            @options.onClick 0, 0
            return
        removeRow: (e) ->
            e.preventDefault()
            e.stopPropagation()
            tbody = @getParentType(@_range, 'tbody')
            selectedTR = @getParentType(@_range, 'tr')
            tbody.removeChild selectedTR
            @options.onClick 0, 0
            return
        addColumn: (before, e) ->
            e.preventDefault()
            e.stopPropagation()
            selectedTR = @getParentType(@_range, 'tr')
            selectedTD = @getParentType(@_range, 'td')
            cell = Array::indexOf.call(selectedTR.childNodes, selectedTD)
            tbody = @getParentType(@_range, 'tbody')
            td = undefined
            i = 0
            while i < tbody.childNodes.length
                td = @_doc.createElement('td')
                td.appendChild @_doc.createElement('br')
                if before == true
                    tbody.childNodes[i].insertBefore td, tbody.childNodes[i].childNodes[cell]
                else if tbody.childNodes[i].childNodes[cell].nextSibling
                    tbody.childNodes[i].insertBefore td, tbody.childNodes[i].childNodes[cell].nextSibling
                else
                    tbody.childNodes[i].appendChild td
                i++
            @options.onClick 0, 0
            return
        removeColumn: (e) ->
            e.preventDefault()
            e.stopPropagation()
            selectedTR = @getParentType(@_range, 'tr')
            selectedTD = @getParentType(@_range, 'td')
            cell = Array::indexOf.call(selectedTR.childNodes, selectedTD)
            tbody = @getParentType(@_range, 'tbody')
            rows = tbody.childNodes.length
            i = 0
            while i < rows
                tbody.childNodes[i].removeChild tbody.childNodes[i].childNodes[cell]
                i++
            @options.onClick 0, 0
            return
        removeTable: (e) ->
            e.preventDefault()
            e.stopPropagation()
            selectedTR = @getParentType(@_range, 'tr')
            selectedTD = @getParentType(@_range, 'td')
            cell = Array::indexOf.call(selectedTR.childNodes, selectedTD)
            table = @getParentType(@_range, 'table')
            table.parentNode.removeChild table
            @options.onClick 0, 0
            return
    TAB_KEY_CODE = 9
    Table.prototype =
        init: (editor) ->
            @_editor = editor
            @_doc = @_editor.options.ownerDocument
            @_bindTabBehavior()
            return
        insert: (rows, cols) ->
            html = @_html(rows, cols)
            @_editor.pasteHTML '<table class="medium-editor-table" id="medium-editor-table"' + ' width="100%">' + '<tbody id="medium-editor-table-tbody">' + html + '</tbody>' + '</table>',
                cleanAttrs: []
                cleanTags: []
            table = @_doc.getElementById('medium-editor-table')
            tbody = @_doc.getElementById('medium-editor-table-tbody')
            if 0 == $(table).find('#medium-editor-table-tbody').length
                #Edge case, where tbody gets appended outside table tag
                $(tbody).detach().appendTo table
            tbody.removeAttribute 'id'
            table.removeAttribute 'id'
            placeCaretAtNode @_doc, table.querySelector('td'), true
            @_editor.checkSelection()
            return
        _html: (rows, cols) ->
            html = ''
            x = undefined
            y = undefined
            text = getSelectionText(@_doc)
            x = 0
            td = 'th'
            while x <= rows
                html += '<tr>'
                y = 0
                while y <= cols
                    html += "<#{td}>" + (if x == 0 and y == 0 then text else '<br />') + "</#{td}>"
                    y++
                html += '</tr>'
                x++
                td = 'td'
            html
        _bindTabBehavior: ->
            self = this
            [].forEach.call @_editor.elements, (el) ->
                el.addEventListener 'keydown', (e) ->
                    self._onKeyDown e
                    return
                return
            return
        _onKeyDown: (e) ->
            el = getSelectionStart(@_doc)
            table = undefined
            if e.which == TAB_KEY_CODE and isInsideElementOfTag(el, 'table')
                e.preventDefault()
                e.stopPropagation()
                table = @_getTableElements(el)
                if e.shiftKey
                    @_tabBackwards el.previousSibling, table.row
                else
                    if @_isLastCell(el, table.row, table.root)
                        @_insertRow getParentOf(el, 'tbody'), table.row.cells.length
                    placeCaretAtNode @_doc, el
            return
        _getTableElements: (el) ->
            {
                cell: getParentOf(el, 'td')
                row: getParentOf(el, 'tr')
                root: getParentOf(el, 'table')
            }
        _tabBackwards: (el, row) ->
            el = el or @_getPreviousRowLastCell(row)
            placeCaretAtNode @_doc, el, true
            return
        _insertRow: (tbody, cols) ->
            tr = document.createElement('tr')
            html = ''
            i = undefined
            i = 0
            while i < cols
                html += '<td><br /></td>'
                i += 1
            tr.innerHTML = html
            tbody.appendChild tr
            return
        _isLastCell: (el, row, table) ->
            row.cells.length - 1 == el.cellIndex and table.rows.length - 1 == row.rowIndex
        _getPreviousRowLastCell: (row) ->
            row = row.previousSibling
            if row
                return row.cells[row.cells.length - 1]
            return
    COLUMN_WIDTH = 16
    BORDER_WIDTH = 1
    MediumEditorTable = undefined
    MediumEditorTable = MediumEditor.extensions.form.extend(
        name: 'table'
        aria: 'create table'
        action: 'table'
        contentDefault: 'TBL'
        contentFA: '<i class="fa fa-table"></i>'
        handleClick: (event) ->
            event.preventDefault()
            event.stopPropagation()
            @[if @isActive() == true then 'hide' else 'show']()
            return
        hide: ->
            @setInactive()
            @builder.hide()
            return
        show: ->
            @setActive()
            range = MediumEditor.selection.getSelectionRange(@document)
            if range.startContainer.nodeName.toLowerCase() == 'td' or range.endContainer.nodeName.toLowerCase() == 'td' or MediumEditor.util.getClosestTag(MediumEditor.selection.getSelectedParentElement(range), 'td')
                @builder.setEditor MediumEditor.selection.getSelectedParentElement(range), @restrictNestedTable
            else
                @builder.setBuilder()
            @builder.show @button.offsetLeft
            return
        getForm: ->
            if !@builder
                @builder = new Builder(
                    onClick: ((rows, columns) ->
                        if rows > 0 or columns > 0
                            @table.insert rows, columns
                        @hide()
                        return
                    ).bind(this)
                    ownerDocument: @document
                    rows: @rows or 10
                    columns: @columns or 10)
                @table = new Table(@base)
            @builder.getElement()
    )
    MediumEditorTable
