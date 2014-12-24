$("#block_console").dialog({    //初始化对话框
    autoOpen: false,
    modal: false,    // 设置对话框为模态（modal）对话框
    resizable: true,
    width: 540,
    position: {
        my: "center",
        at: "center",
        of: window,
        collision: "fit",
        // Ensure the titlebar is always visible
        using: function (pos) {
            var topOffset = $(this).css(pos).offset().top;
            if (topOffset < 0) {
                $(this).css("top", pos.top - topOffset);
            } else {
                $(this).css("top", 100);
            }
        }
    },
    buttons: {  // 为对话框添加按钮
        "保存": save_block,
        "取消": function () {
            $("#block_console").dialog("close")
        }
    }
});
function check_model(str){
    var block_console = $("#block_console");
    var dialogButtonPanel = block_console.siblings(".ui-dialog-buttonpane");
    dialogButtonPanel.find("button:contains('保存')").show();
    block_console.dialog("option", "width", "540");
    block_console.dialog("option", "title", "新建区块").dialog("open");
    $('#block_name').val('');
    $('#model_name').val(str);
}
function save_block() {   //保存视频信息
    var type = $('#model_name').val();
    var name = $('#block_name').val();
    $.ajax({
        type: 'get',
        url: 'page_blocks/get_template',
        data: {type: type,name:name},
        success: function (data, response) {
            window.parent.$("#block_console").dialog("close");
            $("#rightContent").html(data);
        }
    })
}