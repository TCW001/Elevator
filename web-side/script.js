window.addEventListener("message", function(event) {
  const data = event.data;
  const overlay = document.getElementById('overlay');

  if (data.action === "open") {
    document.body.style.display = "flex";
    document.getElementById("floors").innerHTML = "";

    for (const key in data.data) {
      const btn = document.createElement("button");
      btn.innerText = "Andar " + key;

      btn.onclick = () => {
        overlay.classList.add('active');  // mostra overlay
        const audio = new Audio('sounds/elevator.ogg');
        audio.volume = 0.4;
        audio.play();

        // espera 1.5 segundos para o som/overlay aparecer
        setTimeout(() => {
          fetch(`https://${GetParentResourceName()}/goToFloor`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ floor: key })
          });
        }, 1500);
      };

      document.getElementById("floors").appendChild(btn);
    }
  }

  if (data.action === "close") {
    overlay.classList.remove('active');  // esconde overlay
    document.body.style.display = "none";
  }
});