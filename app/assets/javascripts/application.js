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



$(document).ready(function() {
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

    $('.trash').click(function() {
        $.post(this.href, { _method: "delete" }, null, "script");
        $(this).closest('tr').fadeOut(300);
        return false;
    });

    $('#new_link_form').validate({
        rules: {
            "link[long_url]": {
                required: true
            }
        }
    });
});