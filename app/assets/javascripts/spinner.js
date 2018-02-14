$( document ).ready(function() {

  // hide spinner
  $(".sk-circle").hide();

  // show spinner on AJAX start
  $(document).ajaxStart(function(){
    $(".sk-circle").show();
  });

  // hide spinner on AJAX stop
  $(document).ajaxStop(function(){
    $(".sk-circle").hide();
  });

});