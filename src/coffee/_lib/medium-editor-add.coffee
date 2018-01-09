
Core::toggleButtons = (e) ->
  $el = $(e.target)
  selection = window.getSelection()
  that = this
  if @options.enabled == false
    return
  if !selection or selection.rangeCount == 0
    $current = $el
  else
    range = selection.getRangeAt(0)
    $current = $(range.commonAncestorContainer)
  # When user clicks on  editor's placeholder in FF, $current el is editor itself, not the first paragraph as it should
  if $current.hasClass('medium-editor-insert-plugin')
    $current = $current.find('p:first')
  $p = if $current.is('p') then $current else $current.closest('p')
  @clean()
  if $el.hasClass('medium-editor-placeholder') == false and $el.closest('.medium-insert-buttons').length == 0 and $current.closest('.medium-insert-buttons').length == 0
    @$el.find('.medium-insert-active').removeClass 'medium-insert-active'
    $.each @options.addons, (addon) ->
      if $el.closest('.medium-insert-' + addon).length
        $current = $el
      if $current.closest('.medium-insert-' + addon).length
        $p = $current.closest('.medium-insert-' + addon)
        activeAddon = addon
        return
      return
    if $p.length and ($p.text().trim() == '' and !activeAddon or activeAddon == 'images')
      $p.addClass 'medium-insert-active'
      if activeAddon == 'images'
        @$el.find('.medium-insert-buttons').attr 'data-active-addon', activeAddon
      else
        @$el.find('.medium-insert-buttons').removeAttr 'data-active-addon'
      # If buttons are displayed on addon paragraph, wait 100ms for possible captions to display
      setTimeout (->
        that.positionButtons activeAddon
        that.showButtons activeAddon
        return
      ), if activeAddon then 100 else 0
    else
      @hideButtons()
  return


