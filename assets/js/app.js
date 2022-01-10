import "../css/app.scss";

import "phoenix_html";
import { Socket } from "phoenix";
import topbar from "topbar";
import { LiveSocket } from "phoenix_live_view";

let Hooks = {};

Hooks.Messages = {
  mounted() {
    setTimeout(() => {
      this.el.scrollTo({ top: this.el.scrollHeight, behavior: "smooth" });
    }, 10);

    this.handleEvent("message", ({ valid }) => {
      if (valid) this.scroll();
    });
  },

  scroll() {
    this.el.scrollTo(0, this.el.scrollHeight);
  },
};

Hooks.Input = {
  mounted() {
    this.handleEvent("input", () => {
      this.el.value = "";
    });
  },
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } });

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
