$( "#menu" ).menu();
function update_password(){
    $.ajax({
        url:'/admin2s/setting',
        type:'get',
        beforeSend:function(response){
            $("#rightContent").html('<div style="text-align:center;width:100px;height:100px;border:1px solid #dcdcdc;position:absolute;left:50%;margin-top:150px;background:#ebeced;line-height:100px;font-weight:bold;"><img src="/loading.gif" style="margin-top:40px;"/></div>')
        },
        success:function (response,data){
            $('#rightContent').html(response)
        },
        error:function(response){
            $('#rightContent').html('response')
        }
    })
}