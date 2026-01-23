#import "./layout/ba.typ": *

== Framework

Die Generation wird in drei Stufen aufgeteilt. 
1. "Composer" Ein Graphischer Editor indem ein Nutzer eine Generations Regeln und Abhängigkeiten einstellen kann. 
Hier für habe ich Node Graph System genutzt. 

#todo("Warum? 
- Mann kann leicht dafür sorgen dass die Konfiguartion valid ist. 
- Abhängigkeiten leichter erkennbar")

2. "Template" Eine Datenstruktur die alle Abhängigkeiten darstellt.  

3. "Collapser" Stellt die aktuelle Welt da. 
Nimmt ein neues "Template" und  ändert alles was nötig ist damit die Welt dem neuen "Template" entspricht.

#todo("Sollte ich die Stufen nochmal umbenennen? Gerade collapser ergibt nicht so viel sinn.")

=== Composer 

=== Template 

Das Template besteht aus zwei Graphen. 

$"Template" := (G_"val", G_"dep")$

$G_"val" := (V_"val", E_"val")$ ist ein Graph der die zu generierende Welt als Mathematische Formel beschreibt. 
Es gilt folgende Datentypen: 
- Zahlen 
- Positionen 
- Volumen (als CSG implementiert)
- Eine Menge Positionen die nach einer Regel definiert sind

#todo("Ist Datentypen wirklich das beste Wort oder lieber Wert?")

Für Positions Mengen habe ich Gitter und pseudo zufällige Verteilung implementiert.

Datentypen sind meist durch andere Datentypen definiert z.B. 
ist eine 3D Position durch 3 Zahlen definiert. 

Ein $v_"val" in V_"val"$ hat folgende Eigenschaften: 

$delta^-(v_"val") := "Werte die für die Errechnung genutzt werden."$

$delta^+(v_"val") := "Werte indem es für die Errechnung genutzt wird."$

Daher spannt ein 

#todo("In related Work zeigen dass es ok ist ein Graph so zu deffienieren");


Der zweite Bestandteil des Templates ist der Abhängigkeits-Graph $G_"dep" := (V_"dep", E_"dep")$. 

Einer Untermenge der Werte $v_"val" in V_"val"$ ist ein Knoten $v_"dep" in V_"dep"$ zugeordnet, beschrieben durch die Funktion $"val"(v_"dep")$.

Bei der generation Welt wird nicht nur das finale Ergebnisse sondern auch die Werte der $v_"dep"$ gespeichert.
So kann bei einer Regeländerung weithin valide Werte wiederverwendet werden.
Dies macht die "lazyness" meines Ansatzes aus. 

Bei der Entscheidung wie vielen Werten ein $v_"dep"$ zu geordnet wird muss zwischen dem "Overhead" und der Zeitersparniss durch wiederverwendung des Wertes abgewägt werden. 

Im meiner Implementierung speichere ich alle Positions Mengen Werte zwischen. 

Die Knoten im Abhängigkeits-Graph speichern von welchen andern Knoten sie abhängen $delta^-(v_"dep")$,
also alle Knoten in $G_"dep"$ dessen Werte zur Errechnung genutzt werden.

#todo("Wie sage ich das es nur die nächsten sind?")

#todo("Grafik von Datentypen und Abhängigkeits-Graph")


=== Collapser

Der Collapser enthält einen Graphen der den errechneten Template entspricht.
Dazu eine Queue an Aufträgen der noch zu erzeugenden und errechnenden Knoten. Diese Listen sind nach Level der Knoten sortiert. 
Der Collapser führt die Aufträge der Queue iterativ aus bis es keine Aufträge mehr gibt.

==== Formale Definition

$"Collapser" := (G_"col", Q)$

$G_"col" := (V_"col", E_"col")$

Ein $v_"col" in V_"col"$ hat folgende Eigenschaften: 

$delta^-(v_"col") := "Collapser Knoten die zur Errechnung benötigt werden."$

$t(v_"col") := "Der Template Knoten der dem Collapser Knoten entspricht."$

$"created"(v_"col") := "Der Knoten der diesen Knoten erzeugt hat."$

$forall v_i in delta^-(v_"col") quad "data"(v_"col", v_i) := "Der Wert des ahängigen Knoten der diesem Knoten zu geordnet ist."$


$Q$ ist die Queue in Aufträgen 
Jeder Auftrag $q in Q$ hat ein Level $l(q)$. 
Dieses entspricht bei Erzeugungs-Aufträgen dem Level des zeugenden Knoten 
und bei Errechnungs-Aufträgen das Level des des zu errechnen Knoten.

$"pop"(Q) := min_(q in Q) (l(q))$


