$(document).ready(function () {
    var selectPhotoWho = "all";
    var selectPhotoNextPage = {
        "all": 0,
        "me": 0
    };
    var selectPhotoPaginationDirection = "next";
    var selectPhotoPaginate = false;
    var lead = false;
    var split = function (val) {
        return val.split(/,\s*/);
    };
    var extractLast = function (term) {
        return split(term).pop();
    };
    var ajaxFail = function (jqXHR, textStatus, errorThrown) {
        if (stringEqual(textStatus, "parseerror")) {
            alert("Received an invalid response from server. Please try again after some time.");
        } else {
            alert("Network error");
        };
        return false;
    };
    var getUrlParameter = function (name) {
        return decodeURIComponent(((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)')).exec(location.search) || [,""])[1].replace(/\+/g, '%20')) || null;
    };
    var tagsAutocomplete = function (tagsInput) {
        tagsInput.bind("keydown", function (event) {
            return event.keyCode === $.ui.keyCode["TAB"] && $(this).data("autocomplete").menu.active ? event.preventDefault() : null;
        }).autocomplete({
            "min-length": 2,
            "source": function (request, response) {
                $.ajax({
                    "url": "/ajax/tags/?d1m=" + getUrlParameter("d1m"),
                    "data": {
                        "term": extractLast(request.term)
                    },
                    "data-type": "json",
                    "success": response
                });
                return false;
            },
            "search": function () {
                var term = extractLast(this.value);
                return term.length < 2 ? false : true;
            },
            "focus": function () {
                return false;
            },
            "select": function (event, ui) {
                var terms = split(this.value);
                terms.pop();
                terms.push(ui.item.value);
                terms.push("");
                this.value = terms.join(", ");
                return false;
            }
        });
        return false;
    };
    var changeCategory = function (formPrefix) {
        var catId = parseInt($(formPrefix + " .cat").val());
        var ele = null;
        if (catId === 0) {
            $(formPrefix + " .subcat").empty();
            return $(formPrefix + " .subcat").append($("<option selected=\'selected\' value=\'0\'>Select</option>"));
        } else {
            for (var ct = null, _js_idx43 = 0; _js_idx43 < categoryTree.length; _js_idx43 += 1) {
                ct = categoryTree[_js_idx43];
                if (catId === ct[0].id) {
                    $(formPrefix + " .subcat").empty();
                    if (ct[1]) {
                        for (var subcat = null, _js_arrvar45 = ct[1], _js_idx44 = 0; _js_idx44 < _js_arrvar45.length; _js_idx44 += 1) {
                            subcat = _js_arrvar45[_js_idx44];
                            ele = $("<option></option>").val("" + subcat.id).text(subcat.name);
                            $(formPrefix + " .subcat").append(ele);
                        };
                    };
                };
            };
        };
    };
    var submitArticleAjax = function () {
        return $("#article form").attr("action", "/ajax" + $("#article form").attr("action"));
    };
    var articleSubmit = function () {
        event.preventDefault();
        CKEDITOR.instances.body.updateElement();
        $("#article form").ajaxSubmit({
            "data-type": "json",
            "cache": false,
            "async": false,
            "success": function (data, textStatus, jqXHR) {
                return articleSubmitDone(data, textStatus, jqXHR);
            },
            "error": function (jqXHR, textStatus, errorThrown) {
                return ajaxFail(jqXHR, textStatus, errorThrown);
            }
        });
        return false;
    };
    var articleSubmitDone = function (data, textStatus, jqXHR) {
        if (data.status === "success") {
            window.location = data.data;
        } else {
            articleFail(data);
        };
        return false;
    };
    var articleFail = function (data) {
        if (null !== data.errors.nonGolbinImages) {
            $("#body").parent().append($("<p class=\'error\'>Body contains images not hosted on Golbin. Please upload your images to Golbin first, and then use them inside the body</p>"));
        };
        alert("There are errors in the submitted article. Please correct them and submit again.");
        return false;
    };
    var createPhotoPane = function () {
        $("#bd").append($("<div id=\'photo-pane\'><p><a class=\'close\' href=\'\'>Close</a></p><ul></ul></div>"));
        return $("#photo-pane a.close").click(function () {
            return closePhotoPane();
        });
    };
    var photoFail = function (data) {
        selectPhotoPaginate = false;
        return false;
    };
    var closePhotoPane = function () {
        event.preventDefault();
        $("#photo-pane").remove();
        return false;
    };
    var nonleadPhotoUrl = function () {
        event.preventDefault();
        return alert("Please copy this URL and use it for inline images in the article body below: " + $($(event.target)).attr("src").replace("_" + imageSizes[0] + ".", "_" + imageSizes[1] + "."));
    };
    var unselectLeadPhoto = function () {
        event.preventDefault();
        $("#lead-photo").val("");
        $("#lead-photo").siblings("span").children("img").remove();
        return $("#unselect-lead-photo").remove();
    };
    var selectLeadPhotoInit = function () {
        lead = true;
        return selectPhotoInit();
    };
    var selectNonleadPhotoInit = function () {
        lead = false;
        return selectPhotoInit();
    };
    var selectPhotoInit = function () {
        createPhotoPane();
        $("#photo-pane").append($("<div class=\'pagination\'><a href=\'\' class=\'prev\'>Previous</a><a href=\'\' class=\'next\'>Next</a></div>"));
        $("#photo-pane p").prepend($("<div class=\'search\'></div>"));
        selectPhotoAddAllMyTabs();
        selectSearchMarkup();
        selectPhotoCall("all", 0);
        $("#photo-pane .pagination a.prev").click(function () {
            return selectPhotoPaginationPrev();
        });
        return $("#photo-pane .pagination a.next").click(function () {
            return selectPhotoPaginationNext();
        });
    };
    var selectPhotoAddAllMyTabs = function () {
        $("#photo-pane p").prepend($("<span>Photos<a class=\'all-photos\' href=\'\'> All </a><a class=\'my-photos\' href=\'\'> My </a></span>"));
        $("#photo-pane a.all-photos").click(function () {
            return selectPhotoCall("all", 0);
        });
        return $("#photo-pane a.my-photos").click(function () {
            return selectPhotoCall("me", 0);
        });
    };
    var selectSearchMarkup = function () {
        var cat = $("<select name=\'cat\' class=\'td-input cat\'><option selected=\'selected\' value=\'0\'>Select</option></select>");
        var subcat = $("<select name=\'subcat\' class=\'td-input subcat\'><option selected=\'selected\' value=\'0\'>Select</option></select>");
        var tags = $("<input class=\'td-input tags\' type=\'text\'>");
        var search = $("<a href=\'\' class=\'search-btn\'>Search</a>");
        $("#photo-pane .search").append(cat).append(subcat).append(tags).append(search);
        var cat44 = null;
        var ele = null;
        for (var ct = null, _js_idx45 = 0; _js_idx45 < categoryTree.length; _js_idx45 += 1) {
            ct = categoryTree[_js_idx45];
            cat44 = ct[0];
            ele = $("<option></option>").val("" + cat44.id).text(cat44.name);
            $("#photo-pane .search .cat").append(ele);
        };
        $("#photo-pane .search .cat").change(function () {
            return changeCategory("#photo-pane .search");
        });
        tagsAutocomplete($("#photo-pane .search .tags"));
        return $("#photo-pane .search a.search-btn").click(function () {
            return selectPhotoCall(selectPhotoWho, selectPhotoNextPage[selectPhotoWho]);
        });
    };
    var selectPhotoCall = function (who, page) {
        if (page < 0) {
            return;
        };
        event.preventDefault();
        selectPhotoWho = who;
        $.ajax({
            "url": "/ajax/photos/" + who + "/" + page + "/?cat=" + $("#photo-pane .search .cat").val() + "&subcat=" + $("#photo-pane .search .subcat").val() + "&tags=" + $("#photo-pane .search .tags").val() + "&d1m=" + getUrlParameter("d1m"),
            "cache": false,
            "data-type": "json",
            "async": false
        }).done(function (data) {
            return selectPhotoDone(data);
        }).fail(function (data) {
            return photoFail(data);
        });
        return false;
    };
    var selectPhotoDone = function (data) {
        if (data.status === "success") {
            if (selectPhotoPaginate) {
                if (selectPhotoPaginationDirection === "prev") {
                    selectPhotoNextPage[selectPhotoWho] -= 1;
                } else {
                    selectPhotoNextPage[selectPhotoWho] += 1;
                };
                selectPhotoPaginate = false;
            };
            $("#photo-pane ul").empty();
            for (var d = null, _js_idx46 = 0; _js_idx46 < data.data.length; _js_idx46 += 1) {
                d = data.data[_js_idx46];
                var id = $("<span></span>").html(d[0]);
                var img = $(d[1]);
                var title = $("<p></p>").append($(img).attr("alt"));
                var a = $("<a href=\'\'></a>").append(img);
                $(a).click(function () {
                    return selectPhoto();
                });
                $("#photo-pane ul").append($("<li></li>").append(id).append(a).append(title));
            };
        } else {
            return photoFail(data);
        };
    };
    var selectPhoto = function () {
        event.preventDefault();
        var targetImg = $(event.target);
        if (lead) {
            $("#lead-photo").val(targetImg.parent().siblings("span").html());
            var span = $("#lead-photo").siblings("span");
            span.html(targetImg);
            span.append($("<a id=\'unselect-lead-photo\' href=\'\'>Unselect photo. </a>"));
            $("#unselect-lead-photo").click(function () {
                return unselectLeadPhoto();
            });
        } else {
            var aTarget = $("<a href=\'\'></a>").append(targetImg);
            $("#nonlead-photo").siblings("span").append(aTarget);
            $(aTarget).click(function () {
                return nonleadPhotoUrl();
            });
        };
        return closePhotoPane();
    };
    var selectPhotoPaginationPrev = function () {
        event.preventDefault();
        selectPhotoPaginationDirection = "prev";
        selectPhotoPaginate = true;
        return selectPhotoCall(selectPhotoWho, selectPhotoNextPage[selectPhotoWho] - 2);
    };
    var selectPhotoPaginationNext = function () {
        event.preventDefault();
        selectPhotoPaginationDirection = "next";
        selectPhotoPaginate = true;
        return selectPhotoCall(selectPhotoWho, selectPhotoNextPage[selectPhotoWho]);
    };
    var uploadLeadPhotoInit = function () {
        lead = true;
        return uploadPhotoInit();
    };
    var uploadNonleadPhotoInit = function () {
        lead = false;
        return uploadPhotoInit();
    };
    var uploadPhotoInit = function () {
        event.preventDefault();
        createPhotoPane();
        $("#photo-pane ul").remove();
        uploadPhotoCall();
        return false;
    };
    var uploadPhotoCall = function () {
        return $.ajax({
            "url": "/ajax/photo/?d1m=" + getUrlParameter("d1m"),
            "data-type": "json",
            "async": false
        }).done(function (data) {
            return uploadPhotoGetDone(data);
        }).fail(function (data) {
            return photoFail(data);
        });
    };
    var uploadPhotoGetDone = function (data) {
        if (data.status === "success") {
            $("#photo-pane").append(data.data);
            $("#photo-pane form").submit(function () {
                return uploadPhotoSubmit();
            });
            $("#photo-pane .cat").change(function () {
                return changeCategory("#photo-pane");
            });
            tagsAutocomplete($("#photo-pane .tags"));
            return false;
        } else {
            return photoFail(data);
        };
    };
    var uploadPhotoSubmit = function () {
        event.preventDefault();
        $("#photo-pane form").ajaxSubmit({
            "data-type": "json",
            "async": false,
            "success": function (data, textStatus, jqXHR) {
                return uploadPhotoSubmitDone(data, textStatus, jqXHR);
            },
            "error": function (jqXHR, textStatus, errorThrown) {
                return ajaxFail(jqXHR, textStatus, errorThrown);
            }
        });
        return false;
    };
    var uploadPhotoSubmitDone = function (data, textStatus, jqXHR) {
        if (data.status === "success") {
            if (lead) {
                $("#lead-photo").val(data.data[0]);
                $("#lead-photo").siblings("span").html(data.data[1]);
            } else {
                var aTarget = $("<a href=\'\'></a>").append($(data.data[1]));
                $("#nonlead-photo").siblings("span").append(aTarget);
                $(aTarget).click(function () {
                    return nonleadPhotoUrl();
                });
            };
        } else {
            photoFail(data);
        };
        return closePhotoPane();
    };
    var sortCategories = function (ele) {
        return ele.nestedSortable({
            "handle": "div",
            "items": "li",
            "toleranceelement": "> div",
            "maxlevels": 1,
            "protectroot": true
        });
    };
    $(".cat").change(function () {
        return changeCategory("");
    });
    $("#article form").submit(function () {
        return articleSubmit();
    });
    $("#select-lead-photo").click(function () {
        return selectLeadPhotoInit();
    });
    $("#unselect-lead-photo").click(function () {
        return unselectLeadPhoto();
    });
    $("#upload-lead-photo").click(function () {
        return uploadLeadPhotoInit();
    });
    $("#select-nonlead-photo").click(function () {
        return selectNonleadPhotoInit();
    });
    $("#upload-nonlead-photo").click(function () {
        return uploadNonleadPhotoInit();
    });
    submitArticleAjax();
    tagsAutocomplete($(".tags"));
    sortCategories($("#sort-catsubcat"));
    return false;
});
