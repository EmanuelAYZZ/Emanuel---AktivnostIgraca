window.addEventListener("message", (event) => {
  if (event.data.akcija === "otvori") {
    document.getElementById("panel").style.display = "block";
  }
});

function posaljiPrijavu() {
  const igrac = document.getElementById("igrac").value;
  const razlog = document.getElementById("razlog").value;
  fetch(`https://${GetParentResourceName()}/posaljiPrijavu`, {
    method: "POST",
    body: JSON.stringify({ igrac, razlog }),
    headers: { "Content-Type": "application/json" }
  });
}

function zatvoriUI() {
  document.getElementById("panel").style.display = "none";
  fetch(`https://${GetParentResourceName()}/zatvori`, {
    method: "POST",
    body: JSON.stringify({})
  });
}
