/**
 * Created by git on 14-12-16.
 */



function create(){
    var domainName= $("#domainName").val();
    var domainStyle = $("#domainStyle").val();
    if  (!domainName.match(/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?$/i)){
        alert("请输入正确的域名")
    }else{
        $.ajax({
            url:'/domain/create',
            data:{name:domainName, style: domainStyle},
            type:'post',
            success:function(data){
                if (data["flag"]=='false'){
                    alert("您输入的域名已经被占用！")
                }
                $("#domainName").val("")
                $("#domain_consoleDlg").dialog("close")
                jQuery("#list_domain").jqGrid('setGridParam', {url: "/domain/domain_list" }).trigger("reloadGrid")

            }
        })
    }

};
//域名修改
function updateDomain(){
    var id = jQuery("#list_domain").jqGrid('getGridParam', 'selrow');
    var domainName= $("#domainUpdateName").val();
    var domainUpdateStyle = $("#domainUpdateStyle").val();
    if  (domainName==""){
        alert("不能为空")
    }else{
        $.ajax({
            url:'/domain/update',
            data:{name:domainName,id:id,style: domainUpdateStyle},
            type:'post',
            success:function(data){
                if (data["flag"]=='false'){
                    alert("您输入的域名已经被占用！")
                }
                $("#domainUpdateName").val("")
                $("#domain_update_consoleDlg").dialog("close")
                jQuery("#list_domain").jqGrid('setGridParam', {url: "/domain/domain_list" }).trigger("reloadGrid")
            }
        })
    }
}


//logo取消上传
function cancleLogo(){
    $("#logo_consoleDlg").dialog("close")
    $("#uploadLogoStaus").html("")
}
//  logo使用ajax上传
var  logoUrl='';
$(function () {
    $('#logoUpload').fileupload({
        url:'/domain/upload_logo',
        dataType: 'json',
        success: function (response, textStatus, jqXHR) {
            var flag=response['flag']
            if  (flag==true){
                $("#uploadLogoStaus").html("上传成功！")
                logoUrl=response["url"]
            } else{
                logoUrl=''
            }

        }
    });
});

//保存logo图片
function uploadLogo(){
    $.ajax({
        type:'post',
        url:'/domain/save_logo',
        data:{logoUrl:logoUrl},
        success:function(data){
            logoUrl=''
            $("#uploadLogoStaus").html("")

        }
    });
    $("#logo_consoleDlg").dialog("close")
    jQuery("#list_domain").jqGrid('setGridParam', {url: "/domain/domain_list" }).trigger("reloadGrid")
};



//页脚修改
function updateFooter(){
    var footer=$("#footer").val();
    $.ajax({
        url:'/domain/update_footer',
        data:{footer:footer},
        type:'post',
        success:function(data){

            $("#footer").val("")
        }

    });
    $("#footer_consoleDlg").dialog("close")
    jQuery("#list_domain").jqGrid('setGridParam', {url: "/domain/domain_list" }).trigger("reloadGrid")
}



$(function(){
//添加域名彈出框
    $("#domain_consoleDlg").dialog({    //初始化对话框
        autoOpen: false,
        modal: true,    // 设置对话框为模态（modal）对话框
        resizable: true,
        width: 250,
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "fit",
            // Ensure the titlebar is always visible
            using: function( pos ) {
                var topOffset = $( this ).css( pos ).offset().top;
                if ( topOffset < 0 ) {
                    $( this ).css( "top", pos.top - topOffset );
                }else {
                    $( this ).css( "top", 100 );
                }
            }
        },
        buttons: {  // 为对话框添加按钮
            "确定": create,
            "取消": function() {$("#domain_consoleDlg").dialog("close")}
        }
    });
//修改域名彈出框
    $("#domain_update_consoleDlg").dialog({    //初始化对话框
        autoOpen: false,
        modal: true,    // 设置对话框为模态（modal）对话框
        resizable: true,
        width: 250,
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
            "确定": updateDomain,
            "取消": function() {$("#domain_update_consoleDlg").dialog("close")}
        }
    });

//添加logo彈出框
    $("#logo_consoleDlg").dialog({    //初始化对话框
        autoOpen: false,
        modal: true,    // 设置对话框为模态（modal）对话框
        resizable: true,
        width: 400,
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "fit",
            // Ensure the titlebar is always visible
            using: function( pos ) {
                var topOffset = $( this ).css( pos ).offset().top;
                if ( topOffset < 0 ) {
                    $( this ).css( "top", pos.top - topOffset );
                }else {
                    $( this ).css( "top", 100 );
                }
            }
        },
        buttons: {  // 为对话框添加按钮
            "确定": uploadLogo,
            "取消": cancleLogo
        }
    });

