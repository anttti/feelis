// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

const hooks = {};
hooks.setSession = {
  mounted() {
    if (document.cookie) {
      const id = document.cookie.split("=")[1];
      return;
    }
    const id = Math.round(Math.random() * 999999);
    fetch(`/api/session?user_id=${id}`, { method: "post" });
    document.cookie = `user_id=${id}`;
    this.pushEvent("new-user-id", { id });
  },
};

const drawCloud = (answers) => {
  const margin = { top: 10, right: 10, bottom: 10, left: 10 },
    width = 450 - margin.left - margin.right,
    height = 450 - margin.top - margin.bottom;

  const svg = d3
    .select("#answers")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  // Constructs a new cloud layout instance. It run an algorithm to find the position of words that suits your requirements
  // Wordcloud features that are different from one word to the other must be here
  const layout = d3.layout
    .cloud()
    .size([width, height])
    .words(answers.map((d) => ({ text: d.word, size: d.size })))
    .padding(5)
    .rotate(function () {
      return ~~(Math.random() * 2) * 90;
    })
    .fontSize((d) => d.size)
    .on("end", draw);
  layout.start();

  // This function takes the output of 'layout' above and draw the words
  // Wordcloud features that are THE SAME from one word to the other can be here
  function draw(words) {
    svg
      .append("g")
      .attr(
        "transform",
        "translate(" + layout.size()[0] / 2 + "," + layout.size()[1] / 2 + ")"
      )
      .selectAll("text")
      .data(words)
      .enter()
      .append("text")
      .style("font-size", (d) => d.size)
      .style("fill", "black")
      .attr("text-anchor", "middle")
      .style("font-family", "Impact")
      .attr("transform", function (d) {
        return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
      })
      .text((d) => d.text);
  }
};

hooks.drawWordCloud = {
  mounted() {
    drawCloud(answers);
  },
};

window.addEventListener("phx:add-answer", (e) => {
  drawCloud(e.detail.answers.map((word) => ({ word, size: "20" })));
});

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
