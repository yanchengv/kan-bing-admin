/**
 * Created with JetBrains RubyMine.
 * User: git
 * Date: 14-2-17
 * Time: 下午9:34
 * To change this template use File | Settings | File Templates.
 */
var x, y, h, w;
var options;
//    上传图片兼容性
function getFullPath(obj) {
    if (obj) {
//ie
        if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
            obj.select();
            return document.selection.createRange().text;
        }
//firefox
        else if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
            if (obj.files) {
                return obj.files.item(0).getAsDataURL();
            }
            return obj.value;
        }
        return obj.value;
    }
}
;

//裁剪图片
function cropPhoto(obj) {
    x = obj.x;
    y = obj.y;
    w = obj.w;
    h = obj.h;
//       当点击确定按钮时, 调用jquery.form.min上传图片,options作为参数上传
    options = {
        dataType: 'json',
        data: {x: x, y: y, w: w, h: h},
        beforeSubmit: showRequest,
        success: showResponse,
        error: showError
    }
}
;
function showRequest() {
    document.getElementById('preview_photo').innerHTML = "<div style='color:#0000FF'>正在上传...</div>";
}
;
function showResponse(responseText, statusText, xhr, $form) {
//    $('#photoModal').modal('hide');
//    window.parent.$("#photoModal").dialog("close");
    hide('photoModal')
    document.getElementById('photo_upload_form').reset();
    document.getElementById('preview_photo').innerHTML = '';
    document.getElementById('myPhoto').src=responseText.url;
    console.log(responseText)
    $('#user_photo_image').val(responseText.image_path)
}
;
function showError() {
    document.getElementById('preview_photo').innerHTML = "<div style='color:#0000FF'>上传失败</div>";
}
;

function select_photo() {
    $('#input_photo').click()
}

//上传函数
function upload(file) {
//    $('#photoModal').modal('show');
//    var consoleDlg = $("#photoModal");
//    consoleDlg.dialog("option", "title", "裁剪图片").dialog("open");
    show('photoModal')
    $('#preview_photo').html('<img id="crop_photo"/>');
    var input_img = document.getElementById("input_photo");
    var fReader = new FileReader();
    fReader.readAsDataURL(input_img.files[0]);
    fReader.onloadend = function (event) {
        var input_img_name = input_img.files[0].name
        var show_img = document.getElementById("crop_photo");
        show_img.src = event.target.result;  //path
        $('#crop_photo').Jcrop({
                boxWidth: 450,
                boxHeight: 0,
                onChange: cropPhoto,
                onSelect: cropPhoto,
                aspectRatio: 2.5 / 3.5,
                setSelect: [20, 68, 250, 350],
                allowResize:true,
                allowMove:true
            }, function () {
                // Use the API to get the real image size
                var bounds = this.getBounds();
                boundx = bounds[0];
                boundy = bounds[1];
                // Store the API in the jcrop_api variable
                jcrop_api = this;

                // Move the preview into the jcrop container for css positioning
//                $preview.appendTo(jcrop_api.ui.holder);
            }
        );

    }


}

function upload_img() {
    var data = $('#photo_upload_form').serialize()
    console.log(data)
    $.ajax({
            type:'post',
            url:'/photos',
            data:data,
            success:function(data){

            }
        }
    )
//    $('#upload_image').click()
}

function show(tag){
    var light=document.getElementById(tag);
    var fade=document.getElementById('fade');
    light.style.display='block';
    fade.style.display='block';
}
function hide(tag){
    var light=document.getElementById(tag);
    var fade=document.getElementById('fade');
    light.style.display='none';
    fade.style.display='none';
}

$(document).ready(function () {
    $("#hotoModal").dialog({
        autoOpen: false,
        modal: true,    // 设置对话框为模态（modal）对话框
        resizable: true,
        width: 540,
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "fit",
            // Ensure the titlebar is always visible
            using: function( pos ) {
                console.log(pos.top)
                var topOffset = $( this ).css( pos ).offset().top;
                console.log(topOffset)
                if ( topOffset < 0 ) {
                    $( this ).css( "top", pos.top - topOffset );
                }else {
                    $( this ).css( "top", 100 );
                }
            }
        },
        buttons: {  // 为对话框添加按钮
            "确定": upload_img,
            "取消": function() {$("#photoModal").dialog("close")}
        }
    });

    // jquery.form.min插件实现图片ajax提交
    $('#photo_upload_form').submit(function () {
        $(this).ajaxSubmit(options);
        return false;
    });
    //取消上传，清除modal的内容
    $('#cancle').click(function () {
        document.getElementById("photo_upload_form").reset();
        document.getElementById("preview_photo").innerHTML = '';
    });
})
