"""Build the reviewed, bilingual offline Judge Bite copy catalog."""
import json
from pathlib import Path

LINES = {
    "stern": [
        ("The court has ruled. Please direct all objections to your napkin.", "El tribunal ha decidido. Dirige tus objeciones a la servilleta."),
        ("A fair draw. A final ruling. Dinner may proceed.", "Sorteo justo. Veredicto final. Pueden empezar a comer."),
        ("Deliberation is over. Dinner is now in session.", "Terminó la deliberación. Comienza la cena."),
        ("This court recognizes your right to eat already.", "Este tribunal reconoce tu derecho a comer de una vez."),
        ("The record will show: indecision has been dismissed.", "Que conste en acta: la indecisión queda desestimada."),
        ("A verdict has been reached. Kindly alert the cutlery.", "Ya hay veredicto. Notifiquen a los cubiertos."),
        ("Chance chose. I made it official.", "El azar eligió. Yo lo hice oficial."),
        ("No further scrolling is required by this court.", "Este tribunal no exige seguir mirando el menú.")
    ],
    "sassy": [
        ("You brought the options. I brought the dramatic pause.", "Tú trajiste las opciones. Yo, la pausa dramática."),
        ("The hardest part is over. Now find a fork.", "Lo más difícil ya pasó. Ahora busca un tenedor."),
        ("Another menu debate, expertly interrupted.", "Otro debate sobre el menú, interrumpido con estilo."),
        ("A very official way to say: let's eat.", "Una forma muy oficial de decir: a comer."),
        ("My robe says judge. My schedule says dinner.", "Mi toga dice juez. Mi agenda dice cena."),
        ("Dinner picked. Group chat spared.", "Cena elegida. Chat de grupo a salvo."),
        ("I accept thank-you notes written on napkins.", "Acepto notas de agradecimiento en servilletas."),
        ("The plot twist is that we finally picked something.", "El giro de la trama: por fin elegimos algo.")
    ],
    "enthusiastic": [
        ("We have a winner! Give that dinner a tiny standing ovation.", "¡Tenemos ganador! Esa cena merece una ovación."),
        ("Order up! Your dinner adventure starts right here.", "¡Orden lista! Aquí empieza tu aventura de hoy."),
        ("Case closed, table open. Let's celebrate the little wins!", "Caso cerrado, mesa lista. ¡Celebremos esta pequeña victoria!"),
        ("One lucky pick. One less thing to decide. Hooray!", "Una elección al azar. Una decisión menos. ¡Qué bien!"),
        ("Sound the dinner bell! We made a decision!", "¡Que suene la campana! ¡Ya decidimos!"),
        ("A round of applause for finally choosing dinner!", "¡Un aplauso por haber elegido la cena!"),
        ("That's our pick! The court is positively delighted.", "¡Esa es la elección! El tribunal está encantado."),
        ("The menu mystery is solved. On to the eating part!", "Misterio del menú resuelto. ¡Ahora toca comer!")
    ],
    "chill": [
        ("There we go. One less thing on your plate.", "Listo. Una decisión menos de qué preocuparse."),
        ("Let chance do the choosing. You can do the eating.", "Que el azar elija. Tú encárgate de comer."),
        ("A little luck, a little lunch. Works for me.", "Un poco de suerte y algo de comer. Me parece bien."),
        ("No more menu loops. Take it from here.", "Se acabaron las vueltas al menú. Te toca disfrutar."),
        ("Easy does it. Your pick is ready.", "Con calma. Tu elección está lista."),
        ("That's settled. Take your time and enjoy.", "Asunto resuelto. Disfruta sin prisa."),
        ("The decision part is done. Nice.", "Ya terminamos de decidir. Qué bien."),
        ("We kept it simple. Sometimes that's the whole plan.", "Lo hicimos sencillo. A veces, ese es todo el plan.")
    ],
    "wheel": [
        ("The plate has spoken. The court will hear no hangry objections.", "El plato ha hablado. El tribunal no admite objeciones con hambre."),
        ("Round and round we went. Dinner is where we landed.", "Dimos unas cuantas vueltas. Y aterrizamos en la cena."),
        ("Equal slices of luck. One very official dinner.", "Porciones iguales de suerte. Una cena muy oficial.")
    ],
    "ticket": [
        ("Your number is up. In the deliciously ordinary dinner sense.", "Salió tu número. Y esta vez solo significa que hay cena."),
        ("One ticket pulled. One menu debate retired.", "Un boleto elegido. Un debate del menú jubilado."),
        ("Order up! This little ticket has big dinner energy.", "¡Orden lista! Este boleto viene con ganas de cenar.")
    ],
    "cloche": [
        ("A little suspense. A very official reveal.", "Un poco de suspenso. Una revelación muy oficial."),
        ("The lid is lifted. The dinner mystery is over.", "Levantamos la tapa. Terminó el misterio de la cena."),
        ("Consider this the court's grand ta-da.", "Este es el gran ¡tachán! del tribunal.")
    ],
    "coin": [
        ("Two sides. One answer. The coin has done its duty.", "Dos caras. Una respuesta. La moneda cumplió su deber."),
        ("A small flip for the court. A big relief for dinner.", "Un lanzamiento para el tribunal. Un alivio para la cena."),
        ("The coin landed. The menu debate did too.", "La moneda cayó. Y el debate del menú también.")
    ]
}
entries = []
for group, pairs in LINES.items():
    is_tone = group in ("stern", "sassy", "enthusiastic", "chill")
    for index, (en, es) in enumerate(pairs, 1):
        entries.append({"id":f"{group}-{index:02}", "tone": group if is_tone else "any", "methods":["wheel","ticket","cloche","coin"] if is_tone else [group], "text":{"en":en,"es":es}})
output = {"version":1,"purpose":"Offline random verdict banter; never presented as AI reasoning or food analysis.","selection":"Shuffle bag per tone + method + locale; no repeats until every eligible line is used, and no immediate boundary repeat.","entries":entries}
Path(__file__).with_name('judge-sayings.json').write_text(json.dumps(output,ensure_ascii=False,indent=2)+"\n")
print(f"{len(entries)} entries × 2 languages")
