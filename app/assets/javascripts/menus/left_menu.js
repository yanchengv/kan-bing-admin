/**
 * Created by git on 14-12-30.
 */


var curMenu = null, zTree_Menu = null;
function leftMeunsOnClick(event, treeId, treeNode) {
    if (treeNode.uri!=''){
        $.ajax({
//                    url:treeNode.uri+'?hos_id='+treeNode.hospital_id+'&dep_id='+treeNode.department_id+'&menu_id='+treeNode.id,
            url:treeNode.uri,
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

};
var setting = {
    view: {
        showLine: true,
        showIcon: false,
        selectedMulti: false,
        dblClickExpand: false


    },
    data: {
        simpleData: {
            enable: true
        }
    },
    callback: {
        onClick: leftMeunsOnClick,
        beforeClick: this.beforeClick
    }

};
function beforeClick(treeId, node) {
    if (node.isParent) {
        if (node.level === 0) {
            var pNode = curMenu;
            while (pNode && pNode.level !==0) {
                pNode = pNode.getParentNode();
            }
            if (pNode !== node) {
                var a = $("#" + pNode.tId + "_a");
                a.removeClass("cur");
                zTree_Menu.expandNode(pNode, false);
            }
            a = $("#" + node.tId + "_a");
            a.addClass("cur");

            var isOpen = false;
            for (var i=0,l=node.children.length; i<l; i++) {
                if(node.children[i].open) {
                    isOpen = true;
                    break;
                }
            }
            if (isOpen) {
                zTree_Menu.expandNode(node, true);
                curMenu = node;
            } else {
                zTree_Menu.expandNode(node.children[0].isParent?node.children[0]:node, true);
                curMenu = node.children[0];
            }
        } else {
            zTree_Menu.expandNode(node);
        }
    }
    return !node.isParent;
}


$(document).ready(function(){
    $.fn.zTree.init($("#leftMenus"), setting, zNodes);
    zTree_Menu = $.fn.zTree.getZTreeObj("leftMenus");
//                  curMenu = zTree_Menu.getNodes()[0].children[0].children[0];
    if (zTree_Menu.getNodes() != undefined) {
    if (zTree_Menu.getNodes()[0].children != undefined) {
    curMenu = zTree_Menu.getNodes()[0].children[0];
    }
    else {
    curMenu = zTree_Menu.getNodes()[0]
    }

    zTree_Menu.selectNode(curMenu);
    var a = $("#" + zTree_Menu.getNodes()[0].tId + "_a");
    a.addClass("cur");
    }
    });


window.onload = function(){
    var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;

    document.getElementById("homeLeftMenus").style.height = (h-57)+"px";
    };
//        初始化富文本
KindEditor.ready(function(K) {
    });
