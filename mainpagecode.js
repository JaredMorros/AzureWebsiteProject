var funky = false

function Saxophone(){
    const button = document.querySelector('button')
    const saxophoneaudio = document.getElementById("saxophoneaudio")
    if (funky == false){
        document.getElementById("saxaboom").style.display = "block";
        funky = true;
        button.innerText = "NO WAIT GO BACK"
        saxophoneaudio.onload();
        saxophoneaudio.play();
    }
    else{
        document.getElementById("saxaboom").style.display = "none";
        funky = false;
        button.innerText = "Get funky again?";
        saxophoneaudio.pause();
    }
}