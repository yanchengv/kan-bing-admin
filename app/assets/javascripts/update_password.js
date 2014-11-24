/**
 * Created with JetBrains RubyMine.
 * User: git
 * Date: 14-4-25
 * Time: 上午11:13
 * To change this template use File | Settings | File Templates.
 */
var old_pwd_flag=false
var new_pwd_flag=false
var new_pwd2_flag=false
//var code_flag=false
//旧密码的onblur事件
function check_old(old_pwd){
    console.log(old_pwd)
    var old_password=new RegExp(/^\s*$/g)
    if (old_password.test(old_pwd)){
        old_pwd_flag=false;
        document.getElementById('old_pwd_div').innerHTML='<div class="error-icon">旧密码不能为空</div>'
    }else{
        $.ajax({
            type:'get',
            url:'/admin2s/check_old_pwd',
            data:{old_password:old_pwd},
            success:function(data){
                if (data['success']==true){
                old_pwd_flag=true;
                document.getElementById('old_pwd_div').innerHTML='<div class="succ-icon"></div>';
                }else{
                old_pwd_flag=false;
                document.getElementById('old_pwd_div').innerHTML='<div class="error-icon">旧密码错误！</div>';
                }

            }
        })
    };
}
////验证码的onblur事件
//function check_code(code){
//    $.ajax({
//        type:'get',
//        url:'/users/check_code',
//        data:{code:code},
//        success:function(data){
//            if (data['success']==true){
//            code_flag=true;
//            document.getElementById('code_div').innerHTML='<div class="succ-icon"></div>';
//            }else{
//            code_flag=false;
//            document.getElementById('code_div').innerHTML='<div class="error-icon">验证码错误！</div>';
//            }
//
//        }
//    })
//}
//新密码的onblur事件
function check_new(new_password){
    var reg_blank=new RegExp(/^\s*$/g)
    var reg_num=new RegExp('^[0-9]*$');
    var reg_letter=new RegExp('^[a-zA-Z]*$')
    if(reg_blank.test(new_password)){
        new_pwd_flag=false
        document.getElementById('new_pwd_div').innerHTML='<div class="error-icon">不能为空！</div>'
    }
    else if(new_password.length>16 || new_password.length<4){
        new_pwd_flag=false
        document.getElementById('new_pwd_div').innerHTML='<div class="error-icon">长度应为4-16位！</div>'
    }
    else{
        new_pwd_flag=true
        document.getElementById('new_pwd_div').innerHTML='<div class="succ-icon"></div>';
        var password_confirmation = $('#pass_con').val()
        console.log(password_confirmation)
        if (password_confirmation != '') {
            check_new2(password_confirmation)
        }
    }

}
//确认密码的onkeyup事件
function set_new2(new_password){
    var reg_blank=new RegExp(/^\s*$/g)
    var reg_num=new RegExp('^[0-9]*$');
    var reg_letter=new RegExp('^[a-zA-Z]*$')
    if(reg_blank.test(new_password)){
        new_pwd_flag=false
    }
    else if(new_password.length>16 || new_password.length<4){
        new_pwd_flag=false
    }
    else{
        new_pwd_flag=true
    }
    if(new_pwd_flag==true){
        document.getElementById('pass_con').removeAttribute('disabled')
    }else{
        document.getElementById('new_pwd2_div').innerHTML=''
        document.getElementById('pass_con').setAttribute('disabled','disabled')
    }
}
//确认密码的onblur事件
function check_new2(password_confirmation){
    if (new_pwd_flag&&password_confirmation==$('#pass').val()){
        new_pwd2_flag=true
        document.getElementById('new_pwd2_div').innerHTML='<div class="succ-icon"></div>';
    }else{
        new_pwd2_flag=false
        document.getElementById('new_pwd2_div').innerHTML='<div class="error-icon">两次密码不一致！</div>'
    }
}

$(document).ready(function(){
    $(":submit[id=password_update]").click(function(check){
        if(old_pwd_flag!=true||new_pwd_flag!=true||new_pwd2_flag!=true||code_flag!=true){
            alert("表单中填写有误，不能提交表单！");
            check.preventDefault();//此处阻止提交表单
        }
});
    if (document.getElementById('pass_con')!=null) {
        document.getElementById('pass_con').setAttribute('disabled','disabled')
    }
});
//刷新验证码
//function code_refresh(){
//    $("#code_img").attr("src","/code/code_image?tmp="+new Date().getTime());
//}
//新密码的onfocus事件
function check_remind(password){
    var pass=new RegExp(/^\s*$/g)
    if (pass.test(password)){
        old_pwd_flag=false;
        document.getElementById('new_pwd2_div').innerHTML=''
        document.getElementById('new_pwd_div').innerHTML='<div class="">密码由４-16个字符组成。</div>'
    }
}