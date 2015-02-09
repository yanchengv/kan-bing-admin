$(function () {
    $('.pagination li a').click(function () {
        event.preventDefault();
        var url = '', href = $(this).context.href, arr = [], page;
        arr = href.split('//')[1].split('/');
        url = '/' + arr[1] + '/' + arr[2].split('?')[0]
        if ($(this).parent().hasClass('active') || url.indexOf('#') != -1) {

        } else {
            page = parseInt(href.split('page=')[1]);
            $.ajax({
                type: 'post',
                url: url,
                data: {
                    page: page
                },
                success: function (data) {
                    $('#div_right').html('');
                    $('#div_right').html(data);
                },
                error: function (data) {
                    console.log(data);
                }
            });
        }

    })
});