//添加页脚彈出框
    $("#footer_consoleDlg").dialog({    //初始化对话框
        autoOpen: false,
        modal: true,    // 设置对话框为模态（modal）对话框
        resizable: true,
        width: 400,
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "fit",
            // Ensure the titlebar is always visible
            using: function( pos ) {
                var topOffset = $( this ).css( pos ).offset().top;
                if ( topOffset < 0 ) {
                    $( this ).css( "top", pos.top - topOffset );
                }else {
                    $( this ).css( "top", 100 );
                }
            }
        },
        buttons: {  // 为对话框添加按钮
            "确定": updateFooter,
            "取消": function() {$("#footer_consoleDlg").dialog("close")}
        }
    });

    $("#logo_img2").click(function () {
        $("#logoUpload").click();
    });

//  donmain table list
jQuery("#list_domain").jqGrid({
    url: '/domain/domain_list',
    datatype: "json",
    mtype: 'GET',
    colNames: ['ID', '域名','logo','页脚',  '医院', '科室', '风格'],
    colModel: [
        {name: 'id', index: 'id', align: "center", hidden: true},
        {name: 'name', index: 'name', align: "center"},
        {name: 'logo_url', index: 'logo_url', align: "center"},
        {name: 'footer', index: 'footer', align: "center"},
        {name: 'hospital_id', index: 'hospital_id', align: "center", hidden: true},
        {name: 'department_id', index: 'department_id', align: "center", hidden: true},
        {name: 'style', index: 'style', editable: true, edittype: "select", editoptions: {value: "默认:default;风格1:style1"}, align: "center"}
    ],
    rowList: [10, 20, 30],
    sortname: 'id',
    viewrecords: true,
    sortorder: "desc",
    autowidth: true,
    rownumbers: true,
    page: 1,
    jsonReader: {
        root: "data",
        total: "totalpages",
        page: "currpage",
        records: "totalrecords",
        repeatitems: false
    },
    prmNames: {
        page: "page", // 表示请求页码的参数名称
        rows: "rows", // 表示请求行数的参数名称
        id: "id", // 表示当在编辑数据模块中发送数据时，使用的id的名称
        //   npage: null,
        totalrows: "totalrows", // 表示需从Server得到总共多少行数据的参数名称，参见jqGrid选项中的rowTotal
        editoper: "edit", // 当在edit模式中提交数据时，操作的名称
        addoper: "add", // 当在add模式中提交数据时，操作的名称
        deloper: "del" // 当在delete模式中提交数据时，操作的名称
    },
    editurl: '/domain/oper_action',
    closeAfterAdd: true,
    pager: jQuery('#domain_block'),
    multiselect: false,
    rowNum: 20,
    altclass: 'altRowsColour',
    height: 'auto',
    caption: "域名管理"
}).navGrid('#domain_block', {
        cloneToTop: true, add: false, edit: false,
        deltext: "删除", deltitle: "删除", view: false, search: false, refreshtext: "刷新", refreshtitle: "刷新"},
    {
        closeAfterEdit: true
    },//edit
    {
        closeAfterAdd: true
    }//a
).navButtonAdd('#domain_block', { title: '编辑', buttonicon: "ui-icon-pencil", caption: '编辑', onClickButton: function () {
        var domain_update_consoleDlg = $("#domain_update_consoleDlg");
        domain_update_consoleDlg.dialog("option", "title", "修改域名").dialog("open");
        var id = jQuery("#list_domain").jqGrid('getGridParam', 'selrow');
        var name = $('#list_domain').jqGrid('getRowData', id).name
        var style = $('#list_domain').jqGrid('getRowData', id).style
        $("#domainUpdateName").val(name);
        $("#domainUpdateStyle").val(style);
    }, position: "first"}
).navButtonAdd('#domain_block', { title: '添加', caption: '添加', buttonicon: "ui-icon-plus", onClickButton: function () {
        var domain_consoleDlg = $("#domain_consoleDlg");
        domain_consoleDlg.dialog("option", "title", "添加域名").dialog("open");

    }, position: "first"}
).navButtonAdd('#domain_block', { title: '上传logo', caption: '上传logo', buttonicon: "ui-icon-plus", onClickButton: function () {
        var logo_consoleDlg = $("#logo_consoleDlg");
        logo_consoleDlg.dialog("option", "title", "logo上传(图片尺寸:245*45)").dialog("open");

    }, position: "last"}
).navButtonAdd('#domain_block', { title: '修改页脚', caption: '修改页脚', buttonicon: "ui-icon-plus", onClickButton: function () {
        var footer_consoleDlg = $("#footer_consoleDlg");
        footer_consoleDlg.dialog("option", "title", "修改页脚").dialog("open");

    }, position: "last"})

//向弹出框关闭按钮添加一个图标
    $(".ui-dialog-titlebar .ui-dialog-titlebar-close").html("<span class='glyphicon glyphicon-remove'></span>");
})



