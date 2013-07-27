// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.validate
//= require ZeroClipboard


$(document).ready(function() {

    // Popover for Gravatar on edit profile page
    $("#wtf").popover({html: true});

    // Tooltips
    $('#nav-home').tooltip();
    $('#nav-signup').tooltip();
    $('#nav-login').tooltip();
    $('#nav-logout').tooltip();
    $('#nav-dashboard').tooltip();

    $.validator.addMethod(
        "domain",
        function(value, element) {
            var test = /slnky.me/.test(value);
            return !test;
        },
        "Your short URL cannot point to this site."
    );

    $('#try-button').click(function(event, data) {
        var url = $('#try-input').val();
        if (url != '' && isValidURL(url) && !startsWithSlinky(url)) {
            if($('#try-input'))
            $.ajax({
                type:"post",
                data: { "link[long_url]": $('#try-input').val() },
                url: "/links",
                dataType: 'json',
                error: function(request, error) {
                    console.log(arguments);
                    alert("Something is messed up");
                },
                success: function(data) {
                    $('#message').html(
                        "<h3>Success! View your short link below:</h3><br />" +
                            "<a id ='slnky-link' href='/" + data.short_url +
                            "' target='_blank'><h3 id='slnky-link-text'>slnky.me/" +
                            data.short_url + "</h3></a>" +
                            "<button id='clipboard-button' data-clipboard-text='slnky.me/" + data.short_url +
                            "' class='btn btn-large btn-default'>Copy to Clipboard</button>" +
                            "&nbsp;&nbsp;<img id='checkmark' src='/assets/checkmark.png' height='30' width='30'>"
                    );
                    $('#message').fadeIn(400);
                    ZeroClipboard.setDefaults( { moviePath: '/lib/ZeroClipboard.swf' } );
                    var clip = new ZeroClipboard($('#clipboard-button'));
                    clip.on('complete', function(client, args) {
                        //alert("Link copied to clipboard:\n" + args.text);
                        $('#checkmark').fadeIn(300);
                        $('#checkmark').delay(2000).fadeOut(300);
                    });
                }
            });
        } else {
            $('#message').html(
                "<h3>Oops, something's wrong with that URL.</h3>" +
                "<small>If you think this is incorrect, please let us know.</small>"
             );
            $('#message').fadeIn(400);
        }
    });



    $(".message").hide().fadeIn(500);
    $(".message").delay(4000).fadeOut(500);
    $(".alert").hide().fadeIn(500);
    $(".alert").delay(4000).fadeOut(500);

    $('#new_user_form').validate({
        rules: {
            "user[first_name]": {
                required: true
            },
            "user[last_name]": {
                required: true
            },
            "user[password]": {
                required: true
            },
            "user[email]": {
                required: true,
                maxlength: 100
            },
            "user[password_confirmation]": {
                required: true,
                equalTo: "#user_password",
                minlength: 6
            }
        },
        messages: {
            "user[password_confirmation]": {
                equalTo: "Passwords must match.",
                minlength: "Password must be at least 6 characters."
            }
        }
    });

    $('#edit_user_form').validate({
        rules: {
            "user[first_name]": {
                required: true
            },
            "user[last_name]": {
                required: true
            },
            "user[password]": {
                required: true
            },
            "user[email]": {
                required: true,
                maxlength: 100
            },
            "user[password_confirmation]": {
                required: true,
                equalTo: "#user_password",
                minlength: 6
            }
        },
        messages: {
            "user[password_confirmation]": {
                equalTo: "Passwords must match.",
                minlength: "Password must be at least 6 characters."
            }
        }
    });

    $('.trash').click(function() {
        $.post(this.href, { _method: "delete" }, null, "script");
        $(this).closest('tr').fadeOut(300);
        return false;
    });

    $('#new_link_form').validate({
        rules: {
            "link[long_url]": {
                required: true,
                domain: true
            }
        }
    });

});

function startsWithSlinky(url) {
    var index = url.indexOf("slnky.me");
    return (index != null && index >= 0 && index <= 13);
}

function isValidURL(str) {
    var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
        '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
    if(!pattern.test(str)) {
        return false;
    } else {
        return true;
    }
}