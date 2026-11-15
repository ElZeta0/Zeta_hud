const hud = document.getElementById('hud');
const barraVita = document.getElementById('barraVita');
const barraArmatura = document.getElementById('barraArmatura');
const valoreVita = document.getElementById('valoreVita');
const valoreArmatura = document.getElementById('valoreArmatura');
const contachilometri = document.getElementById('contachilometri');
const velocita = document.getElementById('velocita');
const logoImmagine = document.getElementById('logoImmagine');
const BoxArmatura = document.getElementById('nascArmatura');

const idPlayer = document.getElementById('id');

function limitaPercentuale(valore) {
    const numero = Number(valore);
    if (!Number.isFinite(numero)) return 0;
    return Math.max(0, Math.min(100, Math.round(numero)));
}

function aggiornaBarra(elemento, etichetta, valore) {
    const percentuale = limitaPercentuale(valore);
    elemento.style.width = `${percentuale}%`;
    etichetta.textContent = `${percentuale}%`;
}

window.addEventListener('message', (event) => {
    const messaggio = event.data || {};
    const dati = messaggio.dati || {};

    switch (messaggio.azione) {
        case 'aggiorna':
            aggiornaBarra(barraVita, valoreVita, dati.vita);
            aggiornaBarra(barraArmatura, valoreArmatura, dati.armatura);

            if (limitaPercentuale(dati.armatura) <= 0) {
                BoxArmatura.style.display = 'none';
            } else {
                BoxArmatura.style.display = 'flex';
            }
            
            if (typeof dati.velocita !== 'undefined') {
                velocita.textContent = Math.max(0, Number(dati.velocita) || 0);
            }
            
            idPlayer.textContent = dati.idPlayer
            

            hud.classList.toggle('in-veicolo', dati.inVeicolo === true || dati.inVeicolo === 1);
            hud.classList.toggle('nascosto', dati.visibile === false);
            break;


        case 'veicolo': 
            const visibile = dati.visibile === true || dati.visibile === 1;

            console.log('[HUD] Veicolo:', visibile);

            contachilometri.classList.toggle('visibile', visibile);

            break;


        case 'visibilita':
            hud.classList.toggle('nascosto', dati.visibile === false);
            break;
    }
});

logoImmagine.addEventListener('load', () => {
    logoImmagine.style.display = 'block';
});

logoImmagine.addEventListener('error', () => {
    logoImmagine.style.display = 'none';
});
