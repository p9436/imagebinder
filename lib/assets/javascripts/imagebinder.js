
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require fancybox
//= require jquery.Jcrop.min


function asset_remove(target, default_image, callback) {
  //console.log($('#'+target+'_attributes_id').val());

  $('#'+target+'_attributes_id').val('');
  $('.'+target+'_image').html('<img src="'+default_image+'"/>');
  $('.asset.'+target+' .remove').hide();
  if (callback && callback.length > 0) eval(callback);
}

function update_crop(coords) {
  $('#crop_x').val(Math.floor(coords.x * original_image_ratio));
  $('#crop_y').val(Math.floor(coords.y * original_image_ratio));
  $('#crop_w').val(Math.floor(coords.w * original_image_ratio));
  $('#crop_h').val(Math.floor(coords.h * original_image_ratio));
}

function clear_crop(){
  $('#crop_x').val('');
  $('#crop_y').val('');
  $('#crop_w').val('');
  $('#crop_h').val('');
}

function asset_upload_init($box) {
  var jqXHR = null;

  $box.find('form').fileupload({
    dataType: 'text',
    add: function (e, data) {
      jqXHR = data.submit()
        .success(function (result, textStatus, jqXHR){
          result = $.parseJSON(result);
          // $.fancybox({ type: 'ajax', href: result.url });

          $.fancybox(result, {
            modal:true,
            type: 'ajax',
            href: result.url,
            // 'onComplete': function(){
            'afterShow': function(){

              var jcropAttrs = { onChange: update_crop,
                onSelect: update_crop,
                onRelease: clear_crop,
                setSelect: [0, 0, 500, 500]
              };
              if (result.crop_ratio != false) {
                jcropAttrs['aspectRatio'] = ( result.crop_ratio || 1)
              }
              //console.log(jcropAttrs);
              //console.log(result);
              $('.cropimage').Jcrop(jcropAttrs)
            }
          })
        })
        .error(function (jqXHR, textStatus, errorThrown) {  })
        .complete(function (result, textStatus, jqXHR) { $('.upload_progress').hide() });
    },

    start: function (e) {
      $('.upload_progress').show();
      $('.upload-cancel-button').show();
    },
    progress: function (e, data) {
      $.each(data.files, function (index, file) {
        var rate = (data.loaded / data.total)
        $('.upload_progress .info').text(Math.round(rate*100) + "% of " + (data.total/1000) + " KBytes ")
        $('.upload_progress .bar .p').css('width', rate*100 + '%');
      });
    },
    done: function (e, data) {
      $.each(data.files, function (index, file) {
        $('.upload_progress').hide();
      });
    },
    fail: function (e, data) {
      $.each(data.files, function (index, file) {
        $('.upload_progress .info').text("There was some error uploading the picture.")
      });
    }
  });
  $box.find('.upload-cancel-button').click(function (e) {
    if(jqXHR) jqXHR.abort();
    $.fancybox.close();
  });

};
