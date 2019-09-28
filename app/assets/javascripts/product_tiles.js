$(() => $('#tiles').imagesLoaded(() => $('#tiles').masonry({
    itemSelector: '.box',
    isFitWidth: true
})));