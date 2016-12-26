$(function(){
  'use strict';

  $(document).on('change', '[data-filter]', function(){
    $(this).closest('form').submit();
  });

});
