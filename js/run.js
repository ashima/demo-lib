function run() {
    // the first article in the page is the one we show
    var vdiv = document.getElementsByTagName('article')[0];
    var container = $$("demo-frontis");

    window.onpopstate = function (e) {
	if (e.state != null && e.state.webgl == 1) {
	    container.style.display = "none";
	    vdiv.style.display = "block";
	} else {
	    container.style.display = "block";
	    vdiv.style.display = "none";
	}
    };
    history.replaceState({webgl:0},"");
    history.pushState({webgl:1},"");

    container.style.display = "none";
    vdiv.style.display = "block";

    main();
}