==== Erzeugungs Aufträge 
Erzeugungs Aufträge enthalten den Index eines Knoten im Collapser Graph und den Index eines Erzeugungs-Eintrag in dessen Template-Knoten.
Dieser Erzeugungs-Eintrag definiert entweder dass es genau $n$ Knoten geben soll, oder die Zahl vom Datentypen abhängt.

Darauf wird die vorhandene Menge an Kindern mit der gewünschten Menge verglichen und bei Ungleichheit neue Kinder Knoten erzeugt / gelöscht. 

#todo("Algorithmus")

==== Wenn ein Knoten erzeugt wird 
Wenn ein Knoten erzeugt werden die Knoten von dem er im Template abhängt im Collapser-Graph gesucht.
Hierfür werden die vorerrechneten relativen Schritte verwendet die wie eine Weganweisung dienen um den Collapser-Graph von dem neu erzeugten Knoten zu sein Abhängigkeiten zu gelangen.  

#todo("Algorithmus")

==== Wenn ein Knoten gelöscht wird
Wenn ein Knoten gelöscht wird werden rekursiv alle Knoten gelöscht die von ihm abhängen. 

#todo("Algorithmus")


=== Errechnungs Aufträge 
Errechnungs Aufträge errechnen den Wert von einem Knoten neu. 

Dabei wird die der DAG der die Formel des Wert beschreibt rekursiv gelöst.

Wenn die Formel Hooks zu anderen Template Knoten enthält werden die entsprechenden Knoten in der Liste der Abhängigen Knoten des "Collapser" Knoten gesucht und die Werte zu Errechnung der Formel genutzt. 

Grundlegende Eigenschaft des Systems ist das es mehrere Knoten im Collapser für einen Knoten im Template geben kann.
Und so einen für eine Hook eine Liste an Werten gefunden wird. 

Daher sind alle Operationen zum errechnen der Formel als Operationen auf Listen geschrieben.

#todo("Beispiel")


=== Abhängigkeits Kreise und Levels
Das Template kann Abhängigkeits Kreise enthalten. 
Um trotzdem eine valide Lösung errechnen zu können muss es für jeden Knoten $v_"val"$ einen validen Null Wert geben. 

So kann der Abhängigkeits Graph iterativ gelöst werden. 
Dazu werden pro Kreis im Abhängigkeits-Graph eine Kante als durchgeschnitten markiert 
$delta^+_"cut" (v_"dep") subset.eq delta^+(v_"dep")$.
Der Abhängigkeits-Graph ohne die durch geschnittenen Kanten 
$delta^+_"not cut" (v_"dep") := delta^+(v_"dep") without delta^+_"cut" (v_"dep")$ ist ein DAG. 
Also kann jedem Knoten ein Level $l(v_"dep")$ zu geordnet werden. 
$
  l(v_"dep") > l(v_i) quad forall v_i in delta^+_"cut not" (v_"dep")
$

Die Knoten werden Level nach Level erzeugt und so sichergestellt das alle nicht geschnittenen Abhängigkeiten schon errechnet worden sind, wenn der Knoten selbst errechnet wird. 
Hat ein Knoten geschnittene Abhängigkeiten werden diese zu Errechnung genutzt wenn sie existiert. Andernfalls wird der Null Wert verwendet.
Jeder Knoten der Null Werte für seine geschnittenen Abhängigkeiten nutzt wird nochmal errechnet, sobald alle Knoten einmal errechnet wurden.  
Dies wird so lange wiederholt bis keine Null Werte mehr verwendet worden sind.

=== Vorrechnete Schritte zu Abhängigkeiten

Um zu vermeiden, dass im Collapser alle Knoten durchsucht werden müssen um die abhängigen Knoten zu finden, 
werden speichert jeder Knoten im Abhängigkeits-Graph die relativen Schritte zu den Knoten von den er abhängig ist. 

Um nun die alle abhängigen Knoten im Collapser Graph zu finden können diese Relativen Schritte wie eine Wegbeschreibung genutzt werden.

#todo("Vielleicht ein Beispiel")

==== Implementierung 

In der Implementierung wird zwischen geschnittenen und nicht geschnittenen Abhängigkeiten unterschieden.

Die nicht geschnittenen Abhängigkeiten sind als ein Baum an Schritten implementiert. 
Schritte gehen entweder hoch in ein Knoten vom dem dieser abhängig ist, oder runter ein einen Knoten der von diesem abhängt. 

Wenn ein neuer Knoten im Collapser erzeugt wird, wird der Baum genutzt um alle abhängigen Knoten im Collapser zu finden.

Geschnittene Abhängigkeiten werden als Weg an Schritten gespeichert und erst gesucht, wenn deren Wert benötigt wird, 
Geschnittene Abhängigkeiten haben ein höheres Level als der Knoten selbst und existieren zur Zeit des Knoten wahrscheinlich noch nicht.


