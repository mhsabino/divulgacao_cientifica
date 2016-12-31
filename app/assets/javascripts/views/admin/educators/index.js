$(function(){
  'use strict';

  $(document).on('change', '[data-filter]', function(){
    $(this).closest('form').submit();
  });

  $(document).on('click', '[data-input-search]', function(){
    $(this).closest('form').submit();
  });


});
