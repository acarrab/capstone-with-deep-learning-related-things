


var picturePicker = function(){
  // if click on picture
  $('.image-container').click(function(e){
    let imageContainer = e.currentTarget;
    if(imageContainer.attributes.value){
      var val = imageContainer.attributes.value.value;
    }

    // get parent div with class = picture-picker-row .id
    let parent = $('#picture-picker-' + val);

    // return if correct picture already picked
    if(parent.find('.correct').length >= 1) return;

    // if picture container class = generated add class incorrect
    if($(imageContainer).hasClass("generated")){
      console.log("incorrect");
      $(imageContainer).addClass('incorrect');
      parent.find('.original').addClass('correct');
    }
    // add class correct to child div with class = original
    else if ($(imageContainer).hasClass('original')){
      console.log('correct');
      $(imageContainer).addClass('correct');
    }

  });
}


$(document).on('turbolinks:load', picturePicker);
