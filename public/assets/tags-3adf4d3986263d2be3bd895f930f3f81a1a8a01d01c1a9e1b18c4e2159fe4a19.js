[].forEach.call(document.getElementsByClassName('tags-input'), function (el) {
    let hiddenInput = document.createElement('input'),
        mainInput = document.createElement('input'),
        tags = [];
    
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', el.getAttribute('data-name'));

    mainInput.setAttribute('type', 'text');
    mainInput.classList.add('main-input');


    el.appendChild(mainInput);
    el.appendChild(hiddenInput);

    function addTag (text) {
        let tag = {
            text: text,
            element: document.createElement('span'),
        };

        tag.element.classList.add('tag');
        tag.element.textContent = tag.text;

        let closeBtn = document.createElement('span');
        closeBtn.classList.add('close');
        closeBtn.addEventListener('click', function () {
            removeTag(tags.indexOf(tag));
        });
        tag.element.appendChild(closeBtn);

        tags.push(tag);

        el.insertBefore(tag.element, mainInput);

        refreshTags();
    }

    function removeTag (index) {
        let tag = tags[index];
        tags.splice(index, 1);
        el.removeChild(tag.element);
        refreshTags();
    }

    function refreshTags () {
        let tagsList = [];
        tags.forEach(function (t) {
            tagsList.push(t.text);
        });
        hiddenInput.value = tagsList.join(',');
    }

    function filterTag (tag) {
        return tag.replace(/[^\w -]/g, '').trim().replace(/\W+/g, '-');
    }

    //--------- For radio btns and tag creation --------

    var tagType = 'Null';

    window.selectBrandOnClick = function(event) {
        tagType = 'Brand';
    };

    window.selectNameOnClick = function(event) {
        tagType = 'Name';
    };

    window.selectSerialOnClick = function(event) {
        tagType = 'Serial Number';
    };

    window.selectModelOnClick = function(event) {
        tagType = 'Model Number';
    };

    window.selectSizeOnClick = function(event) {
        tagType = 'Size';
    };

    window.selectOtherOnClick = function(event) {
        tagType = 'Other';
    };

    window.addTagOnClick = function(event) {
        if (tagType !== 'Null') {
            addTag(tagType);
            //$("#cropImage").cropper("reset"); //after click
        }
    };

    window.resetOnMouseUp = function(event) {
        $( "#submit-button" ).hide();
        $( "#load-spinner" ).fadeIn();

        $('.checkmark').toggle();
        setTimeout(function (){

            $("#cropImage").cropper("reset"); //after click

        }, 500); //500 millisecond delay so that the form submits before coords reset
        setTimeout(function (){

            $( "#load-spinner" ).hide();
            $( "#submit-button" ).fadeIn();

        }, 1000);
    }
});
