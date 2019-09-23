$(document).on('turbolinks:load', function() {

    $( "#loading-spinner" ).hide(); //hide spinners until submit

    $( "#failure-spinner" ).hide();
    $( "#success-spinner" ).hide();
    $( "#submit-button" ).hide();

    $('#image-id').val($('#cropImage').data("first-image-id")); //set id to preset img before selection has been made


    let images = document.getElementById("divId")
        .getElementsByTagName("img");

    for (let i = 0; i < images.length; i++) //Img gallery
    {
        images[i].onmouseover = function ()
        {
            this.style.cursor = 'hand';
            this.style.borderColor = '#39f';
        };
        images[i].onmouseout = function ()
        {
            this.style.cursor = 'pointer';
            this.style.borderColor = '#b3b3b3';
        }
    }

    //------- Before Ajax success/failure ---------------

    $('#tagform').on('ajax:beforeSend', function(e){

        $( '#submit-button' ).hide(); // Hide submit button
        $( '#loading-spinner' ).fadeIn(); // show loading spinner during submission delay

    });
});

function changeImageOnClick(event)
{
    let targetElement = event.target;

    if (targetElement.tagName === "IMG") {

        console.log($(targetElement).data("image-id"));
        $('#image-id').val($(targetElement).data("image-id"));
        console.log($('#image-id'));

        $("#cropImage").cropper("destroy"); //reset the crop image before replacing
        document.getElementById("cropImage").src = targetElement.getAttribute("src");
        $("#cropImage").cropper = new ImageCropper('#cropImage');

    }
}

function addSubmitButtonOnSelect()
{
    $( "#category-caption" ).hide();
    $( "#submit-button" ).fadeIn();
}

function disableButtonOnClick()
{
    setTimeout(function (){
        $('#form-submit').attr("disabled", true);
    },1);
}