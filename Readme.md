# LaTeX-Vorlagen für den Kammerchor Wernigerode

## Anleitung

### Briefe schreiben

Verwende die Klasse `scrlttr2` und gib nach dem Laden der Klasse
`\LoadLetterOption{kcw-brief}` an. Dafür müssen die Dateien
[tex/kcw-brief.lco](tex/kcw-brief.lco) und
[Logos/kch-logo-dunkel.png](Logos/kch-logo-dunkel.png) irgendwo liegen, wo LaTeX
sie finden kann, zum beispiel im selben Ordner wie die Quelldatei des Briefs den
du schreibst.

### Nix benutzen

Dieses Repo verwendet den Paketmanager [Nix](https://nixos.org), um eine
reproduzierbare Umgebung, die alle erforderlichen LaTeX-Pakete und Schriftarten
enthält, bereitzustellen. Nachdem du Nix installiert hast, musst du noch [Nix
Flakes aktivieren](https://nixos.wiki/wiki/Flakes) (Abschnitt "Enable Flakes").

#### Vorlagen kompilieren

Mit `nix build` werden alle Dokumente, die im Order [Vorlagen](Vorlagen) liegen,
kompiliert. Die Ausgabedateien liegen dann unter `result`.

Achtung: Beim ersten `nix ...`-Befehl wird Nix alle Abhängigkeiten
herunterladen. Insbesondere die Schriftarten sind recht schwer, also stell' dich
auf etwas Wartezeit ein.

Im Ordner [Vorlagen/kompiliert](Vorlagen/kompiliert) kann man auch hier schon
einmal die kompilierten Beispiele anschauen. (TODO: Das kann GitHub bestimmt
automatisieren...)

#### Neue Dokumente schreiben

Mit `nix develop` betrittst du eine Entwicklungsumgebung, in der alle nötigen
Werkzeuge vorhanden sind, um Kammerchor-LaTeX-Dokumente zu kompilieren.

Der Befehl `latexrun dein-tolles-dokument.tex` sollte in allen
Unterordnern funktionieren und `dein-tolles-dokument.pdf` erzeugen. (Du musst
dafür insbesondere nicht die Dateien unter [tex](tex) oder [Logos](Logos) in
deinen momentanen Arbeitsordner oder sonstwo hin kopieren.)
