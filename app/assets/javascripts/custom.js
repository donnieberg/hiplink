$(document).ready(function(){
  $('#Grid').mixitup({
    layoutMode: 'list'
  });

  $('.dropdown-toggle').dropdown();

  $(".folder_header").click(function () {
    var $folder_content = $(this).parent('.folder_container').children('.folder_content');
    if ($folder_content.is(":hidden")) {
      $folder_content.slideDown("slow");
    } else {
      $folder_content.slideUp("slow");
    }
  });
});









