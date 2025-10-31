// ================================= declaration des variables
const startnow = document.querySelector('.animation')
const toggle = document.querySelector('.toggle')
const menu = document.querySelector('.menu')
const submit = document.querySelector('#submit')
const plagiat_faux = document.querySelector('.plagiat-faux')
const plagiat_vrai = document.querySelector('.plagiat-vrai')
const div_text1 = document.querySelector('#div-text1')
const div_text2 = document.querySelector('#div-text2')


//gestion des pourcentage
if(plagiat_faux != undefined){
    pourcentage_faux = parseFloat(plagiat_faux.dataset.score)
    pourcentage_vrai = 100 - pourcentage_faux
    plagiat_faux.style.width =`${pourcentage_faux}%`
    plagiat_vrai.style.width =`${pourcentage_vrai}%`
    if(pourcentage_faux<50){
        plagiat_faux.style.backgroundColor='red'
        plagiat_vrai.style.backgroundColor='green'
    }
    else{
        plagiat_faux.style.backgroundColor='green'
        plagiat_vrai.style.backgroundColor='red'
    }
}



// ================================== function  qui gerre l'animation de start now

function addRemoveanimation(){
    startnow.classList.add('active')
    setTimeout(()=>{
        startnow.classList.remove('active')
        setTimeout(addRemoveanimation,1000)
    },1000)
}



addRemoveanimation();
// ====================================== partir du code qui met et enleve la div concerner

toggle.addEventListener('click',function(){
    menu.classList.toggle('active')
})
document.addEventListener('click', function (e) {
    if (!toggle.contains(e.target) && !menu.contains(e.target) ) {
        setTimeout(function () {
            menu.classList.remove('active')
        }, 10)

    }

})



submit.addEventListener('click',()=>{
    let text1 = document.querySelector('#text1').value
    let text2 = document.querySelector('#text2').value

    console.log(text1)

    div_text1.textContent=text1
    div_text2.textContent=text2


})


