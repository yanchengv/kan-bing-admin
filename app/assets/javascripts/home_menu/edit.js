/**
 * Created by git on 14-12-30.
 */

var link_url_flag = true;
var redirect_url_flag = true;
function check_link_url(value) {
    if (value != '') {
        $.ajax({
            type: 'get',
            url: '/home_menu/check_url?link_url='+value+'&home_menu_id=<%= @home_menu.id%>',
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

};


//修改后提交保存
if (link_url_flag&&redirect_url_flag) {
    $('#home_menu_form_eidt').submit(function(){
        var valuesToSubmit=$(this).serialize();
        $.ajax({
            type:'post',
            url:'/home_menu/save',
            data:valuesToSubmit,
            success:function(data){
                $("#rightContent").html(data);
                $("#showHomePage").html("<h1>修改成功</h1>")
            },
            error:function(){
                alert("保存失败！")
            }

        });
        return false; // prevents normal behaviour    阻止普通提交
    });
}

