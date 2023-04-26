# reactable_page_controls should return UI for page navigation and display

    Code
      reactable_page_controls("test")
    Output
      <div class="pagination-controls">
        <button class="btn btn-default action-button pagination-button" id="test-first_page" type="button">
          <i class="fas fa-angles-left" role="presentation" aria-label="angles-left icon"></i>
          
        </button>
        <button class="btn btn-default action-button pagination-button" id="test-previous_page" type="button">
          <i class="fas fa-angle-left" role="presentation" aria-label="angle-left icon"></i>
          
        </button>
        <button class="btn btn-default action-button pagination-button" id="test-next_page" type="button">
          <i class="fas fa-angle-right" role="presentation" aria-label="angle-right icon"></i>
          
        </button>
        <button class="btn btn-default action-button pagination-button" id="test-last_page" type="button">
          <i class="fas fa-angles-right" role="presentation" aria-label="angles-right icon"></i>
          
        </button>
        <div class="pagination-text">
          <span id="test-page_text" class="shiny-text-output"></span>
        </div>
      </div>

# reactableExtrasUI should return a widget of reactableOutput

    Code
      reactableExtrasUi("test")
    Output
      <div class="pagination-controls">
        <button class="btn btn-default action-button pagination-button" id="test-page_controls-first_page" type="button">
          <i class="fas fa-angles-left" role="presentation" aria-label="angles-left icon"></i>
          
        </button>
        <button class="btn btn-default action-button pagination-button" id="test-page_controls-previous_page" type="button">
          <i class="fas fa-angle-left" role="presentation" aria-label="angle-left icon"></i>
          
        </button>
        <button class="btn btn-default action-button pagination-button" id="test-page_controls-next_page" type="button">
          <i class="fas fa-angle-right" role="presentation" aria-label="angle-right icon"></i>
          
        </button>
        <button class="btn btn-default action-button pagination-button" id="test-page_controls-last_page" type="button">
          <i class="fas fa-angles-right" role="presentation" aria-label="angles-right icon"></i>
          
        </button>
        <div class="pagination-text">
          <span id="test-page_controls-page_text" class="shiny-text-output"></span>
        </div>
      </div>
      <div class="reactable html-widget html-widget-output shiny-report-size html-fill-item-overflow-hidden html-fill-item" data-reactable-output="test-reactable" id="test-reactable" style="width:auto;height:auto;"></div>

