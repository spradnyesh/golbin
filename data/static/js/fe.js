function onLoad() {
    return ps($(document).ready(function () {
        var that = null;
        var subnav = null;
        var inNav = null;
        var carouselMove = 4;
        var displaySubcategory = function () {
            if (!inNav) {
                subnav = $("#subnav").children();
                $("#subnav").empty();
                $("#subnav").append($(this).children("ul").children());
                inNav = true;
                that = this;
            };
            return false;
        };
        var hideSubcategory = function () {
            if (inNav) {
                $(that).children("ul").append($("#subnav").children());
                $("#subnav").append(subnav);
                inNav = null;
                that = null;
            };
            return false;
        };
        var carouselPrev = function () {
            event.preventDefault();
            var parent19 = $(this).parent().parent();
            var prev = parent19.children("div.prev");
            var current = parent19.children("div.current");
            var next = parent19.children("div.next");
            var prevChildren = prev.children();
            if (prevChildren.length > 0) {
                next.append(current.children());
                current.append(prev.children()[prevChildren.length - 1]);
            };
            return false;
        };
        var carouselNext = function () {
            event.preventDefault();
            var parent20 = $(this).parent().parent();
            var prev = parent20.children("div.prev");
            var current = parent20.children("div.current");
            var next = parent20.children("div.next");
            var nextChildren = next.children();
            var lenNext = nextChildren.length;
            if (lenNext > 0) {
                prev.append(current.children());
                current.append(nextChildren[0]);
                if (lenNext === 1) {
                    var id = parent20.parent().children("span").html();
                    var pageTypeof = parent20.children("span").html().split(", ");
                    $.ajax({ "url" : pageTypeof[1].replace(/0/, pageTypeof[0]), "data-type" : "json" }).done(function (data) {
                        if (data.status === "success") {
                            parent20.children("span").html(1 + parseInt(pageTypeof[0]) + ", " + pageTypeof[1]);
                            return next.append(data.data);
                        } else {
                            return carouselFail(data);
                        };
                    }).fail(carouselFail(data));
                };
            };
            return false;
        };
        var carouselFail = function (data) {
            return false;
        };
        var commentReply = function () {
            event.preventDefault();
            $("#a-comments .parent").val($(this).attr("id"));
            $(this).parent().append($("#c-table").remove());
            $("#c-table").show();
            return false;
        };
        $("#prinav .cat").hover(displaySubcategory, function () {
            return null;
        });
        $("#nav").hover(function () {
            return null;
        }, hideSubcategory);
        $(".carousel p.prev a").click(carouselPrev);
        $(".carousel p.next a").click(carouselNext);
        $("#a-comments .c-reply a").click(commentReply);
        return false;
    }));
};
