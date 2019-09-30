$(() => $('#tiles').imagesLoaded(() => $('#tiles').masonry({
    itemSelector: '.box',
    isFitWidth: true
})));


$(".tile").flip();

$('.single-item').slick({
    fade: true,
    cssEase: 'ease-in-out',
});