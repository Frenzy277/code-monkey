$(document).ready(function() {

  $("a.list-group-item").hover(
    function(){
      $(this).toggleClass("active");
    }
  );

});