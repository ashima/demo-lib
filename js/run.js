var run_main = false;
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
    if (!run_main) {
	window.onpopstate = function (e) {
	    if (e.state != null && e.state.webgl == 1) show_demo();
	    else show_frontis();
	};
	history.replaceState({webgl:0},"");
	history.pushState({webgl:1},"");

	show_demo();

	main();

	run_main = true;
    } else show_demo();
}
