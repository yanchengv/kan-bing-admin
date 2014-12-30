/**
 * Created by git on 14-12-30.
 */

var link_url_flag = true;
var redirect_url_flag = true;
function check_link_url(value) {
    if (value != '') {
        $.ajax({
            type: 'get',
            url: 'home_menu/check_url?link_url='+value+'&home_menu_id=<%= @home_menu.id%>',
            success: function (data) {
                if (data['success']) {
                    $("#link_url_error").html('')
                    link_url_flag = true
                } else {
                    $("#link_url_error").html(' 该url已存在.')
                    link_url_flag = false
                }
            }
        });
    } else {
        $("#link_url_error").html('')
        link_url_flag = true
    }
}
function check_redirect_url(value){
    if (value != '') {
        var str = value.match(/http:\/\/.+/);
        if (str == null) {
            $('#redirect_error').html(' 无效的url路径.')
            redirect_url_flag = false
        } else {
            $('#redirect_error').html('')
            redirect_url_flag = true
        }
    } else {
        $('#redirect_error').html('')
        redirect_url_flag = true
    }

}
var options={
    success:function(data){
        $.ajax({
            type:'get',
            url:'home_menu/show',
            success:function(data){
                $("#rightContent").html(data)
            }
        });
    },
    error:function(){
        alert("error")
        $.ajax({
            type:'get',
            url:'home_menu/show',
            success:function(data){
                $("#rightContent").html(data)
            }
        });
    }
}
$('#home_menu_form').submit(function () {
    if (link_url_flag&&redirect_url_flag) {
        $(this).ajaxSubmit(options);
    }
    return false;
});