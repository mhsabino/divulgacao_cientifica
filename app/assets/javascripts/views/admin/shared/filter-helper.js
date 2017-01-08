$(function(){
  'use strict';

  $(document).on('change', '[data-filter]', function() {
    _submit_form($(this));
    // $(this).closest('form').submit();
  });

  $(document).on('click', '[data-input-search]', function() {
    _submit_form($(this));
    // $(this).closest('form').submit();
  });


  // private functions

  function _submit_form(form_element) {
    form_element.closest('form').submit();
  }

});
