var demo_run = false;
function run() {
    // the first article in the page is the one we show
    var vdiv = document.getElementsByTagName('article')[0];
    var container = $$("demo-frontis");
    function show_demo() {
        container.style.display = "none";
        vdiv.style.display = "";	
    }
    function show_frontis() {
        container.style.display = "";
        vdiv.style.display = "none";
    }
    if (!demo_run) {
	window.onpopstate = function (e) {
            if (e.state != null && e.state.webgl == 1) {
		show_demo();
		main();
	    } else show_frontis();
        };
        history.replaceState({webgl:0},"");
        history.pushState({webgl:1},"");

        show_demo();

        main();

        demo_run = true;
    } else {
        history.pushState({webgl:1},"");
        show_demo();
        main();
    }
}
