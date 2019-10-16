ImageCropper = function(elementId) {
    let self = this;

    let $image = $(elementId);

    let updateCoords = function(event) {
        $('#coords-x').val(Math.round(event.detail.x));
        $('#coords-y').val(Math.round(event.detail.y));
        $('#coords-w').val(Math.round(event.detail.width));
        $('#coords-h').val(Math.round(event.detail.height));
        $('#coords-rotate').val(Math.round(event.detail.rotate));



        //let canvas = cropper.getCroppedCanvas().toDataURL('image/jpeg')
        //console.log(canvas);
        //blob?


        let handle = document.getElementById("cropImage").src;
        handle = handle.replace('https://cdn.filestackcontent.com/resize=w:500,h:500,fit:max/','');

        $('#handleInput').val(handle);

        let imgLink = 'https://cdn.filestackcontent.com/resize=w:500,h:500,fit:max/rotate=exif:false/rotate=deg:'
            + Math.round(event.detail.rotate) + '/crop=dim:[' + Math.round(event.detail.x) + ','
            + Math.round(event.detail.y) + ',' + Math.round(event.detail.width) + ','
            + Math.round(event.detail.height) + ']/' + handle;

        $('#urlInput').val(imgLink);
    };

    $image.cropper({
        viewMode: 1,
        movable: false, //true results in transformation errors
        scaleable: false,
        zoomable: false,
        zoomOnTouch: false,
        zoomOnWheel: false,
        crop: updateCoords,
        preview: '.preview'
    });

    let clickCropButtonsListener = function() {
        $('.crop-buttons').on('click', '[data-method]', function() {
            $image.cropper('rotate', $(this).data('option'));
        });
    };

    self.initListeners = function() {
        clickCropButtonsListener();
    };
};

$(document).on('turbolinks:load', function() {
    if ( $('#cropImage').length > 0 ) {
        let cropper = new ImageCropper('#cropImage'); //create cropper instance
        cropper.initListeners();
    }
    $('select').niceSelect(); //drop down menu for categories 3rd party: http://hernansartorio.com/jquery-nice-select/
